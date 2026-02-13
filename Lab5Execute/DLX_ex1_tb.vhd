library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity DLX_ex1_tb is
end DLX_ex1_tb;

architecture test of DLX_ex1_tb is

    constant CLK_PERIOD : time := 20 ns;

    -- number of times we are multiplying in factorial.dxl
    constant n : integer := 3;
    signal clk_count : integer := 0;

    -- Signals to connect to DLX
    signal rst_l : std_logic := '0';
    signal clk   : std_logic;

    -- decode signals
    signal we       : std_logic := '1';
    signal wr_data  : std_logic_vector(31 downto 0) := X"00000001";
	 signal wr_addr :std_logic_vector(4 downto 0) := "00000";

begin

    --------------------------------------------------------------------
    -- Instantiate the Unit Under Test (UUT)
    --------------------------------------------------------------------
    UUT : entity work.DLX
        port map (
            rst_l => rst_l,
            clk   => clk,

            -- data memory ports
            data  => wr_data,
            we    => we,
				wr_addr=> wr_addr
        );

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    --------------------------------------------------------------------
    -- Reset release
    --------------------------------------------------------------------
    rst_l <= '1' after 1 ps;

    --------------------------------------------------------------------
    -- Main stimulus process
    --------------------------------------------------------------------
    process (clk)
    begin
        if rising_edge(clk) then
            clk_count <= clk_count + 1;

            case clk_count is

                when 0 =>
                    we <= '1';
						  wr_addr <= "00010";
                    wr_data <= X"00000001";

                when 1 =>
                    we <= '1';
						  wr_addr <= "00001";
                    wr_data <= X"00000004";

                when 2 =>
                    we <= '1';
						  wr_addr <= "00001";
                    wr_data <= X"00000003";

                when 3 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 4 =>
                    we <= '1';
						  wr_addr <= "00111";
                    wr_data <= X"00000001";

                when 5 =>
                    we <= '1';
						  wr_addr <= "01000";
                    wr_data <= X"00000003";

                when 6 =>
                    we <= '1';
						  wr_addr <= "00010";
                    wr_data <= X"00000001";

                when 7 =>
                    we <= '0';
						  wr_addr <= "11111";
                    wr_data <= X"00000008";

                when 8 =>
                    we <= '1';
						  wr_addr <= "00010";
                    wr_data <= X"00000002";

                when 9 =>
                    we <= '1';
						  wr_addr <= "01000";
                    wr_data <= X"00000002";

                when 10 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 11 =>
                    we <= '1';
						  wr_addr <= "00010";
                    wr_data <= X"00000003";

                when 12 =>
                    we <= '1';
						  wr_addr <= "01000";
                    wr_data <= X"00000001";

                when 13 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 14 =>
                    we <= '1';
						  wr_addr <= "00010";
                    wr_data <= X"00000004";

                when 15 =>
                    we <= '1';
						  wr_addr <= "01000";
                    wr_data <= X"00000000";

                when 16 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 17 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 18 =>
                    we <= '1';
						  wr_addr <= "00001";
                    wr_data <= X"00000002";

                when 19 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 20 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 21 =>
                    we <= '1';
						  wr_addr <= "00111";
                    wr_data <= X"00000004";

                when 22 =>
                    we <= '1';
						  wr_addr <= "01000";
                    wr_data <= X"00000002";

                when 23 =>
                    we <= '1';
						  wr_addr <= "00010";
                    wr_data <= X"00000004";

                when 24 =>
                    we <= '1';
						  wr_addr <= "11111";
                    wr_data <= X"00000008";

                when 25 =>
                    we <= '1';
						  wr_addr <= "00010";
                    wr_data <= X"00000008";

                when 26 =>
                    we <= '1';
						  wr_addr <= "01000";
                    wr_data <= X"00000001";

                when 27 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 28 =>
                    we <= '1';
						  wr_addr <= "00010";
                    wr_data <= X"0000000C";

                when 29 =>
                    we <= '1';
						  wr_addr <= "01000";
                    wr_data <= X"00000000";

                when 30 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 31 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 32 =>
                    we <= '1';
						  wr_addr <= "00001";
                    wr_data <= X"00000001";

                when 33 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 34 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 35 =>
                    we <= '1';
						  wr_addr <= "00111";
                    wr_data <= X"0000000C";

                when 36 =>
                    we <= '1';
						  wr_addr <= "01000";
                    wr_data <= X"00000001";

                when 37 =>
                    we <= '1';
						  wr_addr <= "00010";
                    wr_data <= X"0000000C";

                when 38 =>
                    we <= '1';
						  wr_addr <= "11111";
                    wr_data <= X"00000008";

                when 39 =>
                    we <= '1';
						  wr_addr <= "00010";
                    wr_data <= X"00000018";

                when 40 =>
                    we <= '1';
						  wr_addr <= "01000";
                    wr_data <= X"00000000";

                when 41 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 42 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 43 =>
                    we <= '1';
						  wr_addr <= "00001";
                    wr_data <= X"00000000";

                when 44 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when 45 =>
                    we <= '0';
						  wr_addr <= "00000";
                    wr_data <= X"00000000";

                when others =>
                    we <= '0';
                    wr_data <= X"00000000";

            end case;
        end if;
    end process;

end test;