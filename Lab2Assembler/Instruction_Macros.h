#include "stdio.h"
// OPCODES
#define NOP_OPCODE      0x00000000

#define LW_OPCODE       0x04000000
#define SW_OPCODE       0x08000000

#define ADD_OPCODE      0x0C000000
#define ADDI_OPCODE     0x10000000
#define ADDU_OPCODE     0x14000000
#define ADDUI_OPCODE    0x18000000

#define SUB_OPCODE      0x1C000000
#define SUBI_OPCODE     0x20000000
#define SUBU_OPCODE     0x24000000
#define SUBUI_OPCODE    0x28000000

#define AND_OPCODE      0x2C000000
#define ANDI_OPCODE     0x30000000

#define OR_OPCODE       0x34000000
#define ORI_OPCODE      0x38000000

#define XOR_OPCODE      0x3C000000
#define XORI_OPCODE     0x40000000

#define SLL_OPCODE      0x44000000
#define SLLI_OPCODE     0x48000000
#define SRL_OPCODE      0x4C000000
#define SRLI_OPCODE     0x50000000
#define SRA_OPCODE      0x54000000
#define SRAI_OPCODE     0x58000000

#define SLT_OPCODE      0x5C000000
#define SLTI_OPCODE     0x60000000
#define SLTU_OPCODE     0x64000000
#define SLTUI_OPCODE    0x68000000

#define SGT_OPCODE      0x6C000000
#define SGTI_OPCODE     0x70000000
#define SGTU_OPCODE     0x74000000
#define SGTUI_OPCODE    0x78000000

#define SLE_OPCODE      0x7C000000
#define SLEI_OPCODE     0x80000000
#define SLEU_OPCODE     0x84000000
#define SLEUI_OPCODE    0x88000000

#define SGE_OPCODE      0x8C000000
#define SGEI_OPCODE     0x90000000
#define SGEU_OPCODE     0x94000000
#define SGEUI_OPCODE    0x98000000

#define SEQ_OPCODE      0x9C000000
#define SEQI_OPCODE     0xA0000000
#define SNE_OPCODE      0xA4000000
#define SNEI_OPCODE     0xA8000000

#define BEQZ_OPCODE     0xAC000000
#define BNEZ_OPCODE     0xB0000000

#define J_OPCODE        0xB4000000
#define JR_OPCODE       0xB8000000
#define JAL_OPCODE      0xBC000000
#define JALR_OPCODE     0xC0000000

//Source Registers
#define R1_SOURCE 0x00010000
#define R2_SOURCE
#define R3_SOURCE
#define R4_SOURCE
#define R5_SOURCE
#define R6_SOURCE
#define R7_SOURCE
#define R8_SOURCE
#define R9_SOURCE
#define R10_SOURCE
#define R11_SOURCE
#define R12_SOURCE
#define R13_SOURCE
#define R14_SOURCE
#define R15_SOURCE
#define R16_SOURCE
#define R17_SOURCE
#define R18_SOURCE
#define R19_SOURCE
#define R20_SOURCE
#define R21_SOURCE
#define R22_SOURCE
#define R23_SOURCE
#define R24_SOURCE
#define R25_SOURCE
#define R26_SOURCE
#define R27_SOURCE
#define R28_SOURCE
#define R29_SOURCE
#define R30_SOURCE
#define R31_SOURCE

// Destination Registers
#define R1_DEST 0x00200000
#define R2_DEST
#define R3_DEST
#define R4_DEST
#define R5_DEST
#define R6_DEST
#define R7_DEST
#define R8_DEST
#define R9_DEST
#define R10_DEST
#define R11_DEST
#define R12_DEST
#define R13_DEST
#define R14_DEST
#define R15_DEST
#define R16_DEST
#define R17_DEST
#define R18_DEST
#define R19_DEST
#define R20_DEST
#define R21_DEST
#define R22_DEST
#define R23_DEST
#define R24_DEST
#define R25_DEST
#define R26_DEST
#define R27_DEST
#define R28_DEST
#define R29_DEST
#define R30_DEST
#define R31_DEST

//Field clear bits
#define RD_CLEAR
#define RS_CLEAR 0xFFE0FFFF