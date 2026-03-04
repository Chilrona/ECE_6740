library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;


entity Zeros is
    port
    (
			rst_l : in std_logic;
			clk : in std_logic;
			  --jump and branch ports
			jump_addr : out std_logic_vector(9 downto 0);
			sel_jump : out std_logic;
        --address to jump to value
			op1 : in std_logic_vector (31 DOWNTO 0);
			op2 : in std_logic_vector (31 DOWNTO 0);--the address we got from the instruction
			instruction_execute : in std_logic_vector(31 downto 0)
    );
    end entity Zeros;

    architecture Behavioral of Zeros is
    
    signal opcode : std_logic_vector(5 downto 0);


    begin
		
		opcode <= instruction_execute(31 downto 26);


    process(clk, rst_l)
    begin
         if rst_l = '0' then
            jump_addr <= (others => '0');
            sel_jump <= '0';
        elsif rising_edge(clk) then
				 --check for Branch or a JR/JALR
				 if ((opcode =  JR) or (opcode = JALR)) then
					  jump_addr <= op2(9 downto 0);
					  sel_jump <= '1';
				 elsif  ((opcode = BEQZ) and (to_integer(unsigned(op1)) = 0)) then
					  jump_addr <= op2(9 downto 0);
					  sel_jump <= '1';
				 elsif ((opcode = BNEZ) and (to_integer(unsigned(op1)) /= 0)) then
					  jump_addr <= op2(9 downto 0);
					  sel_jump <= '1';
				 --if not a Branch then set sel_jump = 0
				 else 
					  jump_addr <= (others => '0');
					  sel_jump <= '0';
				 end if;
        end if;
		  end process;
    end Behavioral;


