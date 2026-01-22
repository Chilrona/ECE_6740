#include <iostream>
#include <sstream>
#include <string>

#include <cstdint>

#include "mothership.h"

using namespace std;

struct Instruction 
{
    string opcode;
    string sec_param;
};

Instruction parseInstructionLine(const string& line)
{
    // Make a local copy so we can modify it
    string cleaned = line;

    istringstream iss(cleaned);

    Instruction inst;
    if (iss >> inst.opcode)
    {
        iss >> inst.sec_param;
        return inst;
    }

    cerr << "Invalid Instruction";
}

uint32_t parse_jump(char* line_ptr, Label* label_table)
{
    string line = line_ptr;
	uint32_t opcodeBits, addrBits, machineCode=0;

    Instruction inst = parseInstructionLine(line);
	
    // 1) opcode
    auto opIt = opcodeTable.find(inst.opcode);
    if (opIt == opcodeTable.end()) 
    {
        cerr << "Unknown opcode: " << inst.opcode << endl;
    }

    opcodeBits = opIt->second;

     // 2) 
    // if (inst.opcode == "J" || inst.opcode == "JAL")
    // {
    //     auto adIt = find_if(label_table, label_table + label_count, [&](const Label& e) {
    //         return strcmp(inst.sec_param.c_str(), e.key) == 0;
    //     });
    // }
    // else if (inst.opcode == "JR" || inst.opcode == "JALR")
    // {

    //}
 
    // 5) build final instruction word
    // ASSUMPTION: immediate is bits [15:0]
    // machineCode = opcodeBits | addrBits;
    // return machineCode;
}

