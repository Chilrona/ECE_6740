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
		    instruction_out : out std_logic_vector(31 downto 0);

            alu_result : out std_logic_vector(31 downto 0);
            jump_addr : out std_logic_vector(9 downto 0);
		    sel_jump : out std_logic;
            ram_we : out std_logic
		);
						
	end entity execute;	
					
	architecture Behavioral of execute is     
	
    signal op1 : std_logic_vector(31 downto 0):= (others => '0');
    signal op2 : std_logic_vector(31 downto 0) := (others => '0');

	begin
        
	MUX1 : entity work.PC_mux
    port map
    (
        opcode => instruction_in(31 downto 26),   
        pc => pc_in,
        q_1 => q_1,
        op1 => op1
    );

    MUX2 : entity work.imm_mux
    port map
    (
        opcode => instruction_in(31 downto 26), 
        imm_ex => imm_extended,
        q_2 => q_2,
        op2 => op2
    );
    
    ZEROS: entity work.zeros 
	port map
	(
		rst_l => rst_l,
		clk => clk,
        jump_addr =>jump_addr,
		sel_jump => sel_jump,
        q_1 => q_1,
        op2 => op2,
        instruction_execute => instruction_in
	);

	ALU: entity work.ALU
    port map
    (
        rst_l => rst_l,
        clk => clk,
        opcode => instruction_in(31 downto 26),
        op1 => op1,
        op2 => op2,
        alu_result => alu_result,
        ram_we => ram_we
    );
	 
	 pass_along: process(clk, rst_l)
	 begin
		if rst_l = '0' then
			instruction_out <= (others=>'0');
		elsif rising_edge(clk) then
			instruction_out <= instruction_in;
		end if;
	end process;
				
	end Behavioral;
	
						
						
						
						