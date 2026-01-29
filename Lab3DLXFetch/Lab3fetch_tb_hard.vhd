library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity Lab3fetch_tb is
end Lab3fetch_tb;

architecture test of Lab3fetch_tb is

	constant CLK_PERIOD : time := 20 ns;
	
	--number of times we are multiplying in factorial.dxl
	constant n : integer := 3;
	
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
	signal BEQZ_count : integer := n;
	signal BNEZ_count : integer := 8;
	
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
	
	opcode <= unsigned(instruction(31 downto 26));
	
	process(clk)
	begin 
	if rising_edge(clk) then
		--sel_jump_stg2 <= sel_jump_stg1;
		--sel_jump_stg1 <= sel_jump;
		
		--Checking for Jump instruction and seting flag based on that instruction
		if (opcode = J) or (opcode =JAL) or (opcode = JR) or (opcode = JALR) then
			sel_jump <= '1';
		elsif not(opcode = BNEZ) or not(opcode = BEQZ) then
			sel_jump <= '0';
		end if;
		
		-- jumping to the instruction
		if (opcode = J) or (opcode = JAL) then
			jump_addr <= unsigned(instruction(9 downto 0));
		end if;
		
		--setting the link address
		if (opcode = JAL) or (opcode = JALR) then
			link_addr <= pc;
		end if;
		
		--going to the address in the register
		if (opcode = JR) or (opcode = JALR) then
			jump_addr <= link_addr;
		end if;
		
		--checking for if the Branch is equal to 0
		if opcode = BEQZ then
			if BEQZ_count = 0 then
				sel_jump <= '1';
				jump_addr <= unsigned(instruction(9 downto 0));
			else
				BEQZ_count <= BEQZ_count - 1;
				sel_jump <= '0';
			end if;
		end if;
		
		--checking for if the branch is not equal to 0
		if opcode = BNEZ then
			sel_jump <= BNEZ_events(BNEZ_count);
			jump_addr <= unsigned(instruction(9 downto 0));
			BNEZ_count <= BNEZ_count - 1;
		end if;

	end if;
	
	end process;
end test;	