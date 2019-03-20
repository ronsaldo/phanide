#ifdef _WIN32

#include "internal.h"

typedef struct phanide_context_io_s
{
	int dummy;
} phanide_context_io_t;

#include "phanide.c"

static int
phanide_processThreadEntry(void *arg)
{
	(void)arg;
	return 0;
}

static void
phanide_wakeUpSelect(phanide_context_t *context)
{
	(void)context;
}

static int
phanide_createContextIOPrimitives(phanide_context_t *context)
{
	memset(context, 0, sizeof(phanide_context_t));

	context->signalSemaphoreWithIndex = (signalSemaphoreWithIndex_t)GetProcAddress(0, "signalSemaphoreWithIndex");
	if (!context->signalSemaphoreWithIndex)
		context->signalSemaphoreWithIndex = (signalSemaphoreWithIndex_t)GetProcAddress(0, "_signalSemaphoreWithIndex");

	return 1;
}

static void
phanide_context_destroyIOData(phanide_context_t *context)
{
	(void)context;
}

/* Process spawning */
PHANIDE_CORE_EXPORT phanide_process_t*
phanide_process_spawn(phanide_context_t *context, const char *path, const char **argv)
{
	(void)context;
	(void)path;
	(void)argv;
	return NULL;
}

PHANIDE_CORE_EXPORT phanide_process_t*
phanide_process_spawnInPath(phanide_context_t *context, const char *file, const char **argv)
{
	(void)context;
	(void)file;
	(void)argv;
	return NULL;
}

PHANIDE_CORE_EXPORT phanide_process_t*
phanide_process_spawnShell(phanide_context_t *context, const char *command)
{
	(void)context;
	(void)command;
	return NULL;
}

/* Process termination */
PHANIDE_CORE_EXPORT void
phanide_process_free(phanide_process_t *process)
{
	(void)process;
}

PHANIDE_CORE_EXPORT void
phanide_process_terminate(phanide_process_t *process)
{
	(void)process;
}

PHANIDE_CORE_EXPORT void
phanide_process_kill(phanide_process_t *process)
{
	(void)process;
}

/* Process pipes */
PHANIDE_CORE_EXPORT intptr_t
phanide_process_pipe_read(phanide_process_t *process, phanide_pipe_index_t pipe, void *buffer, size_t offset, size_t count)
{
	(void)process;
	(void)pipe;
	(void)buffer;
	(void)offset;
	(void)count;
	return PHANIDE_PIPE_ERROR;
}

PHANIDE_CORE_EXPORT intptr_t
phanide_process_pipe_write(phanide_process_t *process, phanide_pipe_index_t pipe, const void *buffer, size_t offset, size_t count)
{
	(void)process;
	(void)pipe;
	(void)buffer;
	(void)offset;
	(void)count;
	return PHANIDE_PIPE_ERROR;
}

/* File system monitors */
PHANIDE_CORE_EXPORT phanide_fsmonitor_handle_t*
phanide_fsmonitor_watchFile(phanide_context_t *context, const char *path)
{
	(void)context;
	(void)path;
	return NULL;
}

PHANIDE_CORE_EXPORT phanide_fsmonitor_handle_t*
phanide_fsmonitor_watchFirectory(phanide_context_t *context, const char *path)
{
	(void)context;
	(void)path;
	return NULL;
}

PHANIDE_CORE_EXPORT void
phanide_fsmonitor_destroy(phanide_context_t *context, phanide_fsmonitor_handle_t *handle)
{
	(void)context;
	(void)handle;
}

#endif //_WIN32
