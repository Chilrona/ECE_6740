library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity ALU is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic;
            opcode : in std_logic_vector(5 downto 0)
			op_1 : in std_logic_vector (31 downto 0)
            op_2 : in std_logic_vector (31 downto 0)
            alu_result : out std_logic_vector (31 downto 0)
			
		);
						
	end entity ALU;	
					
	architecture Behavioral of ALU is     
	    
	begin
	process(clk,rst_l)
        if rst_l = '0' then
            alu_result <= (others => 0);
        elsif rising_edge(clk) then
            case opcode
                

                    
            end case;
        end if;
    end process
	
				
	end Behavioral;
	
						
						
						
						