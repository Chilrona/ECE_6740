library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UART_trans is
		port 
		(
			c1          : in std_logic;
            rst_l       : in std_logic;
			send       	: in std_logic;
            data_in     : in unsigned(7 downto 0);
            tx          : out std_logic;
            idle_flag   : out std_logic
			
		);
						
	end entity UART_trans;	
					
	architecture Behavioral of UART_trans is
    type state_type is (IDLE, TRANSMIT);
	signal state : state_type := IDLE;
    signal counter : integer := 0;
	
	begin
	
	process(c1, rst_l)
	begin
		if rst_l = '0' then
            state <= IDLE;
            counter <= 0;
        elsif rising_edge(c1) then
            case state is
                when IDLE =>
                    if send = '1' then
                        state <= TRANSMIT;
                        counter <= 0;
                        tx <= '0';
                        idle_flag <= '0'
                    else
                        idle_flag <= '1';
                        tx <= '1';
                    end if;
                when TRANSMIT =>
                    if counter < 8 then
                        tx <= data_in(counter);
                        counter <= counter + 1;
                        idle_flag <= '0';
                    else
                        tx <= '1';
                        counter <= 0;
						state <= IDLE;
                        idle_flag <= '1';
					end if;
                when others =>
                    state <= IDLE;
            end case;
        end if;
            
	end process;
	
	
	end Behavioral;