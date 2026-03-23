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
	uint32_t opcodeBits, regOut, regPri, machineCode=0;

    istringstream iss(line);
    Instruction_Print inst;
    iss >> inst.opcode >> inst.first_field;
	
    // 1) opcode
    auto opIt = opcodeTable.find(inst.opcode);
    if (opIt == opcodeTable.end()) 
    {
        cerr << "Unknown opcode: " << inst.opcode << endl;
        abort();
    }

    opcodeBits = opIt->second;

    if (opIt->first == "GD" || opIt->first == "GDU")
    {
        auto it = destRegTable.find(inst.first_field);
        regOut = it->second;
        machineCode = opcodeBits | regOut;
    } else
    {
        auto it = rs1Table.find(inst.first_field);
        regPri = it->second;
        machineCode = opcodeBits | regPri;
    }
    
    return machineCode;
}

