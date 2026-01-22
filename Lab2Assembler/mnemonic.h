#include "mothership.h"

typedef struct
{
    const char* mnemonic;
    inst_type type;
} mnemonic_entry;


static int mnemonic_cmp(const void* key, const void* elem);
mnemonic_entry* lookup_mnemonic(const char* mnemonic_str);