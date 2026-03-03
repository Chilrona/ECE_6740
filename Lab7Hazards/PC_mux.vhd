library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity PC_mux is
		port 
		(
            opcode : in std_logic_vector(5 downto 0);    
            pc : in std_logic_vector(9 downto 0);
            q_1 : in std_logic_vector(31 downto 0);
            op1 : out std_logic_vector(31 downto 0)
				--add the ALU result coming out of execute as one of the mux inputs
				--add something other stuff but IDK what 
		);
						
	end entity PC_mux;	

    architecture behavioral of PC_mux is 
    begin
        process(pc, q_1)
		  begin
            if opcode = JAL or opcode = JALR then
                op1 <= std_logic_vector(resize(unsigned(pc), 32));
            else
				--need to add an if statement for checking data hazards
                op1 <= q_1;
            end if;
        end process;
    end behavioral;