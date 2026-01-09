entity uart_recv is
	port 
	(
		c1 : in std_logic;
		rx_sync : inout std_logic;
		char : out unsigned (7 downto 0);
        send_flag : out std_logic;
        rst : in std_logic
	);
					
end entity uart_recv;

architecture Behavioral of UART_reciever is

type state_type is (IDLE,START);
signal state : state_type;
signal counter : integer := 0;
signal data : unsigned(7 downto 0) :=(others => '0');

begin

process (c1, rst)
begin
if rst = 0 then
    state <= IDLE;
    counter <= 0;
elsif rising_edge(c1) then

	case state is
	
	when IDLE =>
        send_flag <= '0';
		if rx_sync = 0 then
			counter <= 0;
			state <= START;
		else
			state <= IDLE;
		
	when START =>
        if counter < 8 then
            data(counter) <= rx_sync;
            counter <= counter +1;
            state <= START;
        else 
            send_flag <= '1';
            state <= IDLE;
		end if;

	when others
            state <= IDLE;
	end case;

end if;

char <= data;

end process;
end Behavioral;
