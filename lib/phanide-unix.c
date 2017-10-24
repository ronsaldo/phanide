#include "internal.h"
#include <unistd.h>
#include <errno.h>

#if defined(linux)
#include <unistd.h>

#include <sys/epoll.h>
#include <sys/eventfd.h>

typedef enum phanide_fd_event_descriptor_type_e
{
    PHANIDE_FD_EVENT_WAKE_UP = 0,
    PHANIDE_FD_EVENT_SUBPROCESS_PIPE,
} phanide_fd_event_descriptor_type_t;

#define PHANIDE_MASK_FOR_BIT_COUNT(bc) ((((uint64_t)1) << bc) - 1)

#define PHANIDE_EVENT_DESCRIPTOR_TYPE_MASK PHANIDE_MASK_FOR_BIT_COUNT(3)
#define PHANIDE_EVENT_DESCRIPTOR_TYPE_SHIFT 0

#define PHANIDE_EVAL_MACRO1(x) x
#define PHANIDE_EVENT_DESCRIPTOR_FIELD_GET(x, fn) (x >> PHANIDE_EVAL_MACRO1(PHANIDE_EVENT_DESCRIPTOR_ ## fn ## _SHIFT)) & PHANIDE_EVAL_MACRO1(PHANIDE_EVENT_DESCRIPTOR_ ## fn ## _MASK)
#define PHANIDE_EVENT_DESCRIPTOR_FIELD_SET(x, fn, v) (x | ((v & PHANIDE_EVAL_MACRO1(PHANIDE_EVENT_DESCRIPTOR_ ## fn ## _MASK)) << PHANIDE_EVAL_MACRO1(PHANIDE_EVENT_DESCRIPTOR_ ## fn ## _SHIFT)))

#define PHANIDE_EVENT_DESCRIPTOR_SUBPROCESS_PIPE_MASK PHANIDE_MASK_FOR_BIT_COUNT(2)
#define PHANIDE_EVENT_DESCRIPTOR_SUBPROCESS_PIPE_SHIFT 4

#define PHANIDE_EVENT_DESCRIPTOR_SUBPROCESS_INDEX_MASK PHANIDE_MASK_FOR_BIT_COUNT(59)
#define PHANIDE_EVENT_DESCRIPTOR_SUBPROCESS_INDEX_SHIFT 5

#define USE_EPOLL 1
#define USE_EVENT_FD 1

#define USE_SELECT_AS_CONDITION 1
#elif defined(_WIN32)
#endif

typedef struct phanide_context_io_s
{
#if USE_EPOLL
    int epollFD;
    int eventFD;
#endif
} phanide_context_io_t;

#include "phanide.c"

static int phanide_createContextIOPrimitives(phanide_context_t *context)
{
#if USE_EPOLL
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
#endif

    return 1;
}

static void phanide_wakeUpSelect(phanide_context_t *context)
{
#if USE_EVENT_FD
    uint64_t count = 1;
    ssize_t res = write(context->io.eventFD, &count, sizeof(count));
    if(res < 0)
        perror("Failed to wake up process threads");
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
            uint64_t count;
            ssize_t readedCount = read(context->io.eventFD, &count, sizeof(count));
            if(readedCount < 0)
                perror("Failed to read event FD.\n");
        }
        break;
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

static void *
phanide_processThreadEntry(void *arg)
{
    phanide_context_t *context = (phanide_context_t *)arg;
    for(;;)
    {
#if USE_EPOLL
        struct epoll_event events[64];
        int eventCount = epoll_wait(context->io.epollFD, events, 64, -1);
        if(eventCount < 0)
        {
            perror("epoll failed");
            return NULL;
        }

        phanide_processEPollEvents(context, events, eventCount);
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

    return NULL;
}

/* Process spawning. */
struct phanide_process_s
{
    phanide_linked_list_node_t header;

    pid_t childPid;

    int stdinPipe;
    int stdoutPipe;
    int stderrPipe;
};

static phanide_process_t *phanide_process_forkForSpawn(phanide_context_t *context, int *error)
{
    int stdinPipe[2];
    int stdoutPipe[2];
    int stderrPipe[2];

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
        return NULL;
    }

    /* Are we the child? */
    if(forkResult == 0)
    {
        /* Redirect the standard file descriptors to the pipes. */
        close(STDIN_FILENO); /* read */ result = dup(stdinPipe[0]); /* write */ close(stdinPipe[1]); (void)result;
        close(STDOUT_FILENO); /* read */ close(stdoutPipe[0]); /* write */ result = dup(stdoutPipe[1]); (void)result;
        close(STDERR_FILENO); /* read */ close(stderrPipe[0]); /* write */ result = dup(stderrPipe[1]); (void)result;
        return NULL;
    }

    /* Create the process */
    phanide_process_t *process = malloc(sizeof(phanide_process_t));
    memset(process, 0, sizeof(phanide_process_t));

    /* We are the parent. Close the pipe endpoint that are unintesting to us. */
    /* read */ close(stdinPipe[0]); process->stdinPipe = /* write */stdinPipe[1];
    /* read */ process->stdoutPipe = stdoutPipe[0]; /* write */ close(stdoutPipe[1]);
    /* read */ process->stderrPipe = stderrPipe[1]; /* write */ close(stderrPipe[1]);

    return process;
}

PHANIDE_CORE_EXPORT phanide_process_t *
phanide_process_spawn(phanide_context_t *context, const char *path, const char **argv)
{
    if(!context)
        return NULL;

    int error = 0;
    phanide_process_t *result = phanide_process_forkForSpawn(context, &error);
    if(result || error)
        return result;

    int res = execv(path, (char *const*)argv);
    (void)res;

    /* Should never reach here. */
    perror("Failed to perform exec");
    exit(1);
}

PHANIDE_CORE_EXPORT phanide_process_t *
phanide_process_spawnInPath(phanide_context_t *context, const char *file, const char **argv)
{
    if(!context)
        return NULL;

    int error = 0;
    phanide_process_t *result = phanide_process_forkForSpawn(context, &error);
    if(result || error)
        return result;

    int res = execvp(file, (char *const*)argv);
    (void)res;

    /* Should never reach here. */
    perror("Failed to perform exec");
    exit(1);
}

PHANIDE_CORE_EXPORT phanide_process_t *
phanide_process_spawnShell(phanide_context_t *context, const char *command)
{
    if(!context)
        return NULL;

    int error = 0;
    phanide_process_t *result = phanide_process_forkForSpawn(context, &error);
    if(result || error)
        return result;

    execl("/bin/sh", "sh", "-c", command, NULL);

    /* Should never reach here. */
    perror("Failed to perform exec.");
    exit(1);
}

PHANIDE_CORE_EXPORT void
phanide_process_wait(phanide_process_t *process)
{
}

PHANIDE_CORE_EXPORT void
phanide_process_timedWait(phanide_process_t *process, int timeout)
{
}

PHANIDE_CORE_EXPORT void
phanide_process_terminate(phanide_process_t *process)
{
}

PHANIDE_CORE_EXPORT void
phanide_process_kill(phanide_process_t *process)
{
}
