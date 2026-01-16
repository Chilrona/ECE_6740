#include "mothership.h"
#include "Instrucion_Macros.h"
#include "stdint.h"
/*Pseudocode:
split into 4 different strings
sort by op code
figure out which destination register we want
figure out which primary input register we want
figure out which secondary input register we want
complete binary or to get the resulting line
*/

char* parseREGISTER(char* line)
{
    uint32_t op_code;
    uint32_t RS, R_pri, R_sec;
    //split the line between the 4 parts
    //create a look up table and use it to get the marcros of each
    //return the value in this format '10200000;'



    switch (line[0]) 
    {
        case 'A': //this is going to be ADD ADDU or AND
            if(line[1]=='D') 
            {
                if(line[3]=='U')
                {
                    opcode = ADDU_OPCODE;
                }
                  opcode = ADD_OPCODE;
            }
            else 
            {
              opcode = AND_OPCODE;  
            }
        break;

        case 'S'://this is going to be SUB SUBU
        if(line[1]=='U')
        {


        }
        else if(line[1]=='L')
        {

        }
        else if(line[1]=='G')
        {


        }
        else if(line[1]=='N')
        {

            
        }
        else if(line[1]=='R')
        {

            
        }
        break;
        case 'O':
        break;
        case 'X':
        break;
        case '':
        break;
        case '':
        break;
        default:
        break;

    }
    return 
}