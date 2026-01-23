#include "stdio.h"
#include "line_vec.h"
#include <cstdint>
#include <iostream>
#include "mnemonic.h"
#include "register.h"
#include "immediate.h"
#include "mothership.h"
#include "stb_ds.h"
#include <iostream>
#include <sstream>
#include <string>
#include <algorithm>  // required for std::
#include <cstdint>
#include "mothership.h"
#include <register.cpp>


int main()
{
    string line = "ADD R2 R6 R0";
    uint32_t instruction=0;
    instruction = parse_register(text_lines->items[i].text);

    fprintf(out_code, "%03X : %08X; --%s\n", text_lines->items[i].addr, instruction, text_lines->items[i].text);
}