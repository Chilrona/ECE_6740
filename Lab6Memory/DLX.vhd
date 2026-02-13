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
			we : in std_logic;
			wr_addr : in std_logic_vector(4 downto 0 )

		);
						
	end entity DLX;	
					
	architecture Behavioral of DLX is     
		
		signal pc_decode : std_logic_vector(9 downto 0);
		signal pc_execute : std_logic_vector(9 downto 0);
		
		signal instruction_decode : std_logic_vector(31 downto 0);
		signal instruction_execute : std_logic_vector(31 downto 0);
		signal instruction_mem : std_logic_vector(31 downto 0);
		
		signal q_1 : std_logic_vector (31 DOWNTO 0) := (others=>'0');
      signal q_2 : std_logic_vector(31 downto 0) := (others=>'0');
		
		signal imm_extended : std_logic_vector(31 downto 0);
      signal jump_addr : std_logic_vector(9 downto 0);
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
        pc => pc_decode,
        instruction => instruction_decode
	);

    DECODE: entity work.decode
	port map
	(
		rst_l => rst_l,
      clk => clk,
      data => data,
      instruction_in => instruction_decode,
		instruction_out => instruction_execute,
		pc_in => pc_decode,
		pc_out => pc_execute,
		we => we,
		wr_addr => wr_addr,
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
		pc_in => pc_execute,
		instruction_in => instruction_execute,
		instruction_out => instruction_mem,
		alu_result => alu_result,
		jump_addr => jump_addr,
		sel_jump => sel_jump
	);
				
	end Behavioral;