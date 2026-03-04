library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;


entity Branch_guess is
    port
    (
		rst_l : in std_logic;
		clk : in std_logic;
      --jump and branch ports
		jump_addr1 : out std_logic_vector(9 downto 0);
		sel_jump1 : out std_logic;
      --address to jump to value
		pc_decode : in std_logic_vector(9 downto 0);
		instruction_decode : in std_logic_vector(31 downto 0)
    );
    end entity Branch_guess;

    architecture Behavioral of Branch_guess is
    
    signal opcode : std_logic_vector(5 downto 0);


    begin
		
		opcode <= instruction_execute(31 downto 26);


    process(clk)
    begin
         if rst_l = '0' then
            jump_addr <= (others => '0');
            sel_jump <= '0';
        elsif rising_edge(clk) then
            --check for Jump 
            if ((opcode = J) or (opcode = JAL)) then
                jump_addr <= pc_decode(9 downto 0);
                sel_jump <= '1';
            --if not Jump then set sel_jump = 0
            else 
                jump_addr <= (others => '0');
                sel_jump <= '0';
            end if;

        end if;
		  end process;
    end Behavioral;


