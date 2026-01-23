#include <cstdint>
#include "mothership.h"
#include <string>

struct Instruction_Register {
    std::string opcode;
    std::string regOut;
    std::string regPri;
    std::string regSec;
};

Instruction_Register parseInstructionLine1(const std::string& line);
uint32_t parse_register(char* line_ptr);