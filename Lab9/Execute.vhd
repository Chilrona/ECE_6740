library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity execute is
		port 
		(
            rst_l : in std_logic;
            clk : in std_logic;
            q_1 : in std_logic_vector (31 downto 0);
            q_2 : in std_logic_vector(31 downto 0);
            imm_extended : in std_logic_vector(31 downto 0);
			 
            pc_in : in std_logic_vector(9 downto 0);
			 
            instruction_in : in std_logic_vector(31 downto 0);
            instruction_in_wb : in std_logic_vector(31 downto 0);
            reg_data : in std_logic_vector(31 downto 0);
            tag_for_flush : in std_logic;

			instruction_out : buffer std_logic_vector(31 downto 0) := (others=>'0');
            alu_result : buffer std_logic_vector(31 downto 0);
            branch_addr : out std_logic_vector(9 downto 0);
			take_branch : out std_logic;
            ram_we : out std_logic;
            q_2_out : out std_logic_vector(31 downto 0);
				op1_out : out std_logic_vector(31 downto 0) := (others=>'0')
		);
						
	end entity execute;	
					
	architecture Behavioral of execute is     
	
    signal op1 : std_logic_vector(31 downto 0) := (others => '0');
	 signal op2 : std_logic_vector(31 downto 0) := (others => '0');
	 signal instruction_in_1 : std_logic_vector(31 downto 0);


	begin
	
	instruction_in_1 <= (others=>'0') when (tag_for_flush = '1') else instruction_in;
	
        
	MUX1 : entity work.PC_mux
    port map
    (
		  opcode_exe => instruction_in_1(31 downto 26),
		  opcode_mem => instruction_out(31 downto 26),
		  opcode_wb => instruction_in_wb(31 downto 26),
        rd_mem => instruction_out(25 downto 21),
        rd_wb => instruction_in_wb(25 downto 21),
        RS1 => instruction_in_1(20 downto 16), 
        reg_data => reg_data,
        alu_result => alu_result,
        pc => pc_in,
        q_1 => q_1,
        op1 => op1
    );
	 

    MUX2 : entity work.imm_mux
    port map
    (
        opcode_exe => instruction_in_1(31 downto 26),
		  opcode_mem => instruction_out(31 downto 26),
		  opcode_wb => instruction_in_wb(31 downto 26), 
        rd_mem => instruction_out(25 downto 21),
        rd_wb => instruction_in_wb(25 downto 21),
        RS2 => instruction_in_1(15 downto 11),
        reg_data => reg_data,
        alu_result => alu_result,
        imm_ex => imm_extended,
        q_2 => q_2,
        op2 => op2
    );
    
    ZEROS: entity work.zeros 
	port map
	(
			rst_l => rst_l,
			clk => clk,
			jump_addr =>branch_addr,
			sel_jump => take_branch,
			op1 => op1,
			op2 => op2,
			instruction_execute => instruction_in_1
	);

	ALU: entity work.ALU
    port map
    (
        rst_l => rst_l,
        clk => clk,
        opcode => instruction_in_1(31 downto 26),
        op1 => op1,
        op2 => op2,
        alu_result => alu_result,
        ram_we => ram_we
    );
	 
	 pass_along: process(clk, rst_l)
	 begin
		if rst_l = '0' then
			instruction_out <= (others=>'0');
            q_2_out <= (others=>'0');
				op1_out <= (others=>'0');
		elsif rising_edge(clk) then
				instruction_out <= instruction_in_1;
				op1_out <= op1;
            q_2_out <= q_2;
		end if;
	end process;
	end Behavioral;
	
						
						
						
						