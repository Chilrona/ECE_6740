library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity OVERSEER is
    port 
    (
        clk : in std_logic;

        instruction_decode : in std_logic_vector(31 downto 0);
        instruction_execute : in std_logic_vector(31 downto 0);
        instruction_wb : in std_logic_vector(31 downto 0);

        take_branch : in std_logic;
        in_buf_empty : in std_logic;

        flush_fetch : out std_logic;
        flush_decode : out std_logic;
        flush_execute : out std_logic;

        take_jump : out std_logic;
        jump_addr : out std_logic_vector(9 downto 0);

        stall : out std_logic :='0'
    );
                    
end entity OVERSEER;
architecture BEHAVIORAL of OVERSEER is

begin

    Flush: process(instruction_decode, take_branch, instruction_execute, in_buf_empty)
    begin
        if take_branch = '1' then
            flush_fetch <= '1';
            flush_decode <= '1';
            flush_execute <= '1';
            take_jump <= '0';
            jump_addr <= (others=>'0');
			stall <= '0';
        
        elsif (instruction_decode(31 downto 26) = J) or (instruction_decode(31 downto 26) = JAL) then
            flush_fetch <= '1';
            flush_decode <= '0';
            flush_execute <= '0';
            take_jump <= '1';
            jump_addr <= instruction_decode(9 downto 0);
				stall <= '0';
        
        elsif (instruction_execute(31 downto 26) = LW) and 
				(instruction_execute(25 downto 21) = instruction_decode(20 downto 16)) and 
				(not (is_not_data_hazard_1(instruction_decode(31 downto 26)))) then
				  
            flush_fetch <= '0';
            flush_decode <= '1';
            flush_execute <= '0';
            take_jump <= '0';
            jump_addr <= (others=>'0');
				stall <= '1';

        elsif (instruction_decode(31 downto 26) = GD or instruction_decode(31 downto 26) = GDU) and in_buf_empty = '1' then
            flush_fetch <= '0';
            flush_decode <= '1';
            flush_execute <= '0';
            take_jump <= '0';
            jump_addr <= (others=>'0');
				stall <= '1';
				
			elsif (instruction_execute(31 downto 26) = LW) and 
				(instruction_execute(25 downto 21) = instruction_decode(15 downto 11)) and 
				(is_register_register(instruction_decode(31 downto 26))) then
				flush_fetch <= '0';
					flush_decode <= '1';
					flush_execute <= '0';
					take_jump <= '0';
					jump_addr <= (others=>'0');
				stall <= '1';
		  
			  else
					flush_fetch <= '0';
					flush_decode <= '0';
					flush_execute <= '0';
					take_jump <= '0';
					jump_addr <= (others=>'0');
				stall <= '0';
			  end if;
    end process;


end BEHAVIORAL;
    