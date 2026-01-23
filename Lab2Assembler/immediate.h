#include <cstdint>
#include <string>
#include "mothership.h"

struct Instruction_Imm 
{
    std::string opcode;
    std::string regOut;
    std::string regPri;
    std::string immStr;
};


uint32_t parse_immediate(char* line_ptr, Label** label_table);
