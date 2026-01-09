library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_uart_recv is
end entity;

architecture sim of tb_uart_recv is
    constant CLK_PERIOD : time := 10 ns;

    signal c1        : std_logic := '0';
    signal rst       : std_logic := '0';  -- active-low reset
    signal rx_sync   : std_logic := '1';  -- idle high
    signal char      : unsigned(7 downto 0);
    signal send_flag : std_logic;

begin

    -- Clock
    clk_proc : process
    begin
        while true loop
            c1 <= '0'; wait for CLK_PERIOD/2;
            c1 <= '1'; wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- DUT
    uut : entity work.uart_recv
        port map (
            c1        => c1,
            rx_sync   => rx_sync,
            char      => char,
            send_flag => send_flag,
            rst       => rst
        );

    -- Stimulus: drive 'A' (0x41) repeatedly, LSB-first
    stim_proc : process
        -- 'A' = 0x41, bits LSB->MSB: 1,0,0,0,0,0,1,0
        constant A_BITS : std_logic_vector(7 downto 0) := "01000001";
        -- Note: A_BITS(0) is LSB = '1'
    begin
        -- Hold reset low briefly
        rst <= '0';
        rx_sync <= '1';
        wait for 10*CLK_PERIOD;

        -- Release reset
        rst <= '1';
        wait for 5*CLK_PERIOD;

        -- Repeat forever
        while true loop
            -- Start condition (rx goes low)
            rx_sync <= '0';
            wait until rising_edge(c1);

            -- Send 8 data bits, LSB first (data(0) first)
            for i in 0 to 7 loop
                rx_sync <= A_BITS(i);
                wait until rising_edge(c1);
            end loop;

            -- Return to idle high between characters
            rx_sync <= '1';
            wait until rising_edge(c1);
            wait until rising_edge(c1);
        end loop;
    end process;

end architecture;