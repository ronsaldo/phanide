#ifndef PHANIDE_THREADS_H
#define PHANIDE_THREADS_H

#ifdef _WIN32

#else
/* Assume pthreads. */
#include <pthread.h>

typedef pthread_t phanide_thread_t;
typedef pthread_mutex_t phanide_mutex_t;
typedef pthread_cond_t phanide_condition_t;

typedef void *(*phanide_thread_entry_point_t)(void*);
inline int phanide_thread_create(phanide_thread_t *thread, phanide_thread_entry_point_t entryPoint, void *arg)
{
    return pthread_create(thread, NULL, entryPoint, arg);
}

inline int phanide_thread_wait(phanide_thread_t thread)
{
    void *returnValue = NULL;
    return pthread_join(thread, &returnValue);
}

inline int phanide_mutex_init(phanide_mutex_t *mutex)
{
    return pthread_mutex_init(mutex, NULL);
}

inline int phanide_mutex_destroy(phanide_mutex_t *mutex)
{
    return pthread_mutex_destroy(mutex);
}

inline int phanide_mutex_lock(phanide_mutex_t *mutex)
{
    return pthread_mutex_lock(mutex);
}

inline int phanide_mutex_unlock(phanide_mutex_t *mutex)
{
    return pthread_mutex_unlock(mutex);
}

inline int phanide_condition_init(phanide_condition_t *cond)
{
    return pthread_cond_init(cond, NULL);
}

inline int phanide_condition_destroy(phanide_condition_t *cond)
{
    return pthread_cond_destroy(cond);
}

inline int phanide_condition_wait(phanide_condition_t *cond, phanide_mutex_t *mutex)
{
    return pthread_cond_wait(cond, mutex);
}

inline int phanide_condition_broadcast(phanide_condition_t *cond)
{
    return pthread_cond_broadcast(cond);
}

#endif

#endif /* PHANIDE_THREADS_H*/
