#include "stdio.h"
#define IMMEDIATE 1
#define MEMORY 2
#define REGISTER 3
#define JUMP 4



void strip(char *s)
{
    char *src = s;
    char *dst = s;

    while (*src) {
        if (*src != ',' && !isspace((unsigned char)*src)) {
            *dst++ = *src;
        }
        src++;
    }
    *dst = '\0';
}

void parseInstruction(char* line, char* op_word, int inst_type)
{
    case (inst_type)
    {
        IMMEDIATE:
            parseImmediate(line, size_of_op_word);
        MEMORY:
            parseMemory(line, op_word);
        REGISTER:
            parseREGISTER();
        
        
    }
}

int main(int argc, char* argv[])
{
    if (argc != 4)
    {
        printf("not enough files");
        return 0;
    }
    //defining the input file
    FILE *inputfile= fopen(argv[1], 'r');
    char line[256];
    //defining and opening the output files
    FILE *outdata= fopen(argv[2], 'w');
    FILE *outcode= fopen(argv[3], 'w');
    int inst_type;
    while(fgets(line, sizeof(line), inputfile))
    {
        op_word = getFirstWord(line)
        if op_word[-1] == 'I' {
            inst_type = IMMEDIATE;
        }
        else if (op_word[0] == 'J')
        {
            inst_type = JUMP;
        }
        else if (op_word == 'SW' || op_word == 'LW' || op_word == 'NOP')
        {
            inst_type = MEMORY;
        } else
        {
            inst_type = REGISTER;
        }
        
        parseInstruction(line, inst_type);


    }



    return 0;
}