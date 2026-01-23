#include <iostream>
#include <sstream>
#include <string>

#include "stb_ds.h"
#include "memory.h"
#include "mothership.h"


using namespace std;

    // char line1[] = "LW R10 n R0";
    // char line2[] = "SW result R1 R12";

uint32_t parse_memory(char* line_ptr, Label* data_table)
{
    string line = line_ptr;
	uint32_t opcodeBits, rDataBits, rOffsetBits, baseAddrBits, machineCode=0;

    Instruction_Memory inst;
    istringstream iss(line);
    iss >> inst.opcode;
    if (inst.opcode == "SW"){
        iss >> inst.varName >> inst.rOffset >> inst.rData;
    } else if (inst.opcode == "LW")
    {
        iss >> inst.rData >> inst.varName >> inst.rOffset;
    }
    
    // 1) opcode
    auto opIt = opcodeTable.find(inst.opcode);
    if (opIt == opcodeTable.end()) 
    {
        cerr << "Unknown opcode: " << inst.opcode << endl;
        abort();
    }

    opcodeBits = opIt->second;

    // 2) r_data
    auto rdIt = destRegTable.find(inst.rData);
    if (rdIt == destRegTable.end())
    {
        cerr << "Unknown opcode: " << inst.rData << endl;
        abort();
    }

    rDataBits = rdIt->second;

    //3) r_offset
    auto rs1It = rs1Table.find(inst.rOffset);
    if (rs1It == rs1Table.end())
    {
        cerr << "Unknown primary register: " << inst.rOffset << endl;
        abort();
    }

    rOffsetBits = rs1It->second;

    // 4) Base Address
    
    baseAddrBits = shget(data_table, inst.varName.c_str());
    
    
    // 5) build final instruction word
    // ASSUMPTION: immediate is bits [15:0]
    machineCode = opcodeBits | rDataBits | rOffsetBits | baseAddrBits;

    return machineCode;
}