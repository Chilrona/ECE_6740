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

	--decode signals
	signal we : std_logic := '1';
	signal wr_data : std_logic_vector(31 downto 0) := X"00000001";
	
	--Select Jump stages
	signal sel_jump : std_logic:= '0';
	
	--Jump addresses
	--signal jump_addr : unsigned(9 downto 0):=(others=>'0');
	--signal link_addr : unsigned(9 downto 0):=(others=>'0');
	
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
         --jump and branch ports
         --jump_addr => jump_addr,
			--sel_jump => sel_jump,

         --data memory ports
         data => wr_data,
			we => we

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
			when 0 =>
				we <= '1';
				wr_data <= X"00000001";
				sel_jump <= '0';
				jump_addr <= (others=>'0');

			when 1 =>
				we <= '1';
				wr_data <= X"00000004";
				sel_jump <= '0';
				jump_addr <= (others=>'0');

			when 2 =>
				we <= '1';
				wr_data <= X"00000003";
				sel_jump <= '0';
				jump_addr <= (others=>'0');

    when 3 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 4 =>
        we <= '1';
        wr_data <= X"00000001";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 5 =>
        we <= '1';
        wr_data <= X"00000003";
        sel_jump <= '1';
        jump_addr <= "0000001001";

    when 6 =>
        we <= '1';
        wr_data <= X"00000001";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 7 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 8 =>
        we <= '1';
        wr_data <= X"00000002";
        sel_jump <= '1';
        jump_addr <= "0000001001";

    when 9 =>
        we <= '1';
        wr_data <= X"00000002";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 10 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 11 =>
        we <= '1';
        wr_data <= X"00000003";
        sel_jump <= '1';
        jump_addr <= "0000001001";

    when 12 =>
        we <= '1';
        wr_data <= X"00000001";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 13 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 14 =>
        we <= '1';
        wr_data <= X"00000004";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 15 =>
        we <= '1';
        wr_data <= X"00000000";
        sel_jump <= '1';
        jump_addr <= "0000000111";

    when 16 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 17 =>
        we <= '1';
        wr_data <= X"00000002";
        sel_jump <= '1';
        jump_addr <= "0000000010";

    when 18 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 19 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 20 =>
        we <= '1';
        wr_data <= X"00000004";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 21 =>
        we <= '1';
        wr_data <= X"00000002";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 22 =>
        we <= '1';
        wr_data <= X"00000004";
        sel_jump <= '1';
        jump_addr <= "0000001001";

    when 23 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 24 =>
        we <= '1';
        wr_data <= X"00000008";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 25 =>
        we <= '1';
        wr_data <= X"00000001";
        sel_jump <= '1';
        jump_addr <= "0000001001";

    when 26 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 27 =>
        we <= '1';
        wr_data <= X"0000000C";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 28 =>
        we <= '1';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 29 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '1';
        jump_addr <= "0000000111";

    when 30 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 31 =>
        we <= '1';
        wr_data <= X"00000001";
        sel_jump <= '1';
        jump_addr <= "0000000010";

    when 32 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 33 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 34 =>
        we <= '1';
        wr_data <= X"0000000C";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 35 =>
        we <= '1';
        wr_data <= X"00000001";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 36 =>
        we <= '1';
        wr_data <= X"0000000C";
        sel_jump <= '1';
        jump_addr <= "0000001001";

    when 37 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 38 =>
        we <= '1';
        wr_data <= X"00000018";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 39 =>
        we <= '1';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 40 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '1';
        jump_addr <= "0000000111";

    when 41 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 42 =>
        we <= '1';
        wr_data <= X"00000000";
        sel_jump <= '1';
        jump_addr <= "0000000010";

    when 43 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '1';
        jump_addr <= "0000001101";

    when 44 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when 45 =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');

    when others =>
        we <= '0';
        wr_data <= X"00000000";
        sel_jump <= '0';
        jump_addr <= (others=>'0');
end case;

	end if;
	end process;
	
	
end test;	