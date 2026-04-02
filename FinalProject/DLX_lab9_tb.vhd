library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity DLX_lab9_tb is
end DLX_lab9_tb;

architecture test of DLX_lab9_tb is

	constant CLK_PERIOD : time := 20 ns;
	
	--Signals to connect to UUT
	signal rst_l : std_logic:= '0'; 
	signal KEY : std_logic_vector(1 downto 0);
	signal clk : std_logic;
	signal GPIO : std_logic_vector(35 downto 0);
	signal open_clk : std_logic;
	signal open_clk2 : std_logic;
	signal clk_count : integer :=0;
	constant test_char : std_logic_vector(19 downto 0) := "10000110101001101100";		--1 0000 1101 01 0011 0110 0
	signal rx : std_logic := '1';

	begin

	-- Instantiate the Unit Under Test (UUT)
		
		UUT : entity work.DLX
		port  map
		(
			KEY => KEY,
			ADC_CLK_10 => open_clk,
			MAX10_CLK1_50 => clk,
			MAX10_CLK2_50 => open_clk2,
			GPIO => GPIO
		);

	KEY(0) <= rst_l;
	
	--GPIO(0) <= '1';
	GPIO(0) <= rx;

	clk_process : process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process;
	
        rst_l <= '1' after 1 ps;
		  
	process(clk)
	begin
		if rising_edge(clk) then
			clk_count <= clk_count + 1;
			
			if clk_count >= 120 and clk_count < 140 then
				rx <= test_char(clk_count - 120);
			else
				rx <= '1';
			end if;
			
		end if;
	end process;
	
	
end test;	