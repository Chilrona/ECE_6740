library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity PC_mux is
		port 
		(
            --used for checking data hazards
            opcode_exe : in std_logic_vector(5 downto 0);
				opcode_mem : in std_logic_vector(5 downto 0);
				opcode_wb : in std_logic_vector(5 downto 0);
            rd_mem : in std_logic_vector(4 downto 0); 
            rd_wb : in std_logic_vector(4 downto 0);
            RS1 : in std_logic_vector(4 downto 0);
            
            
            pc : in std_logic_vector(9 downto 0);
            q_1 : in std_logic_vector(31 downto 0);

            --alu_result
            reg_data : in std_logic_vector(31 downto 0);
            alu_result : in std_logic_vector(31 downto 0);

            op1 : out std_logic_vector(31 downto 0)
		);
						
	end entity PC_mux;	

    architecture behavioral of PC_mux is 
    begin
        process(pc, q_1, opcode_exe, opcode_mem, opcode_wb, rd_mem, RS1, alu_result, rd_wb, reg_data)
		  begin
            if opcode_exe = JAL or opcode_exe = JALR then
                op1 <= std_logic_vector(resize(unsigned(pc), 32));
            elsif (rd_mem = RS1) and not(is_not_data_hazard_1(opcode_exe)) and not(has_no_dest_reg(opcode_mem)) then
                op1 <= alu_result;
            elsif (rd_wb = RS1) and not(is_not_data_hazard_1(opcode_exe)) and not(has_no_dest_reg(opcode_wb)) then
                op1 <= reg_data;
            else
                op1 <= q_1;
            end if;
        end process;
    end behavioral;