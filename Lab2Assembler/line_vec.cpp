#include <cstdint>
#include <cstdlib>
#include "string.h"
#include <iostream>
#include "line_vec.h"

void linevec_init(line_vec *v)
{
    v->items = NULL;
    v->len = 0;
    v->cap = 0;
}

void linevec_free(line_vec *v)
{
    for (size_t i = 0; i < v->len; i++)
    {
        free(v->items[i].text);
    }
    free(v->items);
    linevec_init(v);
}

void linevec_grow_if_needed(line_vec *v)
{
    if (v->len < v->cap) return;
    v->cap = (v->cap == 0)? 16 : (v->cap *2);

    line_rec *new_items = (line_rec*)realloc(v->items, v->cap*sizeof(line_rec));
    if (!new_items)
    {
        std::cerr << "realloc" << std::endl;
        abort();
    }
    v->items = new_items;
}

void linevec_push(line_vec *v, int line_num, uint32_t addr, const char *clean_line)
{
    linevec_grow_if_needed(v);

    v->items[v->len].addr = addr;
    v->items[v->len].line_num = line_num;
    v->items[v->len].text = strdup(clean_line);
    if (!v->items[v->len].text)
    {
        std::cerr << "strdup problem" << std::endl;
        abort();
    }
    v->len++;
}