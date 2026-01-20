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
    string Immediate;
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
    if (iss >> inst.opcode >> inst.regOut >> inst.regPri >> inst.Immediate)
        result.push_back(inst);

    return result;
}

uint32_t encodeImm(const string& immStr) {
    int value = stoi(immStr);

    if (value < 0 || value > 0xFFFF) {
        throw std::out_of_range("Immediate out of range (0–65535)");
    }

    return static_cast<uint32_t>(value);
}


int main()
{
	uint32_t opcode, Rdest, RPri, immediate;
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

