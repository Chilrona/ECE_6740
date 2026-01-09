library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UART_trans is
		port 
		(
			c1          : in std_logic;
            rst         : in std_logic;
			send        : in unsigned;
            data_in     : in std_logic_vector(7 downto 0);
            tx          : out std_logic
			
		);
						
	end entity UART_trans;	
					
	architecture Behavioral of UART_trans is
    type state_type is (IDLE, TRANSMIT);
	signal state : state_type := IDLE;
    signal counter : integer := 0;
	
	begin
	
	process(c1, rst)
	begin
		if rst = '1' then
            state <= IDLE;
            counter <= 0;
        elsif rising_edge(c1) then
            case state is
                when IDLE =>
                    if send = '1' then
                        state <= TRANSMIT;
                        counter <= 0;
                        tx <= '0';
                    else
                        tx <= '1';
                    end if;
                when TRANSMIT =>
                    if counter < 8 then
                        tx <= data_in(counter);
                        counter <= counter + 1;
                    else
                        state <= IDLE;
                        tx <= 1;
                        counter <= 0;
                when others =>
                    state <= IDLE;
            end case;
        end if;
            
	end process;
	
	
	end Behavioral;