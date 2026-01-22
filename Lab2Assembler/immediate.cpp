#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>  // required for std::
#include <iomanip>
#include <cstdio>

#ifndef STB_DS_IMPLEMENTATION_H
#define STB_DS_IMPLEMENTATION_H

#include "stb_ds.h"

#endif
#include "mothership.h"


using namespace std;

struct Instruction 
{
    string opcode;
    string regOut;
    string regPri;
    string immStr;
};

uint32_t resolve_label(string label, label* label_table)
{
    int label_idx = hmgeti(label_table, label.c_str());
    if (label_idx == -1)
    {
        cerr << "Label Not Found." << label << endl;
    }
    return (label_table[label_idx].addr);
}

uint32_t parse_immediate(char* line_ptr, label* label_table)
{
    string line = line_ptr;
	uint32_t opcodeBits, regOutBits, regPriBits, immBits, machineCode=0;
    //string line = "ADDI R2, R1, 5";

    Instruction inst;
    istringstream iss(line);
    iss >> inst.opcode >> inst.regOut >> inst.regPri;
	
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
    if (!(iss >> inst.immStr))
    {
        immBits = resolve_label(inst.regPri, label_table);
        regPriBits = 0;
    } else
    {
        try
        {
            immBits = static_cast<uint32_t>(stoi(inst.immStr));
        }
        catch(const exception& e)
        {
            cerr << "Bad immediate: " << inst.immStr << " (" << e.what() << ")\n";
        }
    }
    
    
    // 5) build final instruction word
    // ASSUMPTION: immediate is bits [15:0]
    machineCode = opcodeBits | regOutBits | regPriBits | immBits;

    return machineCode;
}

int main()
{
    char line[] = "ADDI R1 R0 0";
    label* label_table = NULL;
    hmput(label_table, {"top", 0});
    hmput(label_table, {"bottom", 10});
    uint32_t inst = parse_immediate(line, label_table);
    printf("%08X", inst);
    line = "BNEZ R11 bottom";
    inst = parse_immediate(line, label_table);
    printf("%08X", inst);
    return(0);
}

