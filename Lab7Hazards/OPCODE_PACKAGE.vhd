library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package opcode_package is
	----------------------------------------------------------------
	--types of signals
	----------------------------------------------------------------

	TYPE MEM IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

    ------------------------------------------------------------------
	--Constants for opcodes
	------------------------------------------------------------------

	-- No operation
    constant NOP   : std_logic_vector(5 downto 0) := "000000"; -- 0x00

    -- Memory instructions
    constant LW    : std_logic_vector(5 downto 0) := "000001"; -- 0x01
    constant SW    : std_logic_vector(5 downto 0) := "000010"; -- 0x02

    -- Arithmetic (signed / std_logic_vector)
    constant ADD   : std_logic_vector(5 downto 0) := "000011"; -- 0x03
    constant ADDI  : std_logic_vector(5 downto 0) := "000100"; -- 0x04
    constant ADDU  : std_logic_vector(5 downto 0) := "000101"; -- 0x05
    constant ADDUI : std_logic_vector(5 downto 0) := "000110"; -- 0x06

    constant SUB_OP   : std_logic_vector(5 downto 0) := "000111"; -- 0x07
    constant SUBI  : std_logic_vector(5 downto 0) := "001000"; -- 0x08
    constant SUBU  : std_logic_vector(5 downto 0) := "001001"; -- 0x09
    constant SUBUI : std_logic_vector(5 downto 0) := "001010"; -- 0x0A

    -- Logical
    constant AND_OP  : std_logic_vector(5 downto 0) := "001011"; -- 0x0B
    constant ANDI    : std_logic_vector(5 downto 0) := "001100"; -- 0x0C
    constant OR_OP   : std_logic_vector(5 downto 0) := "001101"; -- 0x0D
    constant ORI     : std_logic_vector(5 downto 0) := "001110"; -- 0x0E
    constant XOR_OP  : std_logic_vector(5 downto 0) := "001111"; -- 0x0F
    constant XORI    : std_logic_vector(5 downto 0) := "010000"; -- 0x10

    -- Shifts
    constant SLL_OP  : std_logic_vector(5 downto 0) := "010001"; -- 0x11
    constant SLLI    : std_logic_vector(5 downto 0) := "010010"; -- 0x12
    constant SRL_OP  : std_logic_vector(5 downto 0) := "010011"; -- 0x13
    constant SRLI    : std_logic_vector(5 downto 0) := "010100"; -- 0x14
    constant SRA_OP  : std_logic_vector(5 downto 0) := "010101"; -- 0x15
    constant SRAI    : std_logic_vector(5 downto 0) := "010110"; -- 0x16

    -- Set / compare
    constant SLT   : std_logic_vector(5 downto 0) := "010111"; -- 0x17
    constant SLTI  : std_logic_vector(5 downto 0) := "011000"; -- 0x18
    constant SLTU  : std_logic_vector(5 downto 0) := "011001"; -- 0x19
    constant SLTUI : std_logic_vector(5 downto 0) := "011010"; -- 0x1A

    constant SGT   : std_logic_vector(5 downto 0) := "011011"; -- 0x1B
    constant SGTI  : std_logic_vector(5 downto 0) := "011100"; -- 0x1C
    constant SGTU  : std_logic_vector(5 downto 0) := "011101"; -- 0x1D
    constant SGTUI : std_logic_vector(5 downto 0) := "011110"; -- 0x1E

    constant SLE   : std_logic_vector(5 downto 0) := "011111"; -- 0x1F
    constant SLEI  : std_logic_vector(5 downto 0) := "100000"; -- 0x20
    constant SLEU  : std_logic_vector(5 downto 0) := "100001"; -- 0x21
    constant SLEUI : std_logic_vector(5 downto 0) := "100010"; -- 0x22

    constant SGE   : std_logic_vector(5 downto 0) := "100011"; -- 0x23
    constant SGEI  : std_logic_vector(5 downto 0) := "100100"; -- 0x24
    constant SGEU  : std_logic_vector(5 downto 0) := "100101"; -- 0x25
    constant SGEUI : std_logic_vector(5 downto 0) := "100110"; -- 0x26

    constant SEQ   : std_logic_vector(5 downto 0) := "100111"; -- 0x27
    constant SEQI  : std_logic_vector(5 downto 0) := "101000"; -- 0x28
    constant SNE   : std_logic_vector(5 downto 0) := "101001"; -- 0x29
    constant SNEI  : std_logic_vector(5 downto 0) := "101010"; -- 0x2A

    -- Branch / jump
    constant BEQZ  : std_logic_vector(5 downto 0) := "101011"; -- 0x2B
    constant BNEZ  : std_logic_vector(5 downto 0) := "101100"; -- 0x2C
    constant J     : std_logic_vector(5 downto 0) := "101101"; -- 0x2D
    constant JR    : std_logic_vector(5 downto 0) := "101110"; -- 0x2E
    constant JAL   : std_logic_vector(5 downto 0) := "101111"; -- 0x2F
    constant JALR  : std_logic_vector(5 downto 0) := "110000"; -- 0x30

    -------------------------------------------------------------
    -- Function declaration
    -------------------------------------------------------------
    function is_signed_imm(opcode : std_logic_vector(5 downto 0)) return boolean;
    function is_imm(opcode : std_logic_vector(5 downto 0)) return boolean;
	function is_n_wb(opcode : std_logic_vector(5 downto 0)) return boolean;
    function is_not_data_hazard_1(opcode : std_logic_vector(5 downto 0)) return boolean;
    function is_register_register(opcode : std_logic_vector(5 downto 0)) return boolean;

end package opcode_package;

package body opcode_package is
    function is_signed_imm(opcode : std_logic_vector(5 downto 0)) return boolean is
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

    function is_imm(opcode : std_logic_vector(5 downto 0)) return boolean is
    begin
        return  (opcode = ADDI)  or
                (opcode = ADDUI) or
                (opcode = SUBI)  or
                (opcode = SUBUI) or
                (opcode = ANDI)  or
                (opcode = ORI)   or
                (opcode = XORI)  or
                (opcode = SLLI)  or
                (opcode = SRLI)  or
                (opcode = SRAI)  or
                (opcode = SLTI)  or
                (opcode = SLTUI) or
                (opcode = SGTI)  or
                (opcode = SGTUI) or
                (opcode = SLEI)  or
                (opcode = SLEUI) or
                (opcode = SGEI)  or
                (opcode = SGEUI) or
                (opcode = SEQI)  or
                (opcode = SNEI)  or 
                (opcode = BEQZ)  or
                (opcode = BNEZ)  or
                (opcode = J)     or
                (opcode = JAL)   or
                (opcode = LW)    or
                (opcode = SW);
    end function;
	 
	function is_n_wb(opcode : std_logic_vector(5 downto 0)) return boolean is
    begin
        return  (opcode = SW)   or
                (opcode = NOP)  or
                (opcode = BEQZ) or
                (opcode = BNEZ) or
                (opcode = J)    or
                (opcode = JR);
    end function;

    --Is not included in the first data hazard opcode types
    function is_not_data_hazard_1(opcode : std_logic_vector(5 downto 0)) return boolean is
    begin
        return  (opcode = NOP)   or
                (opcode = J)  or
                (opcode = JR) or
                (opcode = JAL) or
                (opcode = JALR);
    end function;

    --Is included in the second data hazard opcode types
    function is_register_register(opcode : std_logic_vector(5 downto 0)) return boolean is
    begin
        return  (opcode = ADD)   or
                (opcode = ADDU)  or
                (opcode = SUB_OP) or
                (opcode = SUBU) or
                (opcode = AND_OP) or
                (opcode = OR_OP) or
                (opcode = XOR_OP) or
                (opcode = SLL_OP) or
                (opcode = SRL_OP) or
                (opcode = SRA_OP) or
                (opcode = SLT) or
                (opcode = SLTU) or
                (opcode = SGT) or
                (opcode = SGTU) or
                (opcode = SLE) or
                (opcode = SLEU) or
                (opcode = SGE) or
                (opcode = SGEU) or
                (opcode = SEQ) or
                (opcode = SNE);
    end function;
    
	 
end package body opcode_package;
