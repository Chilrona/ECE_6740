
#include <cstdint>
#include <string>
#include "mothership.h"


struct Instruction 
{
    std::string opcode;
    std::string sec_param;
};

uint32_t parse_jump(char* line_ptr, Label* label_table);
