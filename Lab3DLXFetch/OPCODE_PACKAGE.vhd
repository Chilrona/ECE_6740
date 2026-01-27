library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package opcode_package is
	--jump instructions
	constant BEQZ : unsigned(5 downto 0) := x"2B"
	constant BNEZ : unsigned(5 downto 0) := x"2C"
	constant J : unsigned(5 downto 0) := x"2D"
	constant JR : unsigned(5 downto 0) := x"2E"
	constant JAL : unsigned(5 downto 0) := x"2F"
	constant JALR : unsigned(5 downto 0) := x"30"
	
end package opcode_package;