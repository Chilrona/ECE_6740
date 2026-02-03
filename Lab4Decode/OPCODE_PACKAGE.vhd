library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package opcode_package is
	----------------------------------------------------------------
	--types of signals
	----------------------------------------------------------------

	TYPE MEM IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(2 DOWNTO 0);

    ------------------------------------------------------------------
	--Constants for opcodes
	------------------------------------------------------------------

	-- No operation
    constant NOP   : unsigned(5 downto 0) := "000000"; -- 0x00

    -- Memory instructions
    constant LW    : unsigned(5 downto 0) := "000001"; -- 0x01
    constant SW    : unsigned(5 downto 0) := "000010"; -- 0x02

    -- Arithmetic (signed / unsigned)
    constant ADD   : unsigned(5 downto 0) := "000011"; -- 0x03
    constant ADDI  : unsigned(5 downto 0) := "000100"; -- 0x04
    constant ADDU  : unsigned(5 downto 0) := "000101"; -- 0x05
    constant ADDUI : unsigned(5 downto 0) := "000110"; -- 0x06

    constant SUB   : unsigned(5 downto 0) := "000111"; -- 0x07
    constant SUBI  : unsigned(5 downto 0) := "001000"; -- 0x08
    constant SUBU  : unsigned(5 downto 0) := "001001"; -- 0x09
    constant SUBUI : unsigned(5 downto 0) := "001010"; -- 0x0A

    -- Logical
    constant AND_OP  : unsigned(5 downto 0) := "001011"; -- 0x0B
    constant ANDI    : unsigned(5 downto 0) := "001100"; -- 0x0C
    constant OR_OP   : unsigned(5 downto 0) := "001101"; -- 0x0D
    constant ORI     : unsigned(5 downto 0) := "001110"; -- 0x0E
    constant XOR_OP  : unsigned(5 downto 0) := "001111"; -- 0x0F
    constant XORI    : unsigned(5 downto 0) := "010000"; -- 0x10

    -- Shifts
    constant SLL_OP  : unsigned(5 downto 0) := "010001"; -- 0x11
    constant SLLI    : unsigned(5 downto 0) := "010010"; -- 0x12
    constant SRL_OP  : unsigned(5 downto 0) := "010011"; -- 0x13
    constant SRLI    : unsigned(5 downto 0) := "010100"; -- 0x14
    constant SRA_OP  : unsigned(5 downto 0) := "010101"; -- 0x15
    constant SRAI    : unsigned(5 downto 0) := "010110"; -- 0x16

    -- Set / compare
    constant SLT   : unsigned(5 downto 0) := "010111"; -- 0x17
    constant SLTI  : unsigned(5 downto 0) := "011000"; -- 0x18
    constant SLTU  : unsigned(5 downto 0) := "011001"; -- 0x19
    constant SLTUI : unsigned(5 downto 0) := "011010"; -- 0x1A

    constant SGT   : unsigned(5 downto 0) := "011011"; -- 0x1B
    constant SGTI  : unsigned(5 downto 0) := "011100"; -- 0x1C
    constant SGTU  : unsigned(5 downto 0) := "011101"; -- 0x1D
    constant SGTUI : unsigned(5 downto 0) := "011110"; -- 0x1E

    constant SLE   : unsigned(5 downto 0) := "011111"; -- 0x1F
    constant SLEI  : unsigned(5 downto 0) := "100000"; -- 0x20
    constant SLEU  : unsigned(5 downto 0) := "100001"; -- 0x21
    constant SLEUI : unsigned(5 downto 0) := "100010"; -- 0x22

    constant SGE   : unsigned(5 downto 0) := "100011"; -- 0x23
    constant SGEI  : unsigned(5 downto 0) := "100100"; -- 0x24
    constant SGEU  : unsigned(5 downto 0) := "100101"; -- 0x25
    constant SGEUI : unsigned(5 downto 0) := "100110"; -- 0x26

    constant SEQ   : unsigned(5 downto 0) := "100111"; -- 0x27
    constant SEQI  : unsigned(5 downto 0) := "101000"; -- 0x28
    constant SNE   : unsigned(5 downto 0) := "101001"; -- 0x29
    constant SNEI  : unsigned(5 downto 0) := "101010"; -- 0x2A

    -- Branch / jump
    constant BEQZ  : unsigned(5 downto 0) := "101011"; -- 0x2B
    constant BNEZ  : unsigned(5 downto 0) := "101100"; -- 0x2C
    constant J     : unsigned(5 downto 0) := "101101"; -- 0x2D
    constant JR    : unsigned(5 downto 0) := "101110"; -- 0x2E
    constant JAL   : unsigned(5 downto 0) := "101111"; -- 0x2F
    constant JALR  : unsigned(5 downto 0) := "110000"; -- 0x30

    -------------------------------------------------------------
    -- Function declaration
    -------------------------------------------------------------
    function is_signed_imm(opcode : unsigned(5 downto 0)) return boolean;

end package opcode_package;

package body opcode_package is
    function is_signed_imm(opcode : unsigned(5 downto 0)) return boolean is
    begin
        return  (opcode = ADDI) or
                (opcode = SUBI) or
                (opcode = SRAI) or
                (opcode = SLTI) or
                (opcode = SGTI) or
                (opcode = SLEI) or
                (opcode = SGEI) or
                (opcode = SEQI);
    end function;
end package body opcode_package;
