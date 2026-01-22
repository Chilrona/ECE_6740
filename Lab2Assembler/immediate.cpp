#include <iostream>
#include <sstream>
#include <string>

#include "stb_ds.h"

#include "mothership.h"


using namespace std;

struct Instruction 
{
    string opcode;
    string regOut;
    string regPri;
    string immStr;
};

uint32_t parse_immediate(char* line_ptr, Label* label_table)
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
        abort();
    }

    opcodeBits = opIt->second;

    // 2) rd (dest)
    auto rdIt = destRegTable.find(inst.regOut);
    if (rdIt == destRegTable.end())
    {
        cerr << "Unknown opcode: " << inst.regOut << endl;
        abort();
    }

    regOutBits = rdIt->second;

    //3) rs1 (primary)
    auto rs1It = rs1Table.find(inst.regPri);
    if (rs1It == rs1Table.end())
    {
        cerr << "Unknown primary register: " << inst.regPri << endl;
        abort();
    }

    regPriBits = rs1It->second;

    // 4) immediate
    if (!(iss >> inst.immStr))
    {
        immBits = shget(label_table, inst.regPri.c_str());
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
            abort();
        }
    }
    
    
    // 5) build final instruction word
    // ASSUMPTION: immediate is bits [15:0]
    machineCode = opcodeBits | regOutBits | regPriBits | immBits;

    return machineCode;
}

