#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <algorithm>  // required for std::

#ifndef MOTHERSHIP_H
#define MOTHERSHIP_H

#include "mothership.h"

#endif




using namespace std;

struct Instruction {
    string opcode;
    string regOut;
    string regPri;
    string regSec;
};

vector<Instruction> parseInstructionLine(const string& line)
{
    // Make a local copy so we can modify it
    string cleaned = line;

    // Remove commas from the line
    cleaned.erase(std::remove(cleaned.begin(), cleaned.end(), ','), cleaned.end());

    istringstream iss(cleaned);
    vector<Instruction> result;

    Instruction inst;
    if (iss >> inst.opcode >> inst.regOut >> inst.regPri >> inst.regSec)
        result.push_back(inst);

    return result;
}

int main()
{
	uint32_t opcode, Rdest, RPri, RSec;
    string line = "ADD R3, R1, R2";

    auto instructions = parseInstructionLine(line);
	
for (const auto& inst : instructions) {
    auto it = opcodeTable.find(inst.opcode);
    if (it == opcodeTable.end()) {
        cerr << "Unknown opcode: " << inst.opcode << endl;
        continue;
    }

    opcode = it->second;
    cout << "Opcode = 0x" << hex << opcode << endl;
}



    for (const auto& inst : instructions) {
        cout << opcode << " "
             << inst.regOut << " "
             << inst.regPri << " "
             << inst.regSec << endl;
    }

    return 0;
}
