#ifndef _WIN32

#define _GNU_SOURCE
#include "internal.h"
#include <unistd.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <unistd.h>
#include <dirent.h>
#include <dlfcn.h>

#define PHANIDE_STDIN_PIPE_INDEX 0

#define PHANIDE_MASK_FOR_BIT_COUNT(bc) ((((uint64_t)1) << bc) - 1)

#define PHANIDE_EVENT_DESCRIPTOR_TYPE_MASK PHANIDE_MASK_FOR_BIT_COUNT(3)
#define PHANIDE_EVENT_DESCRIPTOR_TYPE_SHIFT 0

#define PHANIDE_EVAL_MACRO1(x) x
#define PHANIDE_EVENT_DESCRIPTOR_FIELD_GET(x, fn) (x >> PHANIDE_EVAL_MACRO1(PHANIDE_EVENT_DESCRIPTOR_ ## fn ## _SHIFT)) & PHANIDE_EVAL_MACRO1(PHANIDE_EVENT_DESCRIPTOR_ ## fn ## _MASK)
#define PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(x, fn, v) (x | ((v & PHANIDE_EVAL_MACRO1(PHANIDE_EVENT_DESCRIPTOR_ ## fn ## _MASK)) << PHANIDE_EVAL_MACRO1(PHANIDE_EVENT_DESCRIPTOR_ ## fn ## _SHIFT)))

#define PHANIDE_EVENT_DESCRIPTOR_SUBPROCESS_PIPE_MASK PHANIDE_MASK_FOR_BIT_COUNT(3)
#define PHANIDE_EVENT_DESCRIPTOR_SUBPROCESS_PIPE_SHIFT 3

#define PHANIDE_EVENT_DESCRIPTOR_SUBPROCESS_INDEX_MASK PHANIDE_MASK_FOR_BIT_COUNT(58)
#define PHANIDE_EVENT_DESCRIPTOR_SUBPROCESS_INDEX_SHIFT 6

typedef enum phanide_fd_event_descriptor_type_e
{
    PHANIDE_FD_EVENT_WAKE_UP = 0,
    PHANIDE_FD_EVENT_SUBPROCESS_PIPE,
    PHANIDE_FD_EVENT_INOTIFY
} phanide_fd_event_descriptor_type_t;

#if defined(linux)

#define USE_EPOLL 1
#define USE_EVENT_FD 1
#define USE_INOTIFY 1

#define USE_SELECT_AS_CONDITION 1

#include <sys/epoll.h>
#include <sys/eventfd.h>
#include <sys/inotify.h>

typedef union phanide_inotify_event_buffer_s
{
    int wd; /* For alignment purposes */
    uint8_t bytes[sizeof(struct inotify_event) + NAME_MAX + 1];
}phanide_inotify_event_buffer_t;

#elif defined(__APPLE__)
#include <sys/types.h>
#include <sys/event.h>

#define USE_KQUEUE 1
#endif

typedef struct phanide_context_io_s
{
#ifdef USE_EPOLL
    int epollFD;
    int eventFD;
#endif

#ifdef USE_KQUEUE
    int kqueueFD;
#endif

    phanide_mutex_t processListMutex;
    phanide_list_t processList;

#ifdef USE_INOTIFY
    int inotifyFD;
    phanide_inotify_event_buffer_t inotifyEventBuffer;
#endif

    phanide_mutex_t fsmonitorMutex;

} phanide_context_io_t;

#include "phanide.c"

static phanide_process_t *phanide_process_getFromIndex(phanide_context_t *context, size_t index);
static void phanide_process_destructor (void *arg);
static void phanide_process_pendingData(phanide_process_t *process, int pipeIndex);
static void phanide_process_pipeHungUpOrError(phanide_process_t *process, int pipeIndex);

#if defined(USE_INOTIFY)
static void phanide_inotify_pendingEvents(phanide_context_t *context);
#endif

static int
phanide_createContextIOPrimitives(phanide_context_t *context)
{
#if defined(USE_EPOLL)
    /* epoll */
    context->io.epollFD = epoll_create1(EPOLL_CLOEXEC);
    if(context->io.epollFD < 0)
        return 0;

    /* event fd */
    context->io.eventFD = eventfd(0, EFD_CLOEXEC);
    if(context->io.eventFD < 0)
    {
        close(context->io.epollFD);
        return 0;
    }

    {
        struct epoll_event event;
        event.events = EPOLLIN;
        event.data.u64 = 0;
        epoll_ctl(context->io.epollFD, EPOLL_CTL_ADD, context->io.eventFD, &event);
    }

    /* inotify*/
    {
        context->io.inotifyFD = inotify_init1(IN_CLOEXEC | IN_NONBLOCK);
        if(context->io.inotifyFD < 0)
        {
            close(context->io.epollFD);
            return 0;
        }

        {
            struct epoll_event event;
            event.events = EPOLLIN;
            event.data.u64 = PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(0, TYPE, PHANIDE_FD_EVENT_INOTIFY);
            epoll_ctl(context->io.epollFD, EPOLL_CTL_ADD, context->io.inotifyFD, &event);
        }
    }
#elif defined(USE_KQUEUE)
    context->io.kqueueFD = kqueue();
    if(context->io.kqueueFD < 0)
        return 0;

    {
        struct kevent ev;
        EV_SET(&ev, 0, EVFILT_USER, EV_ADD, NOTE_FFCOPY, 0, NULL);
        kevent(context->io.kqueueFD, &ev, 1, NULL, 0, NULL);
    }
#endif

    context->signalSemaphoreWithIndex = (signalSemaphoreWithIndex_t)dlsym(RTLD_DEFAULT, "signalSemaphoreWithIndex");
    if(!context->signalSemaphoreWithIndex)
        context->signalSemaphoreWithIndex = (signalSemaphoreWithIndex_t)dlsym(RTLD_DEFAULT, "_signalSemaphoreWithIndex");

    /* Initialize the synchronization primitives. */
    phanide_mutex_init(&context->io.processListMutex);
    phanide_mutex_init(&context->io.fsmonitorMutex);

    return 1;
}

static void
phanide_context_destroyIOData(phanide_context_t *context)
{
#if USE_EVENT_FD
    close(context->io.inotifyFD);

    close(context->io.epollFD);
    close(context->io.eventFD);
#endif

    phanide_mutex_destroy(&context->io.processListMutex);
    phanide_list_destroyData(&context->io.processList, phanide_process_destructor);

    phanide_mutex_destroy(&context->io.fsmonitorMutex);
}

static
void phanide_wakeUpSelect(phanide_context_t *context)
{
#if USE_EVENT_FD
    uint64_t count = 1;
    ssize_t res = write(context->io.eventFD, &count, sizeof(count));
    if(res < 0)
        perror("Failed to wake up process threads");
#elif USE_KQUEUE
    {
        struct kevent ev;
        EV_SET(&ev, 0, EVFILT_USER, EV_ENABLE, NOTE_FFCOPY | NOTE_TRIGGER, 0, NULL);
        kevent(context->io.kqueueFD, &ev, 1, NULL, 0, NULL);
    }

#else
#error Pipe not yet implemented.
#endif
}

#if USE_EPOLL
static void
phanide_processEPollEvent(phanide_context_t *context, struct epoll_event *event)
{
    uint64_t descriptor = event->data.u64;
    uint64_t eventType = PHANIDE_EVENT_DESCRIPTOR_FIELD_GET(descriptor, TYPE);
    switch(eventType)
    {
    case PHANIDE_FD_EVENT_WAKE_UP:
        {
            if(event->events & EPOLLIN)
            {
                uint64_t count;
                ssize_t readedCount = read(context->io.eventFD, &count, sizeof(count));
                if(readedCount < 0)
                    perror("Failed to read event FD.\n");
            }
        }
        break;
    case PHANIDE_FD_EVENT_SUBPROCESS_PIPE:
        {
            phanide_mutex_lock(&context->io.processListMutex);

            int pipe = PHANIDE_EVENT_DESCRIPTOR_FIELD_GET(descriptor, SUBPROCESS_PIPE);
            int subprocess = PHANIDE_EVENT_DESCRIPTOR_FIELD_GET(descriptor, SUBPROCESS_INDEX);

            /* Pending data*/
            phanide_process_t *process = phanide_process_getFromIndex(context, subprocess);
            if(process)
            {
                if(event->events & EPOLLIN)
                    phanide_process_pendingData(process, pipe);

                /* Pipe closed */
                if(event->events & EPOLLHUP || event->events & EPOLLERR)
                    phanide_process_pipeHungUpOrError(process, pipe);
            }

            phanide_mutex_unlock(&context->io.processListMutex);
        }
        break;
#if USE_INOTIFY
    case PHANIDE_FD_EVENT_INOTIFY:
        {
            if(event->events & EPOLLIN)
                phanide_inotify_pendingEvents(context);
        }
        break;
#endif
    default:
        break;
    }
}

static void
phanide_processEPollEvents(phanide_context_t *context, struct epoll_event *events, int eventCount)
{
    for(int i = 0; i < eventCount; ++i)
    {
        phanide_processEPollEvent(context, &events[i]);
    }
}
#endif /* USE_EPOLL */

#ifdef USE_KQUEUE
static void
phanide_processKQueueEvent(phanide_context_t *context, struct kevent *event)
{
    uint64_t descriptor = (uintptr_t)event->udata;
    uint64_t eventType = PHANIDE_EVENT_DESCRIPTOR_FIELD_GET(descriptor, TYPE);
    switch(eventType)
    {
    case PHANIDE_FD_EVENT_WAKE_UP:
        {
            {
                struct kevent ev;
                EV_SET(&ev, 0, EVFILT_USER, EV_DISABLE, NOTE_FFCOPY, 0, NULL);
                kevent(context->io.kqueueFD, &ev, 1, NULL, 0, NULL);
            }
        }
        break;
    case PHANIDE_FD_EVENT_SUBPROCESS_PIPE:
        {
            phanide_mutex_lock(&context->io.processListMutex);

            int pipe = PHANIDE_EVENT_DESCRIPTOR_FIELD_GET(descriptor, SUBPROCESS_PIPE);
            int subprocess = PHANIDE_EVENT_DESCRIPTOR_FIELD_GET(descriptor, SUBPROCESS_INDEX);

            /* Pending data*/
            phanide_process_t *process = phanide_process_getFromIndex(context, subprocess);
            if(process)
            {
                if(event->filter == EVFILT_READ)
                    phanide_process_pendingData(process, pipe);

                /* Pipe closed */
                if(event->flags & EV_EOF || event->flags & EV_ERROR)
                    phanide_process_pipeHungUpOrError(process, pipe);
            }

            phanide_mutex_unlock(&context->io.processListMutex);
        }
        break;
    case PHANIDE_FD_EVENT_INOTIFY:
        printf("TODO kqueue inotify");
        break;
    default:
        break;
    }

}

static void
phanide_processKQueueEvents(phanide_context_t *context, struct kevent *events, int eventCount)
{
    for(int i = 0; i < eventCount; ++i)
    {
        phanide_processKQueueEvent(context, &events[i]);
    }
}

#endif

static int
phanide_processThreadEntry(void *arg)
{
    phanide_context_t *context = (phanide_context_t *)arg;
    for(;;)
    {
#if defined(USE_EPOLL)
        struct epoll_event events[64];
        int eventCount = epoll_wait(context->io.epollFD, events, 64, -1);
        if(eventCount < 0)
        {
            perror("epoll failed");
            return 0;
        }

        phanide_processEPollEvents(context, events, eventCount);
#elif defined(USE_KQUEUE)
        struct kevent events[64];
        int eventCount = kevent(context->io.kqueueFD, NULL, 0, events, 64, NULL);
        if(eventCount < 0)
        {
            perror("kevent failed");
            return 0;
        }
        phanide_processKQueueEvents(context, events, eventCount);
#else
#error Select not yet implemented
#endif
        phanide_mutex_lock(&context->controlMutex);

        /* Are we shutting down? */
        if(context->shuttingDown)
        {
            phanide_mutex_unlock(&context->controlMutex);
            break;
        }

        phanide_mutex_unlock(&context->controlMutex);
    }

    return 0;
}

/* Process spawning. */
struct phanide_process_s
{
    phanide_linked_list_node_t header;

    phanide_context_t *context;
    int used;
    size_t index;
    pid_t childPid;
    phanide_process_spawn_flags_t flags;

    int remainingPipes;
    int exitCode;

    union
    {
        struct
        {
            int stdinPipe;
            int stdoutPipe;
            int stderrPipe;
            int extraStdinPipe;
            int extraStdoutPipe;
            int extraStderrPipe;
        };
        int pipes[6];
    };
};

static phanide_process_t *
phanide_process_allocate(phanide_context_t *context)
{
    phanide_mutex_lock(&context->io.processListMutex);
    /* Find a free process. */
    phanide_process_t *resultProcess = NULL;
    for(size_t i = 0; i < context->io.processList.size; ++i)
    {
        phanide_process_t *process = context->io.processList.data[i];
        if(!process->used)
        {
            resultProcess = process;
            resultProcess->index = i;
        }
    }

    /* Allocate a new result process. */
    if(!resultProcess)
    {
        resultProcess = malloc(sizeof(phanide_process_t));
        memset(resultProcess, 0, sizeof(phanide_process_t));
        resultProcess->index = context->io.processList.size;
        phanide_list_pushBack(&context->io.processList, resultProcess);
    }

    resultProcess->context = context;
    resultProcess->used = 1;
    phanide_mutex_unlock(&context->io.processListMutex);

    return resultProcess;
}

static phanide_process_t*
phanide_process_getFromIndex(phanide_context_t *context, size_t index)
{
    if(index >= context->io.processList.size)
        return NULL;

    phanide_process_t *process = context->io.processList.data[index];
    if(!process->used)
        return NULL;

    return process;
}

static void
phanide_process_closePipeFD(phanide_process_t *process, int fd)
{
#ifdef USE_EPOLL
    epoll_ctl(process->context->io.epollFD, EPOLL_CTL_DEL, fd, NULL);
#endif
    close(fd);
}

PHANIDE_CORE_EXPORT void
phanide_process_free(phanide_process_t *process)
{
    if(!process)
        return;

    /* TODO: Perform process clean up*/
    phanide_context_t *context = process->context;
    phanide_mutex_lock(&context->io.processListMutex);
    if(process->used)
    {
        if(process->stdinPipe)
            phanide_process_closePipeFD(process, process->stdinPipe);
        if(process->stdoutPipe)
            phanide_process_closePipeFD(process, process->stdoutPipe);
        if(process->stderrPipe)
            phanide_process_closePipeFD(process, process->stderrPipe);

        if(process->flags & PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES)
        {
            if(process->extraStdinPipe)
                phanide_process_closePipeFD(process, process->extraStdinPipe);
            if(process->extraStdoutPipe)
                phanide_process_closePipeFD(process, process->extraStdoutPipe);
            if(process->extraStderrPipe)
                phanide_process_closePipeFD(process, process->extraStderrPipe);
        }

        if(process->childPid)
        {
            int status;
            int res = waitpid(process->childPid, &status, WNOHANG);
            (void)status;
            (void)res;
        }
    }
    memset(process, 0, sizeof(phanide_process_t));
    phanide_mutex_unlock(&context->io.processListMutex);
}

static void phanide_process_closeAllOpenFileDescriptors(int inheritedCount)
{
    DIR *dir = opendir("/proc/self/fd/");
    if(!dir)
        dir = opendir("/dev/fd/");

    /* TODO: Support the brute force approach as a fallback. */
    if(!dir)
        return;

    int dirFD = dirfd(dir);
    for(struct dirent *entry = readdir(dir); entry; entry = readdir(dir))
    {
        int entryFDNumber = atoi(entry->d_name);
        if(/* stdin stdout stderr */entryFDNumber >= inheritedCount && entryFDNumber != dirFD)
            close(entryFDNumber);
    }

    closedir(dir);
}

static void
phanide_register_pipeForPolling(phanide_context_t *context, int isReadPipe, int processIndex, int fd, int pipeIndex)
{
    if(isReadPipe)
    {
        uint64_t descriptor = PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(0, TYPE, PHANIDE_FD_EVENT_SUBPROCESS_PIPE);
        descriptor = PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(descriptor, SUBPROCESS_PIPE, pipeIndex);
        descriptor = PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(descriptor, SUBPROCESS_INDEX, processIndex);

#if defined(USE_EPOLL)
        struct epoll_event event;
        event.events = EPOLLIN;
        event.data.u64 = descriptor;
        epoll_ctl(context->io.epollFD, EPOLL_CTL_ADD, fd, &event);
#elif defined(USE_KQUEUE)
        struct kevent event;
        EV_SET(&event, fd, EVFILT_READ, EV_ADD|EV_ENABLE, 0, 0, (void*)(uintptr_t)descriptor);
        kevent(context->io.kqueueFD, &event, 1, NULL, 0, NULL);
#else
#error Not yet implemented
#endif
    }
    else
    {
        uint64_t descriptor = PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(0, TYPE, PHANIDE_FD_EVENT_SUBPROCESS_PIPE);
        descriptor = PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(descriptor, SUBPROCESS_PIPE, pipeIndex);
        descriptor = PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(descriptor, SUBPROCESS_INDEX, processIndex);

#if defined(USE_EPOLL)
        struct epoll_event event;
        event.events = 0;
        event.data.u64 = descriptor;
        epoll_ctl(context->io.epollFD, EPOLL_CTL_ADD, fd, &event);
#elif defined(USE_KQUEUE)
        struct kevent event;
        EV_SET(&event, fd, EVFILT_WRITE, EV_ADD|EV_DISABLE, 0, 0, (void*)(uintptr_t)descriptor);
        kevent(context->io.kqueueFD, &event, 1, NULL, 0, NULL);
#else
        #error Not yet implemented
#endif
    }
}
static phanide_process_t *
phanide_process_forkForSpawn(phanide_context_t *context, phanide_process_spawn_flags_t flags, int *error)
{
    int stdinPipe[2];
    int stdoutPipe[2];
    int stderrPipe[2];
    int extraStdinPipe[2];
    int extraStdoutPipe[2];
    int extraStderrPipe[2];

    /* Create the pipes */
    int result = pipe(stdinPipe);
    if(result < 0)
    {
        *error = errno;
        return NULL;
    }

    result = pipe(stdoutPipe);
    if(result < 0)
    {
        *error = errno;
        close(stdinPipe[0]); close(stdinPipe[1]);
        return NULL;
    }

    result = pipe(stderrPipe);
    if(result < 0)
    {
        *error = errno;
        close(stdinPipe[0]); close(stdinPipe[1]);
        close(stdoutPipe[0]); close(stdoutPipe[1]);
        return NULL;
    }

    if(flags & PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES)
    {
        int result = pipe(extraStdinPipe);
        if(result < 0)
        {
            *error = errno;
            close(stdinPipe[0]); close(stdinPipe[1]);
            close(stdoutPipe[0]); close(stdoutPipe[1]);
            close(stderrPipe[0]); close(stderrPipe[1]);
            return NULL;
        }

        result = pipe(extraStdoutPipe);
        if(result < 0)
        {
            *error = errno;
            close(stdinPipe[0]); close(stdinPipe[1]);
            close(stdoutPipe[0]); close(stdoutPipe[1]);
            close(stderrPipe[0]); close(stderrPipe[1]);
            close(extraStdinPipe[0]); close(extraStdinPipe[1]);
            return NULL;
        }

        result = pipe(extraStderrPipe);
        if(result < 0)
        {
            *error = errno;
            close(stdinPipe[0]); close(stdinPipe[1]);
            close(stdoutPipe[0]); close(stdoutPipe[1]);
            close(stderrPipe[0]); close(stderrPipe[1]);
            close(extraStdinPipe[0]); close(extraStdinPipe[1]);
            close(extraStdoutPipe[0]); close(extraStdoutPipe[1]);
            return NULL;
        }
    }

    /* Fork the process */
    pid_t forkResult = fork();
    if(forkResult < 0)
    {
        /* This should not happen. */
        perror("Failed to fork\n");
        *error = errno;
        close(stdinPipe[0]); close(stdinPipe[1]);
        close(stdoutPipe[0]); close(stdoutPipe[1]);
        close(stderrPipe[0]); close(stderrPipe[1]);
        if(flags & PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES)
        {
            close(extraStdinPipe[0]); close(extraStdinPipe[1]);
            close(extraStdoutPipe[0]); close(extraStdoutPipe[1]);
            close(extraStderrPipe[0]); close(extraStderrPipe[1]);
        }
        return NULL;
    }

    /* Are we the child? */
    if(forkResult == 0)
    {
        /* Redirect the standard file descriptors to the pipes. */
        result = dup2(stdinPipe[0], STDIN_FILENO); (void)result;
        result = dup2(stdoutPipe[1], STDOUT_FILENO); (void)result;
        result = dup2(stderrPipe[1], STDERR_FILENO); (void)result;
        if(flags & PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES)
        {
            result = dup2(extraStdinPipe[0], 3); (void)result;
            result = dup2(extraStdoutPipe[1], 4); (void)result;
            result = dup2(extraStderrPipe[1], 5); (void)result;
        }

        /* Close the copies from the pipes. */
        close(stdinPipe[0]); close(stdinPipe[1]);
        close(stdoutPipe[0]); close(stdoutPipe[1]);
        close(stderrPipe[0]); close(stderrPipe[1]);
        if(flags & PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES)
        {
            close(extraStdinPipe[0]); close(extraStdinPipe[1]);
            close(extraStdoutPipe[0]); close(extraStdoutPipe[1]);
            close(extraStderrPipe[0]); close(extraStderrPipe[1]);
        }

        /* Close all the open file descriptors. */
        int inheritedPipes = 3;
        if(flags & PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES)
            inheritedPipes += 3;
        phanide_process_closeAllOpenFileDescriptors(inheritedPipes);
        return NULL;
    }

    /* Create the process */
    phanide_process_t *process = phanide_process_allocate(context);
    process->flags = flags;

    /* We are the parent. Close the pipe endpoint that are unintesting to us. */
    /* read */ close(stdinPipe[0]); process->stdinPipe = /* write */stdinPipe[1];
    /* read */ process->stdoutPipe = stdoutPipe[0]; /* write */ close(stdoutPipe[1]);
    /* read */ process->stderrPipe = stderrPipe[0]; /* write */ close(stderrPipe[1]);

    if(flags & PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES)
    {
        /* read */ close(extraStdinPipe[0]); process->extraStdinPipe = /* write */extraStdinPipe[1];
        /* read */ process->extraStdoutPipe = extraStdoutPipe[0]; /* write */ close(extraStdoutPipe[1]);
        /* read */ process->extraStderrPipe = extraStderrPipe[0]; /* write */ close(extraStderrPipe[1]);
    }

    /* Set non-blocking mode for stdout and stderr. */
    fcntl(process->stdoutPipe, F_SETFL, fcntl(process->stdoutPipe, F_GETFL, 0) | O_NONBLOCK);
    fcntl(process->stderrPipe, F_SETFL, fcntl(process->stderrPipe, F_GETFL, 0) | O_NONBLOCK);
    process->remainingPipes = 3;

    if(flags & PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES)
    {
        fcntl(process->extraStdoutPipe, F_SETFL, fcntl(process->extraStdoutPipe, F_GETFL, 0) | O_NONBLOCK);
        fcntl(process->extraStderrPipe, F_SETFL, fcntl(process->extraStderrPipe, F_GETFL, 0) | O_NONBLOCK);
        process->remainingPipes = 6;
    }

    phanide_register_pipeForPolling(context, 0, process->index, process->stdinPipe, PHANIDE_PIPE_INDEX_STDIN);
    phanide_register_pipeForPolling(context, 1, process->index, process->stdoutPipe, PHANIDE_PIPE_INDEX_STDOUT);
    phanide_register_pipeForPolling(context, 1, process->index, process->stderrPipe, PHANIDE_PIPE_INDEX_STDERR);
    if(flags & PHANIDE_SPAWN_FLAGS_OPEN_EXTRA_PIPES)
    {
        phanide_register_pipeForPolling(context, 0, process->index, process->extraStdinPipe, PHANIDE_PIPE_INDEX_EXTRA_STDIN);
        phanide_register_pipeForPolling(context, 1, process->index, process->extraStdoutPipe, PHANIDE_PIPE_INDEX_EXTRA_STDOUT);
        phanide_register_pipeForPolling(context, 1, process->index, process->extraStderrPipe, PHANIDE_PIPE_INDEX_EXTRA_STDERR);
    }

    return process;
}

static void
phanide_process_setPipeReadPolling(int enabled, phanide_process_t *process, int pipeIndex)
{
    uint64_t descriptor = PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(0, TYPE, PHANIDE_FD_EVENT_SUBPROCESS_PIPE);
    descriptor = PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(descriptor, SUBPROCESS_PIPE, pipeIndex);
    descriptor = PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(descriptor, SUBPROCESS_INDEX, process->index);

#if defined(USE_EPOLL)
    struct epoll_event event;
    event.events = enabled ? EPOLLIN : 0;
    event.data.u64 = descriptor;
    epoll_ctl(process->context->io.epollFD, EPOLL_CTL_MOD, process->pipes[pipeIndex], &event);

#elif defined(USE_KQUEUE)
    struct kevent event;
    EV_SET(&event, process->pipes[pipeIndex], EVFILT_READ, enabled ? EV_ENABLE : EV_DISABLE, 0, 0, (void*)(uintptr_t)descriptor);
    kevent(process->context->io.kqueueFD, &event, 1, NULL, 0, NULL);
#else
#error Not yet implemented
#endif
}

static void
phanide_process_pendingData(phanide_process_t *process, int pipeIndex)
{
    phanide_process_setPipeReadPolling(0, process, pipeIndex);

    phanide_event_t event = {
        .processPipe = {
            .type = PHANIDE_EVENT_TYPE_PROCESS_PIPE_READY,
            .process = process,
            .pipeIndex = pipeIndex
        }
    };

    phanide_pushEvent(process->context, &event);
}

static void
phanide_process_pipeHungUpOrError(phanide_process_t *process, int pipeIndex)
{
#if defined (USE_EPOLL)
    epoll_ctl(process->context->io.epollFD, EPOLL_CTL_DEL, process->pipes[pipeIndex], NULL);
#elif defined (USE_KQUEUE)
    struct kevent event;
    if(pipeIndex == PHANIDE_STDIN_PIPE_INDEX)
    {
        EV_SET(&event, process->pipes[pipeIndex], EV_DELETE, EVFILT_WRITE, 0, 0, 0);
    }
    else
    {
        EV_SET(&event, process->pipes[pipeIndex], EV_DELETE, EVFILT_READ, 0, 0, 0);
    }
    kevent(process->context->io.kqueueFD, &event, 1, NULL, 0, NULL);

#else

#endif
    --process->remainingPipes;
    if(process->remainingPipes != 0)
        return;

    /* Time to bury the child. */
    int status;
    waitpid(process->childPid, &status, 0);
    process->exitCode = WEXITSTATUS(status);
    process->childPid = 0;

    /* There is no need to keep the stdin pipe. */
    close(process->stdinPipe);
    process->stdinPipe = 0;

    /* Push a process finished event. */
    {
        phanide_event_t event = {
            .processFinished = {
                .type = PHANIDE_EVENT_TYPE_PROCESS_FINISHED,
                .process = process,
                .exitCode = process->exitCode,
            }
        };
        phanide_pushEvent(process->context, &event);
    }
}

PHANIDE_CORE_EXPORT phanide_process_t *
phanide_process_spawn(phanide_context_t *context, const char *path, const char **argv, phanide_process_spawn_flags_t flags)
{
    if(!context)
        return NULL;

    int error = 0;
    phanide_process_t *result = phanide_process_forkForSpawn(context, flags, &error);
    if(result || error)
        return result;

    int res = execv(path, (char *const*)argv);
    (void)res;

    /* Should never reach here. */
    perror("Failed to perform exec");
    exit(1);
}

PHANIDE_CORE_EXPORT phanide_process_t *
phanide_process_spawnInPath(phanide_context_t *context, const char *file, const char **argv, phanide_process_spawn_flags_t flags)
{
    if(!context)
        return NULL;

    int error = 0;
    phanide_process_t *result = phanide_process_forkForSpawn(context, flags, &error);
    if(result || error)
        return result;

    int res = execvp(file, (char *const*)argv);
    (void)res;

    /* Should never reach here. */
    perror("Failed to perform exec");
    exit(1);
}

PHANIDE_CORE_EXPORT phanide_process_t *
phanide_process_spawnShell(phanide_context_t *context, const char *command, phanide_process_spawn_flags_t flags)
{
    if(!context)
        return NULL;

    int error = 0;
    phanide_process_t *result = phanide_process_forkForSpawn(context, flags, &error);
    if(result || error)
        return result;

    execl("/bin/sh", "sh", "-c", command, NULL);

    /* Should never reach here. */
    perror("Failed to perform exec.");
    exit(1);
}


PHANIDE_CORE_EXPORT void
phanide_process_terminate(phanide_process_t *process)
{
}

PHANIDE_CORE_EXPORT void
phanide_process_kill(phanide_process_t *process)
{
}

PHANIDE_CORE_EXPORT intptr_t
phanide_process_pipe_read(phanide_process_t *process, phanide_pipe_index_t pipe, void *buffer, size_t offset,  size_t count)
{
    if(!process)
        return PHANIDE_PIPE_ERROR;

    phanide_mutex_lock(&process->context->io.processListMutex);

    /* Get the pipe file descriptor. */
    int fd = process->pipes[pipe];
    if(fd == 0)
    {
        phanide_mutex_unlock(&process->context->io.processListMutex);
        return PHANIDE_PIPE_ERROR_CLOSED;
    }

    /* Read from the pipe. */
    ssize_t result;
    {
        result = read(fd, ((char*)buffer) + offset, count);
    } while(result < 0 && errno == EINTR);

    if(errno == EWOULDBLOCK)
        phanide_process_setPipeReadPolling(1, process, pipe);
    phanide_mutex_unlock(&process->context->io.processListMutex);

    /* Convert the error code. */
    if(result < 0)
    {
        switch(errno)
        {
        case EWOULDBLOCK:
            return PHANIDE_PIPE_ERROR_WOULD_BLOCK;
        default:
            return PHANIDE_PIPE_ERROR;
        }
    }

    return result;
}

PHANIDE_CORE_EXPORT intptr_t
phanide_process_pipe_write(phanide_process_t *process, phanide_pipe_index_t pipe, const void *buffer, size_t offset, size_t count)
{
    if(!process)
        return PHANIDE_PIPE_ERROR;

    phanide_mutex_lock(&process->context->io.processListMutex);

    /* Get the pipe file descriptor. */
    int fd = process->pipes[pipe];
    if(fd == 0)
    {
        phanide_mutex_unlock(&process->context->io.processListMutex);
        return PHANIDE_PIPE_ERROR_CLOSED;
    }

    /* Read from the pipe. */
    ssize_t result;
    {
        result = write(fd, ((char*)buffer) + offset, count);
    } while(result < 0 && errno == EINTR);

    phanide_mutex_unlock(&process->context->io.processListMutex);

    /* Convert the error code. */
    if(result < 0)
    {
        switch(errno)
        {
        case EWOULDBLOCK:
            return PHANIDE_PIPE_ERROR_WOULD_BLOCK;
        default:
            return PHANIDE_PIPE_ERROR;
        }
    }

    return result;
}

static void
phanide_process_destructor (void *arg)
{
    phanide_process_t *process = (phanide_process_t*)arg;
    if(process->used)
    {
        if(process->stdinPipe)
            close(process->stdinPipe);
        if(process->stdoutPipe)
            close(process->stdoutPipe);
        if(process->stderrPipe)
            close(process->stderrPipe);
        if(process->extraStdinPipe)
            close(process->stdinPipe);
        if(process->extraStdoutPipe)
            close(process->stdoutPipe);
        if(process->extraStderrPipe)
            close(process->stderrPipe);

        if(process->childPid)
        {
            int status;
            int res = waitpid(process->childPid, &status, WNOHANG);
            (void)status;
            (void)res;
        }
    }
    free(process);
}


#if USE_INOTIFY
static int
phanide_inotify_pendingEvent(phanide_context_t *context)
{
    ssize_t readCount;
    do
    {
        readCount = read(context->io.inotifyFD, context->io.inotifyEventBuffer.bytes, sizeof(context->io.inotifyEventBuffer));
    } while (readCount < 0 && errno == EINTR);

    if(readCount < 0)
        return 0;

    uint8_t *bytes = context->io.inotifyEventBuffer.bytes;
    while(readCount > 0)
    {
        struct inotify_event *event = (struct inotify_event *)bytes;
        size_t eventSize = sizeof(struct inotify_event) + event->len;

        /* Map the event mask */
        uint32_t mappedMask = 0;
        uint32_t mask = event->mask;

#define MAP_INOTIFY_EVENT(name) if(mask & IN_##name) mappedMask |= PHANIDE_FSMONITOR_EVENT_ ##name;
        MAP_INOTIFY_EVENT(ACCESS);
        MAP_INOTIFY_EVENT(ATTRIB);
        MAP_INOTIFY_EVENT(CLOSE_WRITE);
        MAP_INOTIFY_EVENT(CLOSE_NOWRITE);
        MAP_INOTIFY_EVENT(CREATE);
        MAP_INOTIFY_EVENT(DELETE);
        MAP_INOTIFY_EVENT(DELETE_SELF);
        MAP_INOTIFY_EVENT(MODIFY);
        MAP_INOTIFY_EVENT(MOVE_SELF);
        MAP_INOTIFY_EVENT(MOVED_FROM);
        MAP_INOTIFY_EVENT(MOVED_TO);
        MAP_INOTIFY_EVENT(OPEN);
#undef MAP_INOTIFY_EVENT

        phanide_event_t phevent = {
            .fsmonitor = {
                .type = PHANIDE_EVENT_TYPE_FSMONITOR,
                .handle = (phanide_fsmonitor_handle_t *)(size_t)event->wd,
                .mask = mappedMask,
                .cookie = event->cookie,
                .nameLength = event->len,
                .name = event->len ? phanide_strdup(event->name) : 0
            }
        };
        phanide_pushEvent(context, &phevent);

        readCount -= eventSize;
        bytes += eventSize;
    }

    return 1;
}

static void
phanide_inotify_pendingEvents(phanide_context_t *context)
{
    while(phanide_inotify_pendingEvent(context))
        ;
}
#endif

PHANIDE_CORE_EXPORT phanide_fsmonitor_handle_t *
phanide_fsmonitor_watchFile(phanide_context_t *context, const char *path)
{
    if(!context)
        return NULL;

phanide_fsmonitor_handle_t *result = NULL;

#if USE_INOTIFY
    phanide_mutex_lock(&context->io.fsmonitorMutex);
    int wd = inotify_add_watch(context->io.inotifyFD, path,
        IN_ATTRIB | IN_CLOSE | IN_CREATE | IN_DELETE | IN_DELETE_SELF | IN_MODIFY | IN_MOVE_SELF | IN_MOVE | IN_OPEN);
    if(wd >= 0)
        result = (phanide_fsmonitor_handle_t*)(size_t)wd;

    phanide_mutex_unlock(&context->io.fsmonitorMutex);
#else
#endif
    return result;
}

PHANIDE_CORE_EXPORT phanide_fsmonitor_handle_t *
phanide_fsmonitor_watchDirectory(phanide_context_t *context, const char *path)
{
    if(!context)
        return NULL;

    phanide_fsmonitor_handle_t *result = NULL;
#if USE_INOTIFY
    phanide_mutex_lock(&context->io.fsmonitorMutex);
    int wd = inotify_add_watch(context->io.inotifyFD, path,
        IN_ATTRIB | IN_CLOSE | IN_CREATE | IN_DELETE | IN_DELETE_SELF | IN_MODIFY | IN_MOVE_SELF | IN_MOVE | IN_OPEN | IN_EXCL_UNLINK);
    if(wd >= 0)
        result = (phanide_fsmonitor_handle_t*)(size_t)wd;

    phanide_mutex_unlock(&context->io.fsmonitorMutex);
#else
#endif

    return result;
}

PHANIDE_CORE_EXPORT void
phanide_fsmonitor_destroy(phanide_context_t *context, phanide_fsmonitor_handle_t *handle)
{
    if(!context)
        return;

#if USE_INOTIFY
    phanide_mutex_lock(&context->io.fsmonitorMutex);
    int wd = (int)(size_t)handle;
    inotify_rm_watch(context->io.inotifyFD, wd);
    phanide_mutex_unlock(&context->io.fsmonitorMutex);
#else
#endif
}

#endif //_WIN32
