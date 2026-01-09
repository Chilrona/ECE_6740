entity UART_reciever is
	port 
	(
		c1 : in std_logic;
		rx : inout std_logic;
		char : out unsigned (7 downto 0)
	);
					
end entity UART_reciever;

architecture Behavioral of UART_reciever is

type state_type is (IDLE,START);
signal state : state_type;
signal counter : integer := 0;
signal data : unsigned(7 downto 0) :=(others => '0');

begin

process (c1)
begin
if rising_edge(c1) then

	case state is
	
	when IDLE =>
		if rx = 0 then
			counter <= 0;
			state <= START;
		else
			state <= IDLE;
		
	when START =>
        if counter < 8 then
            data(counter) <= rx;
            counter <= counter +1;
            state <= START;
        else 
            state <= IDLE;
		end if;

	when others
            state <= IDLE;
	end case;

end if;

char <= data;

end process;
end Behavioral;
