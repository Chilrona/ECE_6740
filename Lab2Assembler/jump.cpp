#include <iostream>
#include <sstream>
#include <string>

#include <cstdint>
#include "stb_ds.h"
#include "mothership.h"
#include "jump.h"

using namespace std;

uint32_t parse_jump(char* line_ptr, Label* label_table)
{
    string line = line_ptr;
	uint32_t opcodeBits, addrBits, machineCode=0;

    istringstream iss(line);
    Instruction inst;
    iss >> inst.opcode >> inst.sec_param;
	
    // 1) opcode
    auto opIt = opcodeTable.find(inst.opcode);
    if (opIt == opcodeTable.end()) 
    {
        cerr << "Unknown opcode: " << inst.opcode << endl;
        abort();
    }

    opcodeBits = opIt->second;

     // 2) 
    if (inst.opcode == "J" || inst.opcode == "JAL")
    {
        addrBits = shget(label_table, inst.sec_param.c_str());
    }
    else if (inst.opcode == "JR" || inst.opcode == "JALR")
    {
        auto rs1It = rs1Table.find(inst.sec_param);
        if (rs1It == rs1Table.end())
        {
            cerr << "Unknown primary register: " << inst.sec_param << endl;
            abort();
        }

        addrBits = rs1It->second;
    }
 
    // 5) build final instruction word
    // ASSUMPTION: immediate is bits [15:0]
    machineCode = opcodeBits | addrBits;
    return machineCode;
}

