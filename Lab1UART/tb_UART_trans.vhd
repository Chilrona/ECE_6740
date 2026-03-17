library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench for UART_trans
-- Assumptions based on DUT implementation:
--   * c1 is the "bit clock" (one rising edge per UART bit)
--   * Frame: 1 start bit (0), 8 data bits LSB-first, 1 stop bit (1)
--   * 'send' is sampled in IDLE on a rising edge of c1

entity tb_UART_trans is
end entity;

architecture sim of tb_UART_trans is
    signal c1      : std_logic := '0';
    signal rst     : std_logic := '1';
    signal send    : std_logic := '0';
    signal data_in : unsigned(7 downto 0) := (others => '0');
    signal tx      : std_logic;

    constant TBIT  : time := 100 ns;  -- "bit clock" period (adjust as needed)

    procedure check_tx(expected : std_logic; label_txt : string) is
    begin
        assert tx = expected
            report "TX mismatch (" & label_txt & "): expected '" & std_logic'image(expected) &
                   "' got '" & std_logic'image(tx) & "'"
            severity error;
    end procedure;

    procedure send_byte(b : unsigned(7 downto 0); name : string) is
    begin
        -- Ensure we are idle high for at least a cycle
        wait until rising_edge(c1);
        wait for 1 ns;
        check_tx('1', name & " pre-idle");

        -- Drive data and pulse send for 1 bit-clock
        data_in <= b;
        send    <= '1';
        wait until rising_edge(c1);
        send    <= '0';
        wait for 1 ns;

        -- Start bit
        check_tx('0', name & " start");

        -- Data bits (LSB first because DUT uses data_in(counter) with counter 0..7)
        for i in 0 to 7 loop
            wait until rising_edge(c1);
            wait for 1 ns;
            check_tx(b(i), name & " data bit " & integer'image(i));
        end loop;

        -- Stop bit / return to idle
        wait until rising_edge(c1);
        wait for 1 ns;
        check_tx('1', name & " stop");

        -- Stay idle for a couple cycles
        for k in 1 to 2 loop
            wait until rising_edge(c1);
            wait for 1 ns;
            check_tx('1', name & " idle");
        end loop;
    end procedure;

begin
    -- Clock generator
    c1 <= not c1 after TBIT/2;

    -- DUT
    dut: entity work.UART_trans
        port map (
            c1      => c1,
            rst     => rst,
            send    => send,
            data_in => data_in,
            tx      => tx
        );

    -- Stimulus
    stim: process
    begin
        -- Reset for a few cycles
        rst <= '1';
        send <= '0';
        data_in <= (others => '0');
        wait for 3*TBIT;
        rst <= '0';

        -- Allow DUT to settle into IDLE and drive tx high
        wait until rising_edge(c1);
        wait for 1 ns;
        check_tx('1', "after reset");

        -- Test a few bytes
        send_byte(to_unsigned(16#55#, 8), "0x55");  -- 01010101
        send_byte(to_unsigned(16#A3#, 8), "0xA3");  -- 10100011
        send_byte(to_unsigned(16#00#, 8), "0x00");
        send_byte(to_unsigned(16#FF#, 8), "0xFF");

        -- Edge case: assert send during TRANSMIT; should not disturb current frame
        data_in <= to_unsigned(16#3C#, 8);
        send    <= '1';
        wait until rising_edge(c1);
        send <= '0';
        wait for 1 ns;
        check_tx('0', "0x3C start");

        -- During transmit, pulse send again with a different data_in; DUT should ignore it
        wait until rising_edge(c1);
        data_in <= to_unsigned(16#C3#, 8);
        send <= '1';
        wait until rising_edge(c1);
        send <= '0';

        -- Continue checking that frame still matches 0x3C
        -- We already consumed 1 data-bit check edge above by advancing once; align checks:
        -- At this point, we are at data bit 1 next.
        wait for 1 ns;
        check_tx(to_unsigned(16#3C#, 8)(0), "0x3C data bit 0");

        for i in 1 to 7 loop
            wait until rising_edge(c1);
            wait for 1 ns;
            check_tx(to_unsigned(16#3C#, 8)(i), "0x3C data bit " & integer'image(i));
        end loop;

        wait until rising_edge(c1);
        wait for 1 ns;
        check_tx('1', "0x3C stop");

        report "All UART_trans tests PASSED." severity note;
        wait;
    end process;

end architecture;
