#include "stdio.h"

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
    while(fgets(line, sizeof(line), inputfile))
    {



    }



    return 0;
}