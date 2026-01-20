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

vector<Instruction> parseInstructionLine(const string& line)
{
    // Make a local copy so we can modify it
    string cleaned = line;

    // Remove commas from the line
    cleaned.erase(remove(cleaned.begin(), cleaned.end(), ','), cleaned.end());

    istringstream iss(cleaned);
    vector<Instruction> result;

    Instruction inst;
    if (iss >> inst.opcode >> inst.regOut >> inst.regPri >> inst.immStr)
        result.push_back(inst);

    return result;
}

uint32_t encodeImm(const string& immStr) 
{
    int value = stoi(immStr);

    if (value < 0 || value > 0xFFFF) {
        throw std::out_of_range("Immediate out of range (0–65535)");
    }

    return static_cast<uint32_t>(value); // 5 -> 0x00000005
}


uint32_t parseImmediate(const string& line)
{
	uint32_t opcodeBits, regOutBits, regPriBits, immBits, machineCode;
    string line = "ADDI R2, R1, 5";

    auto instructions = parseInstructionLine(line);
	// 1) opcode
for (const auto& inst : instructions) 
{
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
        immBits = encodeImm(inst.immStr) & 0xFFFF; //keep low 16 bits
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
}
 

    return machineCode;
}

