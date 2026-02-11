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
        jump_addr : out unsigned(9 downto 0);
		sel_jump : out std_logic;
        --address to jump to value
        q_1 : in std_logic_vector (31 DOWNTO 0);
        op2 : in std_logic_vector (31 DOWNTO 0);--the address we got from the instruction
        instruction_execute : in std_logic_vector(31 downto 0)
    );
    end entity Zeros;

    architecture Behavioral of Zeros is
    
    signal opcode : std_logic_vector(31 downto 26);


    begin


    process(clk)
    begin
         if rst_l = '0' then
            jump_addr <= (others => '0');
            sel_jump <= (others => '0');
        elsif rising_edge(clk) then
            --check for Jump or Branch
            if ((opcode = J) or (opcode =  JR) or (opcode = JAL)or (opcode = JALR)) then
                jump_addr <= unsigned(op2(9 downto 0));
                sel_jump <= '1';
            elsif ((opcode = BEQZ) and (q_1 =(others => '0'))) then
                jump_addr <= unsigned(op2(9 downto 0));
                sel_jump <= '1';
            elsif ((opcode = BNEZ) and (q_1 /=(others => '0'))) then
                jump_addr <= unsigned(op2(9 downto 0));
                sel_jump <= '1';
            --if not Jump or Branch then set sel_jump = 0
            else 
                jump_addr <= (others => '0');
                sel_jump <= '0';
            end if;

        end if;
		  end process;
    end Behavioral;


