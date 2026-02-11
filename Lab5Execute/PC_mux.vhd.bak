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

            op_1 : out std_logic_vector(31 downto 0)
		);
						
	end entity PC_mux;	

    architecture behavioral of execute is 
    begin
        process()
            if opcode = JAL or opcode = JALR then
                op_1 <= pc;
            else
                op_1 <= q_1;
            end if;
        end process;
    end behavioral;