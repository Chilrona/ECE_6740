library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_UART_trans is
end entity;

architecture sim of tb_UART_trans is
    constant CLK_PERIOD : time := 10 ns;

    signal c1      : std_logic := '0';
    signal rst     : std_logic := '1';
    signal send    : std_logic := '0';
    signal data_in : unsigned(7 downto 0) := (others => '0');
    signal tx      : std_logic;
begin

    -- Clock generator
    clk_proc : process
    begin
        while true loop
            c1 <= '0'; wait for CLK_PERIOD/2;
            c1 <= '1'; wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- DUT
    uut : entity work.UART_trans
        port map (
            c1      => c1,
            rst     => rst,
            send    => send,
            data_in => data_in,
            tx      => tx
        );

    -- Stimulus: transmit 'A' forever
    stim_proc : process
    begin
        -- reset
        rst <= '1';
        wait for 10*CLK_PERIOD;
        rst <= '0';

        -- ASCII 'A' = 65 = 0x41
        data_in <= to_unsigned(65, 8);

        wait for 5*CLK_PERIOD;

        while true loop
            -- start transmission (one-cycle pulse)
            send <= '1';
            wait for CLK_PERIOD;
            send <= '0';

            -- wait long enough for the 8-bit transmit to complete
            -- (your design shifts one bit per clock for 8 clocks)
            wait for 12*CLK_PERIOD;
        end loop;
    end process;

end architecture;