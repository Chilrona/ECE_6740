library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity registers is
    port (
        clk: in std_logic;
        data: in std_logic_vector (31 DOWNTO 0);
        write_address: in std_logic_vector(4 downto 0);
        read_address_1: in std_logic_vector(4 downto 0);
        read_address_2: in std_logic_vector(4 downto 0);
        we: in std_logic;
        q_1: out std_logic_vector (31 DOWNTO 0);
        q_2: out std_logic_vector (31 DOWNTO 0)
    );
end registers;

architecture rtl of registers is
    
begin
	
    process (clk)
    variable ram_block: MEM:=(others=>(others=>'0'));
	
    begin
        if (rising_edge(clk)) THEN
            if (we = '1') and not(write_address = "00000") THEN
                ram_block(to_integer(unsigned(write_address))) := data;
            end if;
            q_1 <= ram_block(to_integer(unsigned(read_address_1))); 
            q_2 <= ram_block(to_integer(unsigned(read_address_2)));
            -- VHDL semantics imply that q doesn't get data 
            -- in this clock cycle
        end if;
    end process;
end rtl;