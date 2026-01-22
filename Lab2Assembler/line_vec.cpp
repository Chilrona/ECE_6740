#include <cstdint>
#include <cstdlib>
#include "string.h"

typedef struct {
    int      line_num;   // original source line number (for errors)
    uint16_t addr;      // address within its section (data addr or text pc)
    char    *text;      // cleaned line text (heap allocated)
} line_rec;

typedef struct {
    line_rec *items;
    size_t   len;
    size_t   cap;
} line_vec;

typedef enum { SEC_NONE, SEC_DATA, SEC_TEXT } Section;

static void linevec_init(line_vec *v)
{
    v->items = NULL;
    v->len = 0;
    v->cap = 0;
}

static void linevec_free(line_vec *v)
{
    for (size_t i = 0; i < v->len; i++)
    {
        free(v->items[i].text);
    }
    free(v->items);
    linevec_init(v);
}

static void linevec_grow_if_needed(line_vec *v)
{
    if (v->len < v->cap) return;
    size_t new_cap = (v->cap == 0)? 16 : (v->cap *2);

    line_rec *new_items = realloc(v->items, new_cap*sizeof(line_rec));
    if (!new_items)
    {
        perror("realloc");
        exit(1);
    }
}

static void linevec_push(line_vec *v, int line_num, uint16_t addr, const char *clean_line)
{
    linevec_grow_if_needed(v);

    v->items[v->len].line_num = line_num;
    v->items[v->len].addr = addr;
    v->items[v->len].text = strdup(clean_line);
    if (!v->items[v->len].text)
    {
        perror("strdup problem");
        exit(1);
    }
    v->len++;
}