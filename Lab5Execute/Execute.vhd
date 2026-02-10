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
            pc_execute : in std_logic_vector(9 downto 0);
            instruction_execute : in std_logic_vector(31 downto 0);

            ram_addr : out std_logic_vector(31 downto 0);
            ram_data : out std_logic_vector(31 downto 0);
            instruction_mem : out std_logic_vector(31 downto 0);
            jump_addr : out unsigned(9 downto 0);
		    sel_jump : out std_logic
		);
						
	end entity execute;	
					
	architecture Behavioral of execute is     
	
    signal op_1 : std_logic_vector(31 downto 0):= (others => '0');
    signal op_2 : std_logic_vector(31 downto 0) := (others => '0');
    signal alu_result : std_logic_vector(31 downto 0) := (others => '0');

	begin
	
	MUX1 : entity work.PC_mux
    port map
    (
        opcode => instruction_execute(31 downto 26),   
        pc => pc_execute,
        q_1 => q_1,
        op_1 => op_1
    );

    MUX2 : entity work.imm_mux
    port map
    (
        opcode => instruction_execute(31 downto 26), 
        imm_ex => imm_extended,
        q_2 => q_2,
        op_2 => op_2
    );
    
    ZEROS: entity work.zeros 
	port map
	(
		rst_l => rst_l,
		clk => clk,
        jump_addr =>jump_addr,
		sel_jump => sel_jump,
        q_1 => q_1,
        op_2 => op_2,
        instruction_execute => instruction_execute
	);

	EXECUTE: entity work.sign_extend
    port map
    (
        rst_l => rst_l,
        clk => clk,
        opcode => instruction_execute(31 downto 26),
        op_1 => op_1,
        op_2 => op_2,
        alu_result => alu_result
    );
				
	end Behavioral;
	
						
						
						
						