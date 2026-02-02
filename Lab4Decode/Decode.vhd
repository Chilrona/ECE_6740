library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity decode is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic;
            data : in std_logic_vector (2 downto 0);
			instruction : inout std_logic_vector(31 downto 0);
            q_1 : inout std_logic_vector (2 DOWNTO 0);
            q_2 : inout std_logic_vector(2 downto 0)
		);
						
	end entity decode;	
					
	architecture Behavioral of decode is     
	
    --signal for write enable
    signal we : std_logic;
    
	begin
	
	SR: entity work.registers 
	port map
	(
		clk => clk,
        data => data,
        write_address => instruction(25 downto 21),
        read_address_1 => instruction(20 downto 16),
        read_address_2: instruction(15 downto 11),
        we => we,
        q_1 => q_1,
        q_2 => q_2
	);

    process(rst_l)
    begin 
        
    end process;
				
	end Behavioral;
	
						
						
						
						