#include <cstdint>
#include <string>
#include "mothership.h"

struct Instruction_Memory 
{
    std::string opcode;
    std::string rData;
    std::string varName;
    std::string rOffset;
};

uint32_t parse_memory(char* line_ptr, Label* data_table);