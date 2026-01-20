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

uint32_t parseREGISTER()
{
	uint32_t opcode, regOut, regPri, regSec, finalresult;
    string line = "ADD R3, R1, R2";

    auto instructions = parseInstructionLine(line);
	//opcode 
for (const auto& inst : instructions) 
    {
    auto it = opcodeTable.find(inst.opcode);
    if (it == opcodeTable.end()) {
        cerr << "Unknown opcode: " << inst.opcode << endl;
        continue;
    }

    opcode = it->second;
    //cout << "Opcode = 0x" << hex << opcode << endl;
    }

    //destination register
    for (const auto& inst : instructions) 
    {
    auto it = destRegTable.find(inst.regOut);
    if (it == destRegTable.end()) {
        cerr << "Unknown Destination Register: " << inst.regOut << endl;
        continue;
    }

    regOut = it->second;
    //cout << "Destination Register = 0x" << hex << regOut << endl;
    }

    //source 1 register
    for (const auto& inst : instructions) 
    {
    auto it = rs1Table.find(inst.regPri);
    if (it == rs1Table.end()) {
        cerr << "Unknown Destination Register: " << inst.regPri << endl;
        continue;
    }

    regPri = it->second;
    //cout << "Source 1 Register = 0x" << hex << regPri << endl;
    }
    //source 2 register
    for (const auto& inst : instructions) 
    {
    auto it = rs2Table.find(inst.regSec);
    if (it == rs2Table.end()) {
        cerr << "Unknown Destination Register: " << inst.regSec << endl;
        continue;
    }

    regSec = it->second;
    //cout << "Source 2 Register = 0x" << hex << regSec << endl;
    }

    //OR them together
    finalresult = opcode | regOut | regPri | regSec;
    cout << "0x" << hex << finalresult << endl;


/* just printing out the line piece by piece
    for (const auto& inst : instructions) {
        cout << opcode << " "
             << inst.regOut << " "
             << inst.regPri << " "
             << inst.regSec << endl;
    }
*/
    return finalresult;
}
