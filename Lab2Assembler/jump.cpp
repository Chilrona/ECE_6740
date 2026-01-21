#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>  // required for std::
#include <iomanip>
#ifndef MOTHERSHIP_H
#define MOTHERSHIP_H

#include "mothership.h"

#endif

using namespace std;

struct Instruction 
{
    string opcode;
    string regPri;
    string address;
};

Instruction parseInstructionLine(const string& line)
{
    // Make a local copy so we can modify it
    string cleaned = line;

    istringstream iss(cleaned);

    Instruction inst;
    if (iss >> inst.opcode)
    {
        if (inst.opcode == "J" || inst.opcode == "JAL")
            iss >> inst.address;
        else if (inst.opcode == "JR" || inst.opcode == "JALR")
            iss >> inst.regPri;
        return inst;
    }

    cerr << "Invalid Instruction";
}

uint32_t parse_jump(char* line_ptr)
{
    string line = line_ptr;
	uint32_t opcodeBits, regPriBits, addrBits, machineCode=0;

    Instruction inst = parseInstructionLine(line);
	// 1) opcode

    auto opIt = opcodeTable.find(inst.opcode);
    if (opIt == opcodeTable.end()) 
    {
        cerr << "Unknown opcode: " << inst.opcode << endl;
        continue;
    }

    opcodeBits = opIt->second;

    // 2) rd (dest)
    auto rdIt = destRegTable.find(inst.regOut);
    if (rdIt == destRegTable.end())
    {
        cerr << "Unknown opcode: " << inst.regOut << endl;
        continue;
    }

    regOutBits = rdIt->second;

    //3) rs1 (primary)
    auto rs1It = rs1Table.find(inst.regPri);
    if (rs1It == rs1Table.end())
    {
        cerr << "Unknown primary register: " << inst.regPri << endl;
        continue;
    }

    regPriBits = rs1It->second;

    // 4) immediate

    try
    {
        immBits = static_cast<uint32_t>(stoi(inst.immStr));
    }
    catch(const exception& e)
    {
        cerr << "Bad immediate: " << inst.immStr << " (" << e.what() << ")\n";
        continue;
    }
    
    // 5) build final instruction word
    // ASSUMPTION: immediate is bits [15:0]
    machineCode = opcodeBits | regOutBits | regPriBits | immBits;

    // cout << "opcodeBits = 0x" << hex << setw(8) << setfill('0') << opcodeBits << "\n";
    // cout << "regOutBits = 0x" << hex << setw(8) << setfill('0') << regOutBits << "\n";
    // cout << "rs1Bits    = 0x" << hex << setw(8) << setfill('0') << regPriBits << "\n";
    // cout << "immBits    = 0x" << hex << setw(8) << setfill('0') << immBits << "\n";
    // cout << "Machine    = 0x" << hex << setw(8) << setfill('0') << machineCode << endl;

 

    return machineCode;
}

