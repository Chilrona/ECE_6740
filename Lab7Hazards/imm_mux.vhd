library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity imm_mux is
		port 
		(
            opcode : in std_logic_vector(5 downto 0);    
            imm_ex : in std_logic_vector(31 downto 0);
            q_2 : in std_logic_vector(31 downto 0);
            op2 : out std_logic_vector(31 downto 0)
		);
						
	end entity imm_mux;	

    architecture behavioral of imm_mux is 
    begin
        process(imm_ex, q_2)
		  begin
            if is_imm(opcode) then
                op2 <= imm_ex;
            else
                op2 <= q_2;
            end if;
        end process;
    end behavioral;