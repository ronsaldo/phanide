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

#ifdef BUILD_PHANIDE
#define PHANIDE_CORE_EXPORT PHANIDE_C_LINKAGE PHANIDE_DLL_EXPORT
#else
#define PHANIDE_CORE_EXPORT PHANIDE_C_LINKAGE PHANIDE_DLL_IMPORT
#endif

struct phanide_context_s;
typedef struct phanide_context_s phanide_context_t;

struct phanide_process_s;
typedef struct phanide_process_s phanide_process_t;

typedef enum phanide_event_type_e
{
    PHANIDE_EVENT_TYPE_NONE = 0,
    PHANIDE_EVENT_TYPE_PROCESS_FINISHED,
    PHANIDE_EVENT_TYPE_PROCESS_PIPE_READY,
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

typedef union phanide_event_s
{
    uint32_t type;
    phanide_event_process_pipe_t processPipe;
    phanide_event_process_finished_t processFinished;
    uintptr_t padding[16];/* Maximum number of fields*/
} phanide_event_t;

/* Context creation */
PHANIDE_CORE_EXPORT phanide_context_t *phanide_createContext(void);
PHANIDE_CORE_EXPORT void phanide_destroyContext(phanide_context_t *context);

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

/* Event queue */
PHANIDE_CORE_EXPORT int phanide_pollEvent(phanide_context_t *context, phanide_event_t *event);
PHANIDE_CORE_EXPORT int phanide_waitEvent(phanide_context_t *context, phanide_event_t *event);
PHANIDE_CORE_EXPORT int phanide_pushEvent(phanide_context_t *context, phanide_event_t *event);

#endif /* _PHANIDE_PHANIDE_H_ */
