library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity fetch_tb is
end fetch_tb;

architecture test of fetch_tb is

	constant CLK_PERIOD : time := 20 ns;
	
	--number of times we are multiplying in factorial.dxl
	constant n : integer := 3;
	signal clk_count : integer := 0;
	
	--Signals to connect to Lab3fetch
	signal rst_l : std_logic:= '0';
	signal clk : std_logic;
	signal pc : unsigned(9 downto 0):=(others=>'0');
	signal instruction : std_logic_vector(31 downto 0);
	
	--Select Jump stages
	signal sel_jump : std_logic:= '0';
	
	--Jump addresses
	signal jump_addr : unsigned(9 downto 0):=(others=>'0');
	signal link_addr : unsigned(9 downto 0):=(others=>'0');
	
	--instruction[31,26]
	signal opcode : unsigned(5 downto 0):=(others=>'0');
	
	--counter for the outer loop of factorial
	signal BEQZ_count : integer := 0;
	signal BNEZ_count : integer := 0;
	
	--counter for the multiplying in factorial
	signal BNEZ_events : unsigned(8 downto 0) := "111011010";
	
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
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process;
	
	
	rst_l <= '1' after 1 ps;
	
	process (clk)
	begin
	if rising_edge(clk) then
		clk_count <= clk_count +1;
		
		case clk_count is
			when 5 =>
				sel_jump <= '1';
				jump_addr <= "0000001001";
			when 8 =>
				sel_jump <= '1';
				jump_addr <= "0000001001";
			when 11 =>
				sel_jump <= '1';
				jump_addr <= "0000001001";
			when 15 =>
				sel_jump <= '1';
				jump_addr <= "0000000111";
			when 17 =>
				sel_jump <= '1';
				jump_addr <= "0000000010";
			when 22=>
				sel_jump <= '1';
				jump_addr <= "0000001001";
			when 25 =>
				sel_jump <= '1';
				jump_addr <= "0000001001";
			when 29 =>
				sel_jump <= '1';
				jump_addr <= "0000000111";
			when 31 =>
				sel_jump <= '1';
				jump_addr <= "0000000010";
			when 36 =>
				sel_jump <= '1';
				jump_addr <= "0000001001";
			when 40 =>
				sel_jump <= '1';
				jump_addr <= "0000000111";
			when 42 =>
				sel_jump <= '1';
				jump_addr <= "0000000010";
			when 43 =>
				sel_jump <= '1';
				jump_addr <= "0000001101";
			when others =>
				sel_jump <= '0';
				jump_addr <= (others=>'0');
		
		end case;

	end if;
	end process;
	
	
end test;	