library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity decode is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic;
        	data : in std_logic_vector (31 downto 0);
			we : in std_logic;
			wr_addr : in std_logic_vector(4 downto 0);

			instruction_in : in std_logic_vector(31 downto 0);
			instruction_out : out std_logic_vector(31 downto 0) := (others=>'0') ;
			
			tag_for_flush : in std_logic;
			stall : in std_logic;

			pc_in : in std_logic_vector(9 downto 0);
			pc_out : out std_logic_vector(9 downto 0) := (others=>'0');

        	q_1 : out std_logic_vector (31 DOWNTO 0);
        	q_2 : out std_logic_vector(31 downto 0);
			imm_extended : out std_logic_vector(31 downto 0)
		);
						
	end entity decode;	
					
	architecture Behavioral of decode is     
	    
		signal instruction_in_ : std_logic_vector(31 downto 0);

	begin
	
	instruction_in_ <= (others=>'0') when tag_for_flush = '1' else instruction_in;

	R: entity work.registers 
	port map
	(
		clk => clk,
        data => data,
        write_address => wr_addr,
        read_address_1 => instruction_in_(20 downto 16),
        read_address_2 => instruction_in_(15 downto 11),
        we => we,
        q_1 => q_1,
        q_2 => q_2
	);

	SE: entity work.sign_extend
    port map
    (
        rst_l => rst_l,
        clk => clk,
        opcode => instruction_in_(31 downto 26),
        imm => instruction_in_(15 downto 0),
        imm_extended => imm_extended
    );

	pass_along: process (clk)
	begin
		if rising_edge(clk) then
			if stall = '0' then
				instruction_out <= instruction_in_;
				pc_out <= pc_in;
			else
				instruction_out <= instruction_out;
				pc_out <= pc_out;
		end if;
	end process;
				
	end Behavioral;
	
						
						
						
						