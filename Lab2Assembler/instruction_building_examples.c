#define ADDI_OPCODE 0x10000000
#define R1_SOURCE 0x00010000
#define R1_DEST 0x00200000
#define RD_CLEAR
#define RS_CLEAR 0xFFE0FFFF

// Here are s ome examples if using masking to
// build an instruction.
uint32_t instruction = 0;
source_reg = R0;
dest_reg = R1;
if op_word == ADDI
{
    instruction = (instruction & 0x03FFFFFF) | ADDI_OPCODE;

}
instruction = (instruction & RS_CLEAR) | source_reg;

union 
{
    uint32_t full;
    struct
    {
        uint16_t immediate : 16;
        uint8_t rs1 : 5;
        uint8_t rd : 5;
        uint8_t opcode : 6;
    } fields;
} imm_instruction;

// This instruction adds the value in R2 to 0x1234
// and stores it in R1.
imm_instruction inst = {0};
inst.fields.opcode = 0x04;
inst.fields.rd = 1;
inst.fields.rs1 = 2;
inst.fields.immediate = 0x1234;