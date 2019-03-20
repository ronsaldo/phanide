#ifndef PHANIDE_THREADS_H
#define PHANIDE_THREADS_H

typedef int (*phanide_thread_entry_point_t)(void*);
#ifdef _WIN32

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif

#include <windows.h>

typedef HANDLE phanide_thread_t;
typedef CRITICAL_SECTION phanide_mutex_t;
typedef CONDITION_VARIABLE phanide_condition_t;

typedef struct phanide_thread_entry_arg_s
{
	phanide_thread_entry_point_t entryPoint;
	void *argument;
} phanide_thread_entry_arg_t;

static inline DWORD WINAPI
phanide_thread_entry(LPVOID param)
{
	phanide_thread_entry_arg_t arg = *((phanide_thread_entry_arg_t*)param);
	free(param);

	return arg.entryPoint(arg.argument);
}

static inline int
phanide_thread_create(phanide_thread_t *thread, phanide_thread_entry_point_t entryPoint, void *argument)
{
	phanide_thread_entry_arg_t *entryArgument = (phanide_thread_entry_arg_t*)malloc(sizeof(phanide_thread_entry_arg_t));
	entryArgument->entryPoint = entryPoint;
	entryArgument->argument = argument;

	*thread = CreateThread(NULL, 0, phanide_thread_entry, entryArgument, 0, NULL);
	if (*thread == NULL)
	{
		free(entryArgument);
		return -1;
	}

	return 0;
}

static inline int
phanide_thread_join(phanide_thread_t thread)
{
	DWORD result = WaitForMultipleObjects(1, thread, TRUE, INFINITE);
	if (result == WAIT_FAILED)
		return 1;

	CloseHandle(thread);
	return 0;
}

static inline int
phanide_mutex_init(phanide_mutex_t *mutex)
{
	InitializeCriticalSection(mutex);
	return 0;
}

static inline int phanide_mutex_destroy(phanide_mutex_t *mutex)
{
	DeleteCriticalSection(mutex);
	return 0;
}

static inline int phanide_mutex_lock(phanide_mutex_t *mutex)
{
	EnterCriticalSection(mutex);
	return 0;
}

static inline int phanide_mutex_unlock(phanide_mutex_t *mutex)
{
	LeaveCriticalSection(mutex);
	return 0;
}

static inline int phanide_condition_init(phanide_condition_t *cond)
{
	InitializeConditionVariable(cond);
	return 0;
}

static inline int phanide_condition_destroy(phanide_condition_t *cond)
{
	/* There is no delete on windows: See https://stackoverflow.com/questions/28975958/why-does-windows-have-no-deleteconditionvariable-function-to-go-together-with */
	(void)cond;
	return 0;
}

static inline int phanide_condition_wait(phanide_condition_t *cond, phanide_mutex_t *mutex)
{
	return SleepConditionVariableCS(cond, mutex, INFINITE) == ERROR_TIMEOUT;
}

static inline int phanide_condition_signal(phanide_condition_t *cond)
{
	WakeConditionVariable(cond);
	return 0;
}

static inline int phanide_condition_broadcast(phanide_condition_t *cond)
{
	WakeAllConditionVariable(cond);
	return 0;
}

#else
/* Assume pthreads. */
#include <pthread.h>
#include <stdint.h>

typedef pthread_t phanide_thread_t;
typedef pthread_mutex_t phanide_mutex_t;
typedef pthread_cond_t phanide_condition_t;

typedef struct phanide_thread_entry_arg_s
{
	phanide_thread_entry_point_t entryPoint;
	void *argument;
} phanide_thread_entry_arg_t;

static inline void* phanide_thread_entry(void *param)
{
	phanide_thread_entry_arg_t arg = *((phanide_thread_entry_arg_t*)param);
	free(param);

	return (void*)((intptr_t)arg.entryPoint(arg.argument));
}

static inline int phanide_thread_create(phanide_thread_t *thread, phanide_thread_entry_point_t entryPoint, void *argument)
{
	phanide_thread_entry_arg_t *entryArgument = (phanide_thread_entry_arg_t*)malloc(sizeof(phanide_thread_entry_arg_t));
	entryArgument->entryPoint = entryPoint;
	entryArgument->argument = argument;

	int error = pthread_create(thread, NULL, phanide_thread_entry, entryArgument);
	if (error)
		free(entryArgument);

	return error;
}

static inline int phanide_thread_join(phanide_thread_t thread)
{
    void *returnValue = NULL;
    return pthread_join(thread, &returnValue);
}

static inline int phanide_mutex_init(phanide_mutex_t *mutex)
{
    return pthread_mutex_init(mutex, NULL);
}

static inline int phanide_mutex_destroy(phanide_mutex_t *mutex)
{
    return pthread_mutex_destroy(mutex);
}

static inline int phanide_mutex_lock(phanide_mutex_t *mutex)
{
    return pthread_mutex_lock(mutex);
}

static inline int phanide_mutex_unlock(phanide_mutex_t *mutex)
{
    return pthread_mutex_unlock(mutex);
}

static inline int phanide_condition_init(phanide_condition_t *cond)
{
    return pthread_cond_init(cond, NULL);
}

static inline int phanide_condition_destroy(phanide_condition_t *cond)
{
    return pthread_cond_destroy(cond);
}

static inline int phanide_condition_wait(phanide_condition_t *cond, phanide_mutex_t *mutex)
{
    return pthread_cond_wait(cond, mutex);
}

static inline int phanide_condition_signal(phanide_condition_t *cond)
{
    return pthread_cond_signal(cond);
}

static inline int phanide_condition_broadcast(phanide_condition_t *cond)
{
    return pthread_cond_broadcast(cond);
}

#endif

#endif /* PHANIDE_THREADS_H*/
