library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity DLX is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic;

         --data memory ports
         	data : in std_logic_vector (31 downto 0);
			we : in std_logic

		);
						
	end entity DLX;	
					
	architecture Behavioral of DLX is     
		
		signal pc : unsigned(9 downto 0);
		signal instruction : std_logic_vector(31 downto 0);
		signal q_1 : std_logic_vector (31 DOWNTO 0) := (others=>'0');
      	signal q_2 : std_logic_vector(31 downto 0) := (others=>'0');
		signal imm_extended : unsigned(31 downto 0);
        signal jump_addr : unsigned(9 downto 0);
		signal sel_jump : std_logic;
		signal alu_result : std_logic_vector(31 downto 0);
	
	begin
	
	FETCH: entity work.fetch 
	port map
	(
		rst_l => rst_l,
        clk => clk,
        jump_addr => jump_addr,
        sel_jump => sel_jump,
        pc => pc,
        instruction => instruction
	);

    DECODE: entity work.decode
	port map
	(
		rst_l => rst_l,
        clk => clk,
        data => data,
        instruction => instruction,
		we => we,
        q_1 => q_1,
        q_2 => q_2,
		imm_extended => imm_extended
	);

	EXECUTE: entity work.execute
	port map
	(
		rst_l => rst_l,
		clk => clk,
		q_1 => q_1,
		q_2 => q_2,
		imm_extended => imm_extended,
		pc_execute => pc,
		instruction_execute => instruction;
		alu_result => alu_result,
		jump_addr => jump_addr,
		sel_jump => sel_jump
	)
				
	end Behavioral;