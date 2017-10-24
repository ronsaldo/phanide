#ifndef _PHANIDE_PHANIDE_H_
#define _PHANIDE_PHANIDE_H_

#include <stdint.h>

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
    PHANIDE_EVENT_TYPE_PROCESS_FINISHED
}phanide_event_type_t;

typedef struct phanide_event_process_finished_s
{
    phanide_event_type_t type;
    int32_t exitCode;
}phanide_event_process_finished_t;

typedef union phanide_event_s
{
    phanide_event_type_t type;
    phanide_event_process_finished_t processFinished;
} phanide_event_t;

/* Context creation */
PHANIDE_CORE_EXPORT phanide_context_t *phanide_createContext(void);
PHANIDE_CORE_EXPORT void phanide_destroyContext(phanide_context_t *context);

/* Process spawning */
PHANIDE_CORE_EXPORT phanide_process_t *phanide_process_spawn(phanide_context_t *context, const char *path, const char **argv);
PHANIDE_CORE_EXPORT phanide_process_t *phanide_process_spawnInPath(phanide_context_t *context, const char *file, const char **argv);
PHANIDE_CORE_EXPORT phanide_process_t *phanide_process_spawnShell(phanide_context_t *context, const char *command);

PHANIDE_CORE_EXPORT void phanide_process_wait(phanide_process_t *process);
PHANIDE_CORE_EXPORT void phanide_process_timedWait(phanide_process_t *process, int timeout);
PHANIDE_CORE_EXPORT void phanide_process_terminate(phanide_process_t *process);
PHANIDE_CORE_EXPORT void phanide_process_kill(phanide_process_t *process);

/* Event queue */
PHANIDE_CORE_EXPORT int phanide_pollEvent(phanide_context_t *context, phanide_event_t *event);
PHANIDE_CORE_EXPORT int phanide_waitEvent(phanide_context_t *context, phanide_event_t *event);
PHANIDE_CORE_EXPORT int phanide_pushEvent(phanide_context_t *context, phanide_event_t *event);

#endif /* _PHANIDE_PHANIDE_H_ */
