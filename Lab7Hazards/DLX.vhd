library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity DLX is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic
		);
						
	end entity DLX;	
					
	architecture Behavioral of DLX is     
		
		signal pc_decode : std_logic_vector(9 downto 0);
		signal pc_execute : std_logic_vector(9 downto 0);
		
		signal instruction_decode : std_logic_vector(31 downto 0);
		signal instruction_execute : std_logic_vector(31 downto 0);
		signal instruction_mem : std_logic_vector(31 downto 0);
		signal instruction_wb : std_logic_vector(31 downto 0);
		
		signal q_1 : std_logic_vector (31 DOWNTO 0) := (others=>'0');
      	signal q_2 : std_logic_vector(31 downto 0) := (others=>'0');
		signal q_2_mem : std_logic_vector(31 downto 0) := (others=>'0');
		
		signal imm_extended : std_logic_vector(31 downto 0);
		signal jump_addr_final : std_logic_vector(9 downto 0);
		signal branch_addr : std_logic_vector(9 downto 0);
      signal jump_addr : std_logic_vector(9 downto 0);
		signal take_jump : std_logic;
		signal sel_jump : std_logic;
		signal take_branch : std_logic;
		
		
		signal alu_result : std_logic_vector(31 downto 0);
		signal alu_result_wb : std_logic_vector(31 downto 0);
		
		signal ram_data : std_logic_vector(31 downto 0);
		signal reg_data : std_logic_vector (31 downto 0);
		
		signal wr_addr : std_logic_vector(4 downto 0 );

		--write enable signals
		signal reg_we : std_logic;
		signal ram_we : std_logic;
		signal stall : std_logic;
		
		--the flushes
		signal flush_fetch : std_logic;
		signal flush_decode : std_logic;
		signal flush_execute :std_logic;


	
	begin
	
	FETCH: entity work.fetch 
	port map
	(
		rst_l => rst_l,
		clk => clk,
      jump_addr => jump_addr_final,
      sel_jump => sel_jump,
		tag_for_flush => flush_fetch,
		stall => stall,
      pc => pc_decode,
      instruction => instruction_decode
	);

    DECODE: entity work.decode
	port map
	(
		rst_l => rst_l,
      clk => clk,
      data => reg_data,
      instruction_in => instruction_decode,
		instruction_out => instruction_execute,
		tag_for_flush => flush_decode,
		stall => stall,
		pc_in => pc_decode,
		pc_out => pc_execute,
		we => reg_we,
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
		instruction_in_wb => instruction_wb,
		alu_result_wb => alu_result_wb,
		tag_for_flush => flush_execute,
		stall => stall,
		instruction_out => instruction_mem,
		alu_result => alu_result,
		branch_addr => branch_addr,
		take_branch => take_branch,
		ram_we => ram_we,
		q_2_out => q_2_mem
	);
	MEMORY: entity work.memory
	port map
	(
		rst_l => rst_l,
		clk => clk,
		instruction_in => instruction_mem,
		instruction_out => instruction_wb,
		q_2 => q_2_mem,
		alu_result => alu_result,
		ram_we => ram_we,
		ram_data => ram_data,
		alu_result_wb => alu_result_wb
	);

	WB : entity work.write_back
	port map
	(
        instruction_wb => instruction_wb,
        ram_data => ram_data,
        alu_result_wb => alu_result_wb,
        wr_addr => wr_addr,
        reg_data => reg_data,
        reg_we => reg_we
	);
	
	
	OOO : entity work.OVERSEER 
    port map
    (
        clk => clk,

        instruction_decode => instruction_decode,
        instruction_execute => instruction_execute,
        instruction_wb => instruction_wb,

        take_branch => take_branch,

        flush_fetch => flush_fetch,
        flush_decode => flush_decode,
        flush_execute => flush_execute,

        take_jump => take_jump,
        jump_addr => jump_addr,

        stall => stall
    );
	 
	 
	 jump_addr_final <= branch_addr when take_jump = '0' else jump_addr;
	 sel_jump <= take_branch or take_jump;
	

				
	end Behavioral;