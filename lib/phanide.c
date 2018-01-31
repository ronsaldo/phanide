#include "internal.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef intptr_t (*signalSemaphoreWithIndex_t) (intptr_t index);

struct phanide_context_s
{
    phanide_thread_t thread;

    /* Control mutex */
    phanide_mutex_t controlMutex;
    int shuttingDown;

    intptr_t pendingEventsSemaphoreIndex;
    signalSemaphoreWithIndex_t signalSemaphoreWithIndex;

    /* Event queue */
    phanide_mutex_t eventQueueMutex;
    phanide_condition_t pendingEventCondition;
    phanide_linked_list_t eventQueue;

    /* IO*/
    phanide_context_io_t io;
};


static void *phanide_processThreadEntry(void *arg);
static int phanide_createContextIOPrimitives(phanide_context_t *context);
static void phanide_wakeUpSelect(phanide_context_t *context);
static void phanide_context_destroyIOData(phanide_context_t *context);

PHANIDE_CORE_EXPORT phanide_context_t *
phanide_createContext(intptr_t pendingEventsSemaphoreIndex)
{
    /* Allocate the context*/
    phanide_context_t *context = (phanide_context_t*)malloc(sizeof(phanide_context_t));
    memset(context, 0, sizeof(phanide_context_t));
    context->pendingEventsSemaphoreIndex = pendingEventsSemaphoreIndex;

    if(!phanide_createContextIOPrimitives(context))
    {
        free(context);
        return NULL;
    }

    /* Initialize the synchronization primitives. */
    phanide_mutex_init(&context->controlMutex);

    phanide_mutex_init(&context->eventQueueMutex);
    phanide_condition_init(&context->pendingEventCondition);

    /* Start the thread*/
    phanide_thread_create(&context->thread, phanide_processThreadEntry, context);

    return context;
}

PHANIDE_CORE_EXPORT void
phanide_destroyContext(phanide_context_t *context)
{
    if(!context)
        return;

    /* Set the shutting down condition. */
    {
        phanide_mutex_lock(&context->controlMutex);
        context->shuttingDown = 1;
        phanide_condition_broadcast(&context->pendingEventCondition);
        phanide_wakeUpSelect(context);
        phanide_mutex_unlock(&context->controlMutex);
    }

    /* Wait for the working thread to finish. */
    void *returnValue = NULL;
    pthread_join(context->thread, &returnValue);

    phanide_mutex_destroy(&context->controlMutex);

    phanide_mutex_destroy(&context->eventQueueMutex);
    phanide_condition_destroy(&context->pendingEventCondition);

    phanide_context_destroyIOData(context);
    phanide_linked_list_freeData(&context->eventQueue);
    free(context);
}

PHANIDE_CORE_EXPORT void *
phanide_malloc(size_t size)
{
    return malloc(size);
}

PHANIDE_CORE_EXPORT void
phanide_free(void *pointer)
{
    free(pointer);
}

/* Events */
PHANIDE_CORE_EXPORT int
phanide_pollEvent(phanide_context_t *context, phanide_event_t *event)
{
    int result = 0;
    phanide_mutex_lock(&context->eventQueueMutex);
    if(context->eventQueue.first)
    {
        phanide_event_node_t *eventNode = (phanide_event_node_t*)context->eventQueue.first;
        *event = eventNode->event;

        phanide_linked_list_removeNode(&context->eventQueue, (phanide_linked_list_node_t *)eventNode);
        free(eventNode);
        result = 1;
    }

    phanide_mutex_unlock(&context->eventQueueMutex);
    return result;
}

PHANIDE_CORE_EXPORT int
phanide_waitEvent(phanide_context_t *context, phanide_event_t *event)
{
    int result = 0;
    phanide_mutex_lock(&context->eventQueueMutex);

    /* Wait for an event, or shutting down. */
    while (!context->eventQueue.first && !context->shuttingDown)
        phanide_condition_wait(&context->pendingEventCondition, &context->eventQueueMutex);

    /* Extract the event from the queue. */
    if(context->eventQueue.first)
    {
        phanide_event_node_t *eventNode = (phanide_event_node_t*)context->eventQueue.first;
        *event = eventNode->event;

        phanide_linked_list_removeNode(&context->eventQueue, (phanide_linked_list_node_t *)eventNode);
        free(eventNode);
        result = 1;
    }

    phanide_mutex_unlock(&context->eventQueueMutex);
    return result;
}

PHANIDE_CORE_EXPORT int
phanide_pushEvent(phanide_context_t *context, phanide_event_t *event)
{
    phanide_event_node_t *node = malloc(sizeof(phanide_event_node_t));
    memset(node, 0, sizeof(phanide_event_node_t));
    node->event = *event;

    phanide_mutex_lock(&context->eventQueueMutex);

    phanide_linked_list_pushBack(&context->eventQueue, (phanide_linked_list_node_t *)node);

    phanide_condition_signal(&context->pendingEventCondition);
    phanide_mutex_unlock(&context->eventQueueMutex);

    /* Notify the VM about the event. */
    printf("context->signalSemaphoreWithIndex %p\n", context->signalSemaphoreWithIndex);
    if(context->signalSemaphoreWithIndex)
        context->signalSemaphoreWithIndex(context->pendingEventsSemaphoreIndex);
    return 0;
}
