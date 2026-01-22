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
    string regOut;
    string regPri;
    string immStr;
};

Instruction parseInstructionLine(const string& line)
{
    // Make a local copy so we can modify it
    string cleaned = line;

    istringstream iss(cleaned);

    Instruction inst;
    iss >> inst.opcode >> inst.regOut >> inst.regPri >> inst.immStr;

    return inst;
}

uint32_t parseImmediate(char* line_ptr)
{
    string line = line_ptr;
	uint32_t opcodeBits, regOutBits, regPriBits, immBits, machineCode=0;
    //string line = "ADDI R2, R1, 5";

    Instruction inst = parseInstructionLine(line);
	
    // 1) opcode
    auto opIt = opcodeTable.find(inst.opcode);
    if (opIt == opcodeTable.end()) 
    {
        cerr << "Unknown opcode: " << inst.opcode << endl;
    }

    opcodeBits = opIt->second;

    // 2) rd (dest)
    auto rdIt = destRegTable.find(inst.regOut);
    if (rdIt == destRegTable.end())
    {
        cerr << "Unknown opcode: " << inst.regOut << endl;
    }

    regOutBits = rdIt->second;

    //3) rs1 (primary)
    auto rs1It = rs1Table.find(inst.regPri);
    if (rs1It == rs1Table.end())
    {
        cerr << "Unknown primary register: " << inst.regPri << endl;
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
    }
    
    // 5) build final instruction word
    // ASSUMPTION: immediate is bits [15:0]
    machineCode = opcodeBits | regOutBits | regPriBits | immBits;

    return machineCode;
}

