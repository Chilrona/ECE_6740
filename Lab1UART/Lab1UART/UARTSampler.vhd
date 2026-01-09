library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UARTSampler is
		port 
		(
			c0 : in std_logic;
			c1 : in std_logic;
			rst : in std_logic;
			rx : in std_logic;
			outdata		: out std_logic
			
		);
						
end entity UARTSampler;	
	
						
	architecture Behavioral of UARTSampler is
	
	--fifo signals
	signal rdempty : std_logic;
	signal q : std_logic_vector (0 downto 0);
	signal wrfull : std_logic;
	signal wrreq : std_logic;
	signal data : std_logic_vector (0 downto 0);
	signal rdreq : std_logic;

	signal counter, zeros, ones : integer;
	
	begin
	
	U2: entity work.my_fifo
	PORT MAP
	(
		data=> data,
		rdclk=> c1,
		rdreq=> '1',
		wrclk => c0,
		wrreq=> wrreq,
		q=> q,
		rdempty => rdempty,
		wrfull	=>wrfull
	);


	process(c0)
	begin
	if rising_edge(c0) then
		if counter = 7 then
			wrreq <= '1';
			counter <= 0;
			zeros <= 0;
			if zeros>ones then
				data(0) <= '0';
			else
				data(0) <='1';
			end if;
		else
			wrreq <= '0';
			counter <=counter +1;
			if rx = '0' then
				zeros <= zeros + 1;
			else
				ones <= ones + 1;
			end if;
		end if;
	end if;
	end process;
	
	process(c1) 
	begin
	if rising_edge(c1) then
		if (rdempty ='0') then
			outdata <= q(0);
		end if;
	end if;
	end process;
	
	
	end Behavioral;