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
			instruction : in std_logic_vector(31 downto 0);
         q_1 : out std_logic_vector (31 DOWNTO 0);
         q_2 : out std_logic_vector(31 downto 0);
			imm_extended : out unsigned(31 downto 0)
		);
						
	end entity decode;	
					
	architecture Behavioral of decode is     
	    
	begin
	
	R: entity work.registers 
	port map
	(
		clk => clk,
        data => data,
        write_address => instruction(25 downto 21),
        read_address_1 => instruction(20 downto 16),
        read_address_2 => instruction(15 downto 11),
        we => we,
        q_1 => q_1,
        q_2 => q_2
	);

	SE: entity work.sign_extend
    port map
    (
        rst_l => rst_l,
        clk => clk,
        opcode => instruction(31 downto 26),
        imm => unsigned(instruction(15 downto 0)),
        imm_extended => imm_extended
    );
				
	end Behavioral;
	
						
						
						
						