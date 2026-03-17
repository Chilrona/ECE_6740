#include <iostream>
#include <sstream>
#include <string>

#include <cstdint>
#include "stb_ds.h"
#include "mothership.h"
#include "print.h"

using namespace std;

uint32_t parse_print(char* line_ptr)
{
    string line = line_ptr;
	uint32_t opcodeBits, regPri, machineCode=0;

    istringstream iss(line);
    Instruction_Print inst;
    iss >> inst.opcode >> inst.regPri;
	
    // 1) opcode
    auto opIt = opcodeTable.find(inst.opcode);
    if (opIt == opcodeTable.end()) 
    {
        cerr << "Unknown opcode: " << inst.opcode << endl;
        abort();
    }

    opcodeBits = opIt->second;
    auto it = rs1Table.find(inst.regPri);
    regPri = it->second;

    machineCode = opcodeBits | regPri;
    return machineCode;
}

