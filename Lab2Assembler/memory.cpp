#include <iostream>
#include <sstream>
#include <string>

#include "stb_ds.h"
#include "memory.h"
#include "mothership.h"


using namespace std;



uint32_t parse_immediate(char* line_ptr, Label* data_table)
{
    string line = line_ptr;
	uint32_t opcodeBits, rDataBits, rOffsetBits, baseAddrBits, machineCode=0;
    //string line = "ADDI R2, R1, 5";

    Instruction inst;
    istringstream iss(line);
    iss >> inst.opcode >> inst.rData >> inst.rOffset >> inst.baseAddr;
	
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
    
    baseAddrBits = shget(data_table, inst.baseAddr.c_str());
    
    
    // 5) build final instruction word
    // ASSUMPTION: immediate is bits [15:0]
    machineCode = opcodeBits | rDataBits | rOffsetBits | baseAddrBits;

    return machineCode;
}