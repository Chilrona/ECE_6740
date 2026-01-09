library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UARTSampler is
		port 
		(
			KEY : in unsigned(1 downto 0);
			rx : in std_logic;
			outdata		: out std_logic
			
		);
						
	end entity UARTSampler;	
	
						
	architecture Behavioral of UARTSampler is
	
	--fifo signals
	signal rdempty : std_logic;
	signal q : std_logic;
	signal wrfull : std_logic;
	signal wrreq : std_logic;

	--need the location of the gpio we are unsigned
	signal rx : std_logic;

	signal counter, zeros, ones : integer;
	
	begin
	
	U2: entity work.my_fifo
	PORT MAP
	(
		data=> r1,
		rdclk=> c0,
		rdreq=> '1',
		wrclk => c1,
		wrreq=> wrreq,
		q=> q,
		rdempty => rdempty,
		wrfull	=>wrfull
	);


	process(c0, KEY(0))
	begin
		if counter = 7 then
			wrreq <= '1';
			counter <= 0;
			zeros <= 0;
			if zeros>ones then
				data <= '0';
			else
				data <='1';
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
	end process;
	
	process(c1, KEY(0)) 
	begin
		if (rdempty ='0') then
			rdreq <= '1';
			outdata <= q;
		end if;
	end process;
	
	
	end Behavioral;