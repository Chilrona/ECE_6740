library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity DLX_tb is
end DLX_tb;

architecture test of DLX_tb is

	constant CLK_PERIOD : time := 20 ns;
	
	--number of times we are multiplying in factorial.dxl
	constant n : integer := 3;
	signal clk_count : integer := 0;
	
	--Signals to connect to Lab3fetch
	signal rst_l : std_logic:= '0';
	signal clk : std_logic;
	signal pc : unsigned(9 downto 0):=(others=>'0');
	signal instruction : std_logic_vector(31 downto 0);

	--decode signals
	signal we : std_logic := '1';
	signal wr_data : std_logic_vector(31 downto 0) := X"01";

	signal q_1 : std_logic_vector (2 DOWNTO 0);
    signal q_2 : std_logic_vector(2 downto 0)
	
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
--	UUT : entity work.Lab3fetch
--		port map (
--			rst_l => rst_l,
--			clk =>clk,
--			jump_addr => jump_addr,
--			sel_jump => sel_jump,
--			pc => pc,
--			instruction => instruction
--	);
	

	UUT : entity work.DLX
		port map
		(
			rst_l => rst_l,
			clk =>clk,
			pc => pc,
			instruction => instruction
            --jump and branch ports
            jump_addr => jump_addr,
			sel_jump => sel_jump,

            --data memory ports
            data => wr_data,
			q_1 => q_1,
        	q_2 => q_2

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
			when 1=>
				we <= '1';
				wr_data <= X"03";
			when 2 => 
				we <= '0';
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