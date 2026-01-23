#include <cstdint>
#include <string>
#include "mothership.h"

struct Instruction 
{
    std::string opcode;
    std::string rData;
    std::string rOffset;
    std::string baseAddr;
};

uint32_t parse_immediate(char* line_ptr, Label* data_table);