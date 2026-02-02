library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

ENTITY single_clock_ram IS
    PORT (
        clk: IN STD_LOGIC;
        data: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        write_address: IN std_logic_vector(25 downto 21);
        read_address_1: IN std_logic_vector(20 downto 16);
        read_address_2: IN std_logic_vector(15 downto 11);
        we: IN STD_LOGIC;
        q_1: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
        q_2: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
    );
END single_clock_ram;

ARCHITECTURE rtl OF single_clock_ram IS
    
BEGIN
    PROCESS (clock)
    VARIABLE ram_block: MEM;
    BEGIN
        IF (rising_edge(clock)) THEN
            IF (we = '1') THEN
                ram_block(to_integer(write_address)) := data;
            END IF;
            q_1 <= ram_block(to_integer(read_address_1)); 
            q_2 <= ram_block(to_integer(read_address_2));
            -- VHDL semantics imply that q doesn't get data 
            -- in this clock cycle
        END IF;
    END PROCESS;
END rtl;