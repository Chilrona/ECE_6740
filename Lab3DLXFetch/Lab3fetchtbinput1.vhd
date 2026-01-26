library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Lab3fetchtbinput1 is
end Lab3fetchtbinput1;

architecture test of Lab3fetchtbinput1 is

	signal rst_l : std_logic;
	signal clk : std_logic;
	signal jump_addr : unsigned(31 downto 0);
	signal sel_jump std_logic;
	signal pc unsigned(31 downto 0);
	signal instruction unsigned(31 downto 0);
	
	
	constant CLK_PERIOD : time := 10 ns;--check clock requirements Dr Phillips has
	
	begin

	-- Instantiate the Unit Under Test (UUT)
	UUT : entity work.Lab3fetch
		port map (
			rst_l => rst_l,
			clk =>clk,
			jump_addr => jump_addr,
			sel_jump => sel_jump,
			pc => pc,
			instruction => instruction
	);
	
	clk_process : process
	begin
		MAX10_CLK1_50 <= '0';
		wait for CLK_PERIOD/2;
		MAX10_CLK1_50 <= '1';
		wait for CLK_PERIOD/2;
	end process;
	
	process
	begin
	--address 000 to 003
		jump_addr <= '0'; 
		sel_jump <= '0';
		wait for CLK_PERIOD *4
		
	--address 004
		jump_addr <= A;
		sel_jump <= '0';
		wait for CLK_PERIOD
	
	--address 005 to 008
		jump_addr <= '0';
		sel_jump <= '0';
		wait for CLK_PERIOD * 3
		
	--address 009
		jump_addr <= 3;
		sel_jump <= '1';
		wait for CLK_PERIOD
		
	--address 00A
		jump_addr <= 0;
		sel_jump <= '0';
		wait for CLK_PERIOD
		
	--address 00B
		jump_addr <= B
		sel_jump <= '1';
		wait for CLK_PERIOD
	
		wait;

	
	
	
		--KEY(0) <= '0';
		--wait for CLK_PERIOD * 60;
		
		--KEY(0) <= '1';
		--wait for CLK_PERIOD * 9;
		
		--KEY(1) <= '0';
		--wait for CLK_PERIOD * 600;
		
		--KEY(1) <= '1';
		--wait for CLK_PERIOD  * 900;
		
		--KEY(1) <= '0';
		--wait for CLK_PERIOD  * 90000;
		
		--KEY(0) <= '0';
		--wait for CLK_PERIOD * 900;
		
		--KEY(0) <= '1';
		wait ;
		
	end process;
end test;	