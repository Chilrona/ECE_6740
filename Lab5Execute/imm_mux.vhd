library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity PC_mux is
		port 
		(
            opcode : in std_logic_vector(5 downto 0);    
            imm_ex : in std_logic_vector(9 downto 0);
            q_2 : in std_logic_vector(31 downto 0);

            op_2 : out std_logic_vector(31 downto 0)
		);
						
	end entity PC_mux;	

    architecture behavioral of execute is 
    begin
        process()
            if is_imm(opcode) then
                op_2 <= im_ex;
            else
                op_2 <= q_2;
            end if;
        end process;
    end behavioral;