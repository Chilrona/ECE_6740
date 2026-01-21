#include "stdio.h"
#include "line_vec.c"
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdlib.h>

#ifndef MOTHERSHIP_H
#define MOTHERSHIP_H

#include "mothership.h"

#endif

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
        if (c == ',')
        {
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

void passOne(FILE infile, label* label_table, line_vec* data_lines, line_vec* text_lines)
{
    char line[256];
    linevec_init(&data_lines);
    linevec_init(&text_lines);
    uint16_t pc = 0;
    uint16_t data_addr = 0;
    int label_idx = 0;
    int line_num = -1;
    Section mode = SEC_NONE;
    while(fgets(line, sizeof(line), infile))
    {
        line_num++;
        strip(line); // Strips all commas and most whitespace from
                    // each line (leaves a single space between each word)
        if (!*line){continue;}

        if (strcmp(line, ".data"))
        {
            mode = SEC_DATA;
            continue;
        } else if (strcmp(line, ".text"))
        {
            mode = SEC_TEXT;
            continue;
        }

        if (mode == SEC_TEXT)
        {
            char* label_name = tryParseLabel(&line); // looks for a label, if so
                                                    // trim it off the front
            if (label_name)
            {
                label_table[label_idx].name = label_name;
                label_table[label_idx++].addr = pc;
            }
            if (!*line) continue;
            linevec_push(&text_lines, line_num, pc++, line);
        } else if (mode == SEC_DATA)
        {
            linevec_push(&data_lines, line_num, data_addr++, line);
        }
    }
}

void passTwoInst(FILE out_code, label* label_table, var* data_table, line_vec* text_lines)
{
    // Instruction pass two
    for (int i = 0; i < text_lines->len; i++)
    {
        inst_type type = getType(text_lines->items[i].text);
        uint32_t instruction;
        switch (type)
        {
            case IMMEDIATE:
                instruction = parseImmediate(text_lines->items[i].text);
                break;
            case MEMORY:
                instruction = parseMemory(text_lines->items[i].text, data_table);
                break;
            case REGISTER:
                instruction = parseRegister(text_lines->items[i].text);
                break;
            case JUMP:
                instruction = parseJump(text_lines->items[i].text);
                break;
            default:
                instruction = 0; //NOP
                break;
        }
        writeCodeLine(out_code, text_lines->items[i], instruction);
    }
    fprintf(out_code, "\nEND;\n");
}

void passTwoData(FILE out_data, line_vec* data_lines, var* data_table)
{
    for (int i = 0; i < data_lines->len; i++)
    {
        char* save = NULL;
        line_rec curr_line = data_lines->items[i];
        char* line_walk = curr_line.text;
        data_table[i].name = strtok_r(line_walk, " ", &save);   // get var name
        data_table[i].addr = curr_line.addr;
        // "m 10 0 4 0 5 6..."
        // Format for strtol(): long val = strtol(s, &end, 10);
        char* num_str = strtok_r(NULL, " ", &save);   // get size as a str
        data_table[i].size = (uint32_t)strtol(num_str, NULL, 10);    // convert size to integer
        uint32_t data;
        for (int j = 0; j < data_table[i].size)
        {
            num_str = strtok(NULL, " ");   // 
            data = (uint32_t)strtol(num_str, NULL, 10);
            fprintf(out_data, "%03X : %08X; --%s[%d]", data_table[i].addr, data, data_table[i].name, j);
        }
    }
    fprintf(out_data, "\nEND;\n");
}

int main(int argc, char* argv[])
{
    if (argc != 4)
    {
        printf("not enough files");
        return 0;
    }
    //defining the input file
    FILE *input_file= fopen(argv[1], 'r');
    //defining and opening the output files
    FILE *out_data= fopen(argv[2], 'w');
    FILE *out_code= fopen(argv[3], 'w');
    label label_table[16];
    line_vec data_lines, text_lines;
    passOne(input_file, label_table, &data_lines, &text_lines);
    var data_table[data_lines.len];
    passTwoData(out_data, data_lines, data_table);
    passTwoInst(out_code, label_table, data_table, text_lines);


    return 0;
}