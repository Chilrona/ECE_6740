
#include <cstdint>
#include <string>
#include "mothership.h"


struct Instruction_Print
{
    std::string opcode;
    std::string first_field;
};

uint32_t parse_print(char* line_ptr);
