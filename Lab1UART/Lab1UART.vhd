library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Lab1UART is
		port 
		(
			KEY : in unsigned(1 downto 0);
			ADC_CLK_10 : in std_logic;
			MAX10_CLK1_50 : in std_logic;
			MAX10_CLK2_50 : in std_logic;
			HEX0 : out unsigned(7 downto 0);
			HEX1 : out unsigned(7 downto 0);
			HEX2 : out unsigned(7 downto 0);
			HEX3 : out unsigned(7 downto 0);
			HEX4 : out unsigned(7 downto 0);
			HEX5 : out unsigned(7 downto 0);
			LEDR : out unsigned(9 downto 0);
			SW	  : in unsigned(9 downto 0);
			ARDUINO_IO : inout unsigned(15 downto 0);
			ARDUINO_RESET_N : inout std_logic;
			GPIO : inout unsigned(35 downto 0)
		);
						
	end entity Lab1UART;	
	
						
	architecture Behavioral of Lab1UART is
	
	--enter signals here:
	
	--pll signals
	signal areset		: STD_LOGIC := '0';
	signal c0		: STD_LOGIC ; --153600 Hz
	signal c1		: STD_LOGIC ; --19200 Hz
	signal locked		: STD_LOGIC;  

	
	--fifo signals
	signal rdempty : std_logic;
	signal q : std_logic;
	signal wrfull : std_logic;
	signal wrreq : std_logic;
	
	
	begin
	rx = GPIO(X);
	--enter port maps here:
	
	U1: entity work.pll 
	PORT MAP
	(
		areset=> areset,
		inclk0=>MAX10_CLK1_50,
		c0=>c0,
		c1=>c1,
		locked=>locked
	);

	
	U2: entity work.my_fifo
	PORT MAP
	(
		data=> r1,
		rdclk=> c0,
		rdreq=> '1',
		wrclk => c1,
		wrreq=> ,
		q=> q,
		rdempty => rdempty,
		wrfull	=>wrfull
	);

	
	
	process()
	begin
	
	
	end process;
	
	end Behavioral;