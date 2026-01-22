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
    const char* mnemonic;
    inst_type type;
} mnemonic_entry;
static const mnemonic_entry MNEMONICS[] =
{
    { "ADD",   REGISTER },
    { "ADDI",  IMMEDIATE },
    { "ADDU",  REGISTER },
    { "ADDUI", IMMEDIATE },

    { "AND",   REGISTER },
    { "ANDI",  IMMEDIATE },

    { "BEQZ",  REGISTER },
    { "BNEZ",  REGISTER },

    { "J",     JUMP },
    { "JAL",   JUMP },
    { "JALR",  JUMP },
    { "JR",    JUMP },

    { "LW",    MEMORY },

    { "NOP",   REGISTER },

    { "OR",    REGISTER },
    { "ORI",   IMMEDIATE },

    { "SEQ",   REGISTER },
    { "SEQI",  IMMEDIATE },

    { "SGE",   REGISTER },
    { "SGEI",  IMMEDIATE },
    { "SGEU",  REGISTER },
    { "SGEUI", IMMEDIATE },

    { "SGT",   REGISTER },
    { "SGTI",  IMMEDIATE },
    { "SGTU",  REGISTER },
    { "SGTUI", IMMEDIATE },

    { "SLE",   REGISTER },
    { "SLEI",  IMMEDIATE },
    { "SLEU",  REGISTER },
    { "SLEUI", IMMEDIATE },

    { "SLL",   REGISTER },
    { "SLLI",  IMMEDIATE },

    { "SLT",   REGISTER },
    { "SLTI",  IMMEDIATE },
    { "SLTU",  REGISTER },
    { "SLTUI", IMMEDIATE },

    { "SNE",   REGISTER },
    { "SNEI",  IMMEDIATE },

    { "SRA",   REGISTER },
    { "SRAI",  IMMEDIATE },

    { "SRL",   REGISTER },
    { "SRLI",  IMMEDIATE },

    { "SUB",   REGISTER },
    { "SUBI",  IMMEDIATE },
    { "SUBU",  REGISTER },
    { "SUBUI", IMMEDIATE },

    { "SW",    MEMORY },

    { "XOR",   REGISTER },
    { "XORI",  IMMEDIATE }
};

static const size_t MNEMONICS_COUNT = sizeof(MNEMONICS) / sizeof(MNEMONICS[0]);

static int mnemonic_cmp(const void* key, const void* elem)
{
    return(strcmp((const char*)key, ((const mnemonic_entry*)elem)->mnemonic));
}

mnemonic_entry* lookup_mnemonic(const char* mnemonic_str)
{
    int i = 0;
    char mnemonic_str_upper[64];
    while (mnemonic_str[i] != '\0') // Force the characters to be uppercase
    {
        mnemonic_str_upper[i] = (char)toupper((unsigned char)mnemonic_str[i++]);
    }
    mnemonic_str_upper[i] = '\0';
    mnemonic_entry* result = bsearch(mnemonic_str_upper,
                    MNEMONICS,
                    MNEMONICS_COUNT,
                    sizeof(MNEMONICS[0]),
                    mnemonic_cmp);
    return (result); 
}
