library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity DLX_lab6_tb is
end DLX_lab6_tb;

architecture test of DLX_lab6_tb is

	constant CLK_PERIOD : time := 20 ns;
	
	--Signals to connect to Lab3fetch
	signal rst_l : std_logic:= '0';
	signal clk : std_logic;

	begin

	-- Instantiate the Unit Under Test (UUT)

	UUT : entity work.DLX
		port map
		(
			rst_l => rst_l,
			clk =>clk

		);


	clk_process : process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process;
	
        rst_l <= '1' after 1 ps;
	
	
end test;	