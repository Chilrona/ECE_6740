#include <iostream>
#include <sstream>
#include <string>
#include <algorithm>  // required for std::
#include <cstdint>
#include "mothership.h"

using namespace std;

struct Instruction_Register {
    string opcode;
    string regOut;
    string regPri;
    string regSec;
};

Instruction_Register parseInstructionLine1(const string& line)
{
     Instruction_Register inst;
    string cleaned = line;

    cleaned.erase(remove(cleaned.begin(), cleaned.end(), ','), cleaned.end());

    istringstream iss(cleaned);
    iss >> inst.opcode >> inst.regOut >> inst.regPri >> inst.regSec;

    return inst;
}
// Added a pointer to the beginning of the line. -Jackson
uint32_t parseREGISTER(char* line_ptr)
{
	uint32_t opcode, regOut, regPri, regSec, finalresult;
    string line = line_ptr; // This is how you convert from C style strings
                            // to C++ style strings. -Jackson

    Instruction_Register inst = parseInstructionLine1(line);

    
    auto it = opcodeTable.find(inst.opcode);
    opcode = it->second;
    if (inst.opcode == "NOP")
	{
		return 0;
	}

    it = destRegTable.find(inst.regOut);
    regOut = it->second;

    it = rs1Table.find(inst.regPri);
    regPri = it->second;

    it = rs2Table.find(inst.regSec);
    regSec = it->second;

	
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
