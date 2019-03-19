#ifndef PHANIDE_INTERNAL_H
#define PHANIDE_INTERNAL_H

#include <phanide/phanide.h>
#include <stddef.h>
#include <assert.h>
#include <stdlib.h>
#include <string.h>
#include "threads.h"

typedef void (*phanide_destructor_t) (void *pointer);

static inline char *
phanide_strdup(const char *string)
{
    size_t stringLength = strlen(string);
    char *result = (char*)malloc(stringLength + 1);
    memcpy(result, string, stringLength);
    result[stringLength] = 0;
    return result;
}
typedef struct phanide_linked_list_node_s
{
    struct phanide_linked_list_node_s *previous;
    struct phanide_linked_list_node_s *next;
} phanide_linked_list_node_t;

typedef struct phanide_event_node_s
{
    phanide_linked_list_node_t header;
    phanide_event_t event;
} phanide_event_node_t;

typedef struct phanide_linked_list_s
{
    phanide_linked_list_node_t *first;
    phanide_linked_list_node_t *last;
} phanide_linked_list_t;

static inline void
phanide_linked_list_removeNode(phanide_linked_list_t *list, phanide_linked_list_node_t *node)
{
    assert(list);
    assert(node);

    /* Remove the previous link*/
    if(node->previous)
        node->previous->next = node->next;
    else
        list->first = node->next;

    /* Remove the next link*/
    if(node->next)
        node->next->previous = node->previous;
    else
        list->last = node->previous;
    node->previous = NULL;
    node->next = NULL;
}

static inline void
phanide_linked_list_pushBack(phanide_linked_list_t *list, phanide_linked_list_node_t *node)
{
    assert(!node->previous);
    assert(!node->next);

    node->previous = list->last;
    if(list->last)
        list->last->next = node;
    list->last = node;

    if(!list->first)
        list->first = node;
}

static inline void
phanide_linked_list_destroyData(phanide_linked_list_t *list, phanide_destructor_t destructor)
{
    phanide_linked_list_node_t *nextNode = list->first;
    while(nextNode)
    {
        phanide_linked_list_node_t *node = nextNode;
        nextNode = nextNode->next;
        destructor(node);
    }
}

static inline void
phanide_linked_list_freeData(phanide_linked_list_t *list)
{
    phanide_linked_list_destroyData(list, free);
}

typedef struct phanide_list_s
{
    size_t capacity;
    size_t size;
    void **data;
} phanide_list_t;

static inline void
phanide_list_increaseCapacity(phanide_list_t *list)
{
    size_t newCapacity = list->capacity*2;
    if(newCapacity <= 16)
        newCapacity = 16;

    size_t newDataSize = newCapacity*sizeof(void*);
    void **newData = (void**)malloc(newDataSize);
    memset(newData, 0, newDataSize);

    for(size_t i = 0; i < list->size; ++i)
        newData[i] = list->data[i];
    free(list->data);
    list->data = newData;
    list->capacity = newCapacity;
}

static inline void
phanide_list_pushBack(phanide_list_t *list, void *value)
{
    if(list->size >= list->capacity)
        phanide_list_increaseCapacity(list);
    list->data[list->size++] = value;
}

static inline void
phanide_list_destroyData(phanide_list_t *list, phanide_destructor_t destructor)
{
    for(size_t i = 0; i < list->size; ++i)
        destructor(list->data[i]);
}

static inline void
phanide_list_freeData(phanide_list_t *list)
{
    phanide_list_destroyData(list, free);
}

#endif /*PHANIDE_INTERNAL_H*/
