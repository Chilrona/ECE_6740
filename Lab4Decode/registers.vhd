LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY single_clock_ram IS
    PORT (
        clk: IN STD_LOGIC;
        data: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        write_address: IN INTEGER RANGE 0 to 31;
        read_address_1: IN INTEGER RANGE 0 to 31;
        read_address_2: IN INTEGER RANGE 0 to 31;
        we: IN STD_LOGIC;
        q_1: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
        q_2: OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
    );
END single_clock_ram;

ARCHITECTURE rtl OF single_clock_ram IS
    TYPE MEM IS ARRAY(0 TO 31) OF STD_LOGIC_VECTOR(2 DOWNTO 0);
    
BEGIN
    PROCESS (clock)
    VARIABLE ram_block: MEM;
    BEGIN
        IF (rising_edge(clock)) THEN
            IF (we = '1') THEN
                ram_block(write_address) := data;
            END IF;
            q_1 <= ram_block(read_address_1); 
            q_2 <= ram_block(read_address_2);
            -- VHDL semantics imply that q doesn't get data 
            -- in this clock cycle
        END IF;
    END PROCESS;
END rtl;