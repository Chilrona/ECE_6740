library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity ALU is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic;
         	opcode : in std_logic_vector(5 downto 0);
			op1 : in std_logic_vector (31 downto 0);
         	op2 : in std_logic_vector (31 downto 0);
         	alu_result : out std_logic_vector (31 downto 0);
			ram_we : out std_logic
			
		);
						
	end entity ALU;	
					
	architecture Behavioral of ALU is     
	    
	begin
	process(clk,rst_l)
	begin
        if rst_l = '0' then
            alu_result <= (others => '0');
        elsif rising_edge(clk) then
			case opcode is
            when NOP =>
					alu_result <= (others => '0');
				when LW =>
					alu_result <= std_logic_vector(unsigned(op1) + unsigned(op2));
				when SW =>
					alu_result <= std_logic_vector(unsigned(op1) + unsigned(op2));
				when ADD =>
					alu_result <= std_logic_vector(signed(op1) + signed(op2));
				when ADDI =>
					alu_result <= std_logic_vector(signed(op1) + signed(op2));
				when ADDU =>
					alu_result <= std_logic_vector(unsigned(op1) + unsigned(op2));
				when ADDUI =>
					alu_result <= std_logic_vector(unsigned(op1) + unsigned(op2));
				when SUB_OP =>
					alu_result <= std_logic_vector(signed(op1) - signed(op2));
				when SUBI =>
					alu_result <= std_logic_vector(signed(op1) - signed(op2));
				when SUBU =>
                    alu_result <= std_logic_vector(unsigned(op1) - unsigned(op2));
				when SUBUI =>
					alu_result <= std_logic_vector(unsigned(op1) - unsigned(op2));
				when AND_OP =>
					alu_result <= op1 and op2;
				when ANDI =>
					alu_result <= op1 and op2;
				when OR_OP =>
					alu_result <= op1 or op2;
				when ORI =>
					alu_result <= op1 or op2;
				when XOR_OP =>
					alu_result <= op1 xor op2;
				when XORI =>
					alu_result <= op1 xor op2;
				when SLL_OP =>
					alu_result <= std_logic_vector(shift_left(unsigned(op1), to_integer(unsigned(op2))));
				when SLLI =>
					alu_result <= std_logic_vector(shift_left(unsigned(op1), to_integer(unsigned(op2))));
				when SRL_OP =>
					alu_result <= std_logic_vector(shift_right(unsigned(op1), to_integer(unsigned(op2))));
				when SRLI =>
					alu_result <= std_logic_vector(shift_right(unsigned(op1), to_integer(unsigned(op2))));
				when SRA_OP =>
					alu_result <= std_logic_vector(shift_right(signed(op1), to_integer(unsigned(op2))));
				when SRAI =>
					alu_result <= std_logic_vector(shift_right(signed(op1), to_integer(unsigned(op2))));
				when SLT =>
					if signed(op1) < signed(op2) then
						alu_result <= X"00000001";
					end if;
				when SLTI =>
					if signed(op1) < signed(op2) then
						alu_result <= X"00000001";
					end if;
				when SLTU =>
					if unsigned(op1) < unsigned(op2) then
						alu_result <= X"00000001";
					end if;
				when SLTUI =>
					if unsigned(op1) < unsigned(op2) then
						alu_result <= X"00000001";
					end if;
				when SGT =>
					if signed(op1) > signed(op2) then
						alu_result <= X"00000001";
					end if;
				when SGTI =>
					if signed(op1) > signed(op2) then
						alu_result <= X"00000001";
					end if;
				when SGTU =>
					if unsigned(op1) > unsigned(op2) then
						alu_result <= X"00000001";
					end if;
				when SGTUI =>
					if unsigned(op1) > unsigned(op2) then
						alu_result <= X"00000001";
					end if;
				when SLE =>
					if signed(op1) <= signed(op2) then
						alu_result <= X"00000001";
					end if;
				when SLEI =>
					if signed(op1) <= signed(op2) then
						alu_result <= X"00000001";
					end if;
				when SLEU =>
					if unsigned(op1) <= unsigned(op2) then
						alu_result <= X"00000001";
					end if;
				when SLEUI =>
					if unsigned(op1) <= unsigned(op2) then
						alu_result <= X"00000001";
					end if;
				when SGE =>
					if signed(op1) >= signed(op2) then
						alu_result <= X"00000001";
					end if;
				when SGEI =>
					if signed(op1) >= signed(op2) then
						alu_result <= X"00000001";
					end if;
				when SGEU =>
					if unsigned(op1) >= unsigned(op2) then
						alu_result <= X"00000001";
					end if;
				when SGEUI =>
					if unsigned(op1) >= unsigned(op2) then
						alu_result <= X"00000001";
					end if;
				when SEQ =>
					if op1 = op2 then
						alu_result <= X"00000001";
					end if;
				when SEQI =>
					if op1 = op2 then
						alu_result <= X"00000001";
					end if;
				when SNE =>
					if op1 /= op2 then
						alu_result <= X"00000001";
					end if;
				when SNEI =>
					if op1 /= op2 then
						alu_result <= X"00000001";
					end if;
				when BEQZ =>
					alu_result <= (others=>'0');
				when BNEZ =>
					alu_result <= (others=>'0');
				when J =>
					alu_result <= (others=>'0');
				when JR =>
					alu_result <= (others=>'0');
				when JAL =>
					alu_result <= op1;
				when JALR =>
					alu_result <= op1;
				when others =>
					alu_result <= (others=>'0');
            end case;
			if opcode = SW then
				ram_we <= '1';
			else
				ram_we <= '0';
			end if;
        end if;
    end process;
	
				
	end Behavioral;
	
						
						
						
						