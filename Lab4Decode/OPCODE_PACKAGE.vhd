library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package opcode_package is
	TYPE MEM IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(2 DOWNTO 0);
	--jump instructions
	constant BEQZ : unsigned(5 downto 0) := "101011";--2B
	constant BNEZ : unsigned(5 downto 0) := "101100";--2C
	constant J : unsigned(5 downto 0) := "101101";--2D
	constant JR : unsigned(5 downto 0) := "101110";--2E
	constant JAL : unsigned(5 downto 0) := "101111";--2F
	constant JALR : unsigned(5 downto 0) := "110000";--30
	
end package opcode_package;