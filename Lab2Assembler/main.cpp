#include "stdio.h"
#include "line_vec.h"
#include <ctype.h>
#include <limits.h>
#include <stdlib.h>
#include <stddef.h>   // size_t
#include <string.h>   // strcmp
#include <cstdint>
#include <iostream>
#include "register.h"
#include "immediate.h"
#include "memory.h"
#include "mothership.h"
#include "jump.h"
#include "print.h"
#include "stb_ds.h"

#define BASE_LINE_LENGTH 256
#define INITIAL_ADDR 0

void strip(char *s)
{
    char *src = s;
    char *dst = s;

    int prev_char = 0; // prevents leading spaces

    while (*src) {
        unsigned char c = (char)*src++;

        if (c == ';') break; // comment starts: ignore rest of line

        if (isspace(c)) {
            if(!prev_char)
            {
                continue;
            } else
            {
                *dst++ = ' ';
                prev_char = 0;
                continue;
            }
            
        }
        if (c == ',' || c==')' || c==':')
        {
            continue;
        }
        if (c=='(')
        {
            *dst++ = ' ';
            prev_char = 0;
            continue;
        }

        // Keep everything else
        *dst++ = (char)c;
        prev_char = 1;
    }

    // remove trailing space if present
    if (dst > s && dst[-1] == ' ')
        dst--;

    *dst = '\0';
}

char* try_parse_label(char* line, mnemonic_entry* mnemonic_table)
{
    char* save = NULL;
    char* label = strtok_r(strdup(line), " ", &save);
    if (shgeti(mnemonic_table, label) == -1)
    {
        
        return (label);
    }
    return(NULL);
}

void pass_one(FILE* infile, Label** label_table, line_vec* data_lines, line_vec* text_lines, mnemonic_entry* mnemonic_table)
{
    char* buf = (char*)calloc(1, BASE_LINE_LENGTH);
    linevec_init(data_lines);
    linevec_init(text_lines);
    uint32_t pc = 0;
    int label_idx = 0;
    int line_num = -1;
    Section mode = SEC_NONE;

    while(fgets(buf, BASE_LINE_LENGTH, infile))
    {
        // printf("PC value: %d\n", pc);
        char* line = buf;
        line_num++;
        strip(line); // Strips all commas and most whitespace from
                    // each line (leaves a single space between each word)
        if (!*line){continue;}

        if (strcmp(line, ".data") == 0)
        {
            mode = SEC_DATA;
            continue;
        } else if (strcmp(line, ".const") == 0)
        {
            mode = SEC_CONST;
            linevec_push(data_lines, line_num, INITIAL_ADDR, "const");
            continue;
        }else if (strcmp(line, ".text") == 0)
        {
            mode = SEC_TEXT;
            continue;
        }

        if (mode == SEC_TEXT)
        {
            char* label_name = try_parse_label(line, mnemonic_table); // looks for a label
            if (label_name != NULL)
            {
                shput(*label_table, strdup(label_name), pc);
                printf("Just added label: %s, %d\n", label_name, shget(*label_table, label_name));
                continue;
            }
            linevec_push(text_lines, line_num, pc++, strdup(line));
        } else if ((mode == SEC_DATA) || (mode == SEC_CONST))
        {
            linevec_push(data_lines, line_num, INITIAL_ADDR, strdup(line));   // Push The data line to the record.
                                                            // All addresses will initialize to 0, that will be corrected on the second pass.
        }
    }
    free(buf);
}

void pass_two_inst(FILE* out_code, Label** data_table, Label** label_table, mnemonic_entry* mnemonic_table, line_vec* text_lines)
{
    // Instruction pass two
    printf("Number of instruction lines: %d\n", text_lines->len);
    for (int i = 0; i < text_lines->len; i++)
    {
        char* save=NULL;
        // printf("%s\n", text_lines->items[i].text);
        char* line = strdup(text_lines->items[i].text);
        char* op_word = strtok_r(line, " ", &save);
        mnemonic_entry* entry = shgetp_null(mnemonic_table, op_word);
        if (entry == NULL)
        {
            std::cerr << "Instruction not found. " << op_word << std::endl;
            abort();
        }
        inst_type type = entry->value;
        uint32_t instruction=0;
        switch (type)
        {
            case IMMEDIATE:
                //printf("Immediate type found.\n");
                instruction = parse_immediate(text_lines->items[i].text, label_table);
                break;
            case MEMORY:
                //printf("Memory type found.\n");
                instruction = parse_memory(text_lines->items[i].text, data_table);
                break;
            case REGISTER:
                //printf("Register type found.\n");
                instruction = parse_register(text_lines->items[i].text);
                break;
            case JUMP:
                //printf("Jump type found.\n");
                instruction = parse_jump(text_lines->items[i].text, label_table);
                break;
            case PRINT:
                //printf("Print type found.\n");
                instruction = parse_print(text_lines->items[i].text);
                break;
            default:
                //printf("Invalid type type found.\n");
                instruction = 0; //NOP if we somehow get here.
                break;
        }
        fprintf(out_code, "%03X : %08X; --%s\n", text_lines->items[i].addr, instruction, text_lines->items[i].text);
        free(line);
    }
    fprintf(out_code, "\nEND;\n");
}

void pass_two_data(FILE* out_data, line_vec* data_lines, Label** data_table)
{
    uint16_t data_addr = 0;
    bool is_const = false;
    for (int i = 0; i < data_lines->len; i++)
    {
        if (strcmp(data_lines->items[i].text, "const") == 0)
        {
            is_const = true;
            printf("finished data, on to const\n");
            continue;
        }
        char* save = NULL;
        data_lines->items[i].addr = data_addr;
        line_rec curr_line = data_lines->items[i];
        char* line = curr_line.text;
        char* var_name = strdup(strtok_r(line, " ", &save));
        shput(*data_table, var_name, data_addr);
        // "m 10 0 4 0 5 6..."
        // Format for strtol(): long val = strtol(s, &end, 10);
        char* num_str = strtok_r(NULL, " ", &save);   // get size as a str
        int size = (int)strtol(num_str, NULL, 10);    // convert size to integer
        uint32_t data;
        for (int j = 0; j < size; j++)
        {
            
            if (is_const)
            {
                data = (uint32_t)save[j];
            }else
            {
                num_str = strtok_r(NULL, " ", &save);   // 
                data = (uint32_t)strtol(num_str, NULL, 10);
            }
            fprintf(out_data, "%03X : %08X; --%s[%d]\n", data_addr+j, data, var_name, j);
        }
        data_addr += size;
    }
    fprintf(out_data, "\nEND;\n");
}

void build_mnemonic_table(mnemonic_entry** table_ptr);

int main(int argc, char* argv[])
{
    // if (argc != 4)
    // {
    //     printf("not enough files");
    //     return 0;
    // }
    //defining the input file
    FILE *input_file= fopen(argv[1], "r");
    //defining and opening the output files
    FILE *out_data= fopen(argv[2], "w");
    FILE *out_code= fopen(argv[3], "w");

    fprintf(out_code,   "DEPTH = 1024;\n"
                        "WIDTH = 32;\n"
                        "ADDRESS_RADIX = HEX;\n"
                        "DATA_RADIX = HEX;\n"
                        "CONTENT\n"
                        "BEGIN\n\n");
    fprintf(out_data,   "DEPTH = 1024;\n"
                        "WIDTH = 32;\n"
                        "ADDRESS_RADIX = HEX;\n"
                        "DATA_RADIX = HEX;\n"
                        "CONTENT\n"
                        "BEGIN\n\n");

    Label* label_table = NULL;
    mnemonic_entry* mnemonic_table = NULL;
    build_mnemonic_table(&mnemonic_table);

    // int len=shlen(mnemonic_table);
    // for(int i =0; i<len;i++)
    // {
    //     printf("%s\t%d\n", mnemonic_table[i].key, mnemonic_table[i].value);
    // }

    line_vec data_lines, text_lines;
    pass_one(input_file, &label_table, &data_lines, &text_lines, mnemonic_table);

    printf("top address: %d\n", shget(label_table, "top"));
    printf("loop_multiply address: %d\n", shget(label_table, "loop_multiply"));
    printf("loopdone address: %d\n", shget(label_table, "loopdone"));
    printf("exit address: %d\n", shget(label_table, "exit"));
    

    Label* data_table = NULL;
    pass_two_data(out_data, &data_lines, &data_table);
    printf("Finished data pass two, on to instruction pass two...\n");
    pass_two_inst(out_code, &data_table, &label_table, mnemonic_table, &text_lines);

    fclose(out_data);
    fclose(out_code);

    shfree(mnemonic_table);
    shfree(label_table);
    shfree(data_table);
    return 0;
}

void build_mnemonic_table(mnemonic_entry** table_ptr)
{
    mnemonic_entry* table = NULL;
    shput(table, "ADD", REGISTER);
    shput(table, "ADDI", IMMEDIATE);
    shput(table, "ADDU", REGISTER);
    shput(table, "ADDUI", IMMEDIATE);

    shput(table, "AND", REGISTER);
    shput(table, "ANDI", IMMEDIATE);

    shput(table, "BEQZ", IMMEDIATE);
    shput(table, "BNEZ", IMMEDIATE);

    shput(table, "J", JUMP);
    shput(table, "JAL", JUMP);
    shput(table, "JALR", JUMP);
    shput(table, "JR", JUMP);

    shput(table, "LW", MEMORY);

    shput(table, "NOP", REGISTER);

    shput(table, "OR", REGISTER);
    shput(table, "ORI", IMMEDIATE);

    shput(table, "SEQ", REGISTER);
    shput(table, "SEQI", IMMEDIATE);

    shput(table, "SGE", REGISTER);
    shput(table, "SGEI", IMMEDIATE);
    shput(table, "SGEU", REGISTER);
    shput(table, "SGEUI", IMMEDIATE);

    shput(table, "SGT", REGISTER);
    shput(table, "SGTI", IMMEDIATE);
    shput(table, "SGTU", REGISTER);
    shput(table, "SGTUI", IMMEDIATE);

    shput(table, "SLE", REGISTER);
    shput(table, "SLEI", IMMEDIATE);
    shput(table, "SLEU", REGISTER);
    shput(table, "SLEUI", IMMEDIATE);

    shput(table, "SLL", REGISTER);
    shput(table, "SLLI", IMMEDIATE);

    shput(table, "SLT", REGISTER);
    shput(table, "SLTI", IMMEDIATE);
    shput(table, "SLTU", REGISTER);
    shput(table, "SLTUI", IMMEDIATE);

    shput(table, "SNE", REGISTER);
    shput(table, "SNEI", IMMEDIATE);

    shput(table, "SRA", REGISTER);
    shput(table, "SRAI", IMMEDIATE);

    shput(table, "SRL", REGISTER);
    shput(table, "SRLI", IMMEDIATE);

    shput(table, "SUB", REGISTER);
    shput(table, "SUBI", IMMEDIATE);
    shput(table, "SUBU", REGISTER);
    shput(table, "SUBUI", IMMEDIATE);

    shput(table, "SW", MEMORY);

    shput(table, "XOR", REGISTER);
    shput(table, "XORI", IMMEDIATE);

    shput(table, "PCH", PRINT);
    shput(table, "PD", PRINT);
    shput(table, "PDU", PRINT);

    shput(table, "GD", PRINT);
    shput(table, "GDU", PRINT);

    printf("Table Built!\n");
    *table_ptr=table;
}

// int main()
// {
//     char str[] = "\tADDI R1, R0, 0   ;skurp";
//     strip(str);
//     printf("%s\n", str);

//     return(0);
// }

// int main()
// {
//     char line1[] = "LW R10 n R0";
//     char line2[] = "SW result R0 R3";

//     Label* data_table = NULL;
//     shput(data_table, "n", 0);
//     shput(data_table, "result", 1);

//     uint32_t inst = parse_memory(line1, data_table);
//     printf("first instruction:\t\t%08X\n", inst);
    
//     inst = parse_memory(line2, data_table);
//     printf("second instruction:\t\t%08X\n", inst);

//     shfree(data_table);
//     return(0);
// }