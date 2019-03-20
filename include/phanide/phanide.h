#ifndef _PHANIDE_PHANIDE_H_
#define _PHANIDE_PHANIDE_H_

#include <stdint.h>
#include <stddef.h>

#ifdef _WIN32
#define PHANIDE_DLL_EXPORT __declspec(dllexport)
#define PHANIDE_DLL_IMPORT __declspec(dllimport)
#else
#define PHANIDE_DLL_EXPORT
#define PHANIDE_DLL_IMPORT
#endif

#ifdef __cplusplus
#define PHANIDE_C_LINKAGE extern "C"
#else
#define PHANIDE_C_LINKAGE
#endif

#ifdef BUILD_PHANIDE_CORE
#define PHANIDE_CORE_EXPORT PHANIDE_C_LINKAGE PHANIDE_DLL_EXPORT
#else
#define PHANIDE_CORE_EXPORT PHANIDE_C_LINKAGE PHANIDE_DLL_IMPORT
#endif

#define PHANIDE_BIT(x) (1<<(x))

struct phanide_context_s;
typedef struct phanide_context_s phanide_context_t;

struct phanide_process_s;
typedef struct phanide_process_s phanide_process_t;

struct phanide_fsmonitor_handle_s;
typedef struct phanide_fsmonitor_handle_s phanide_fsmonitor_handle_t;

typedef enum phanide_fsmonitor_event_bits_e
{
    PHANIDE_FSMONITOR_EVENT_ACCESS = PHANIDE_BIT(0),
    PHANIDE_FSMONITOR_EVENT_ATTRIB = PHANIDE_BIT(1),
    PHANIDE_FSMONITOR_EVENT_CLOSE_WRITE = PHANIDE_BIT(2),
    PHANIDE_FSMONITOR_EVENT_CLOSE_NOWRITE = PHANIDE_BIT(3),
    PHANIDE_FSMONITOR_EVENT_CREATE = PHANIDE_BIT(4),
    PHANIDE_FSMONITOR_EVENT_DELETE = PHANIDE_BIT(5),
    PHANIDE_FSMONITOR_EVENT_DELETE_SELF = PHANIDE_BIT(6),
    PHANIDE_FSMONITOR_EVENT_MODIFY = PHANIDE_BIT(7),
    PHANIDE_FSMONITOR_EVENT_MOVE_SELF = PHANIDE_BIT(8),
    PHANIDE_FSMONITOR_EVENT_MOVED_FROM = PHANIDE_BIT(9),
    PHANIDE_FSMONITOR_EVENT_MOVED_TO = PHANIDE_BIT(10),
    PHANIDE_FSMONITOR_EVENT_OPEN = PHANIDE_BIT(11),
} phanide_fsmonitor_event_bits_t;

typedef enum phanide_event_type_e
{
    PHANIDE_EVENT_TYPE_NONE = 0,

    /* Process events*/
    PHANIDE_EVENT_TYPE_PROCESS_FINISHED = 1,
    PHANIDE_EVENT_TYPE_PROCESS_PIPE_READY,

    /* File events*/
    PHANIDE_EVENT_TYPE_FSMONITOR = 100,
}phanide_event_type_t;

typedef enum phanide_pipe_index_e
{
    PHANIDE_PIPE_INDEX_STDIN = 0,
    PHANIDE_PIPE_INDEX_STDOUT = 1,
    PHANIDE_PIPE_INDEX_STDERR = 2,
} phanide_pipe_index_t;

typedef enum phanide_pipe_error_e
{
    PHANIDE_PIPE_ERROR = -1,
    PHANIDE_PIPE_ERROR_WOULD_BLOCK = -2,
    PHANIDE_PIPE_ERROR_CLOSED = -3,
} phanide_pipe_error_t;

typedef struct phanide_event_process_pipe_s
{
    uint32_t type;
    phanide_process_t *process;
    uint32_t pipeIndex;
} phanide_event_process_pipe_t;

typedef struct phanide_event_process_finished_s
{
    uint32_t type;
    phanide_process_t *process;
    int32_t exitCode;
} phanide_event_process_finished_t;

typedef struct phanide_event_fsmonitor_s {
    uint32_t type;
    phanide_fsmonitor_handle_t *handle;
    uint32_t mask;
    uint32_t cookie;
    uint32_t nameLength;
    const char *name;
} phanide_event_fsmonitor_t;

typedef union phanide_event_s
{
    uint32_t type;
    phanide_event_process_pipe_t processPipe;
    phanide_event_process_finished_t processFinished;
    phanide_event_fsmonitor_t fsmonitor;
    uintptr_t padding[16];/* Maximum number of fields*/
} phanide_event_t;

/* Context creation */
PHANIDE_CORE_EXPORT phanide_context_t *phanide_createContext(intptr_t pendingEventsSemaphoreIndex);
PHANIDE_CORE_EXPORT void phanide_destroyContext(phanide_context_t *context);

/* Memory allocation */
PHANIDE_CORE_EXPORT void *phanide_malloc(size_t size);
PHANIDE_CORE_EXPORT void phanide_free(void *pointer);

/* Process spawning */
PHANIDE_CORE_EXPORT phanide_process_t *phanide_process_spawn(phanide_context_t *context, const char *path, const char **argv);
PHANIDE_CORE_EXPORT phanide_process_t *phanide_process_spawnInPath(phanide_context_t *context, const char *file, const char **argv);
PHANIDE_CORE_EXPORT phanide_process_t *phanide_process_spawnShell(phanide_context_t *context, const char *command);

/* Process termination */
PHANIDE_CORE_EXPORT void phanide_process_free(phanide_process_t *process);
PHANIDE_CORE_EXPORT void phanide_process_terminate(phanide_process_t *process);
PHANIDE_CORE_EXPORT void phanide_process_kill(phanide_process_t *process);

/* Process pipes */
PHANIDE_CORE_EXPORT intptr_t phanide_process_pipe_read(phanide_process_t *process, phanide_pipe_index_t pipe, void *buffer, size_t offset, size_t count);
PHANIDE_CORE_EXPORT intptr_t phanide_process_pipe_write(phanide_process_t *process, phanide_pipe_index_t pipe, const void *buffer, size_t offset, size_t count);

/* File system monitors */
PHANIDE_CORE_EXPORT phanide_fsmonitor_handle_t *phanide_fsmonitor_watchFile(phanide_context_t *context, const char *path);
PHANIDE_CORE_EXPORT phanide_fsmonitor_handle_t *phanide_fsmonitor_watchFirectory(phanide_context_t *context, const char *path);
PHANIDE_CORE_EXPORT void phanide_fsmonitor_destroy(phanide_context_t *context, phanide_fsmonitor_handle_t *handle);

/* Event queue */
PHANIDE_CORE_EXPORT int phanide_pollEvent(phanide_context_t *context, phanide_event_t *event);
PHANIDE_CORE_EXPORT int phanide_waitEvent(phanide_context_t *context, phanide_event_t *event);
PHANIDE_CORE_EXPORT int phanide_pushEvent(phanide_context_t *context, phanide_event_t *event);

#endif /* _PHANIDE_PHANIDE_H_ */
