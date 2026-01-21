#include <stddef.h>   // size_t
#include <stdlib.h>   // bsearch
#include <string.h>   // strcmp
#include <ctype.h>

#ifndef MOTHERSHIP_H
#define MOTHERSHIP_H
#include "mothership.h"
#endif

typedef struct
{
    const chat* mnemonic;
    inst_type type;
} mnemonic_entry;

static const mnemonic_entry MNEMONICS[] = 
{
    //...
}

static const size_t MNEMONICS_COUNT = sizeof(MNEMONICS) / sizeof(MNEMONICS[0]);

static int mnemonic_cmp(const void* key, const void* elem)
{
    return(strcmp((const char*)key, ((const mnemonic_entry*)elem)->mnemonic));
}

const mnemonic_entry* lookup_mnemonic(const char* mnemonic_str)
{
    int i = 0;
    char mnemonic_str_upper[64];
    while (mnemonic_str[i] != '\0') // Force the characters to be uppercase
    {
        mnemonic_str_upper[i] = (char)toupper((unsigned char)mnemonic_str[i++]);
    }
    mnemonic_str_upper[i] = '\0';
    const mnemonic_entry* result = bsearch(mnemonic_str_upper,
                    MNEMONICS,
                    MNEMONICS_COUNT,
                    sizeof(MNEMONICS[0]),
                    mnemonic_cmp);
    return (result); 
}
