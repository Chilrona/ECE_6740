library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity imm_mux is
		port 
		(
            --used for checking data hazards
            opcode_exe : in std_logic_vector(5 downto 0);
				opcode_mem : in std_logic_vector(5 downto 0);
				opcode_wb : in std_logic_vector(5 downto 0);
            rd_mem : in std_logic_vector(4 downto 0);
            rd_wb : in std_logic_vector(4 downto 0);
            RS2 : in std_logic_vector(4 downto 0);

            --alu_result
            reg_data : in std_logic_vector(31 downto 0);
            alu_result : in std_logic_vector(31 downto 0); 

            
            imm_ex : in std_logic_vector(31 downto 0);
            q_2 : in std_logic_vector(31 downto 0);
            op2 : out std_logic_vector(31 downto 0)
		);
						
	end entity imm_mux;	

    architecture behavioral of imm_mux is 
    begin
        process(imm_ex, q_2, opcode_exe, opcode_mem, opcode_wb, rd_mem, RS2, alu_result, rd_wb, reg_data)
		  begin
            if is_imm(opcode_exe) then
                op2 <= imm_ex;
				elsif (rd_mem = RS2) and is_register_register(opcode_exe) and not(has_no_dest_reg(opcode_mem)) then
                op2 <= alu_result;
				elsif ((rd_wb = RS2) and is_register_register(opcode_exe) and not(has_no_dest_reg(opcode_wb))) or (opcode_wb = JAL and RS2 = "11111")  then
                op2 <= reg_data;
            else
                op2 <= q_2;
            end if;
        end process;
    end behavioral;