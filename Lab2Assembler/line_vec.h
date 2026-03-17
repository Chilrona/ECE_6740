#include <cstdint>

typedef struct {
    int      line_num;   // original source line number (for errors)
    uint32_t addr;      // address within its section (data addr or text pc)
    char    *text;      // cleaned line text (heap allocated)
} line_rec;

typedef struct {
    line_rec *items;
    std::size_t   len;
    std::size_t   cap;
} line_vec;

void linevec_init(line_vec *v);
void linevec_free(line_vec *v);
void linevec_grow_if_needed(line_vec *v);
void linevec_push(line_vec *v, int line_num, uint32_t addr, const char *clean_line);