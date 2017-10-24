#ifndef PHANIDE_INTERNAL_H
#define PHANIDE_INTERNAL_H

#include <phanide/phanide.h>
#include <stddef.h>
#include <assert.h>
#include "threads.h"

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

inline void
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
        list->last = node;
    node->previous = NULL;
    node->next = NULL;
}

inline void
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

#endif /*PHANIDE_INTERNAL_H*/
