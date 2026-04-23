library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	entity Timer is
		port (
					Time_rst : in std_logic;
					enable_time : in std_logic;
					clk : in std_logic;
					rst_l : in std_logic;
					HEX0 : out unsigned(7 downto 0);
					HEX1 : out unsigned(7 downto 0);
					HEX2 : out unsigned(7 downto 0);
					HEX3 : out unsigned(7 downto 0);
					HEX4 : out unsigned(7 downto 0);
					HEX5 : out unsigned(7 downto 0)
				);
						
	end entity Timer;			
						
						
	architecture Behavioral of Timer is
	
		constant DIV_VAL : integer := 83 * 10000;
	
	type MY_MEM is array (0 to 15) of unsigned(7 downto 0);
			constant table : MY_MEM := (X"C0", X"F9", X"A4", X"B0", X"99",
			X"92", X"82", X"F8", X"80", X"98", X"88", X"83", X"A7", X"A1", X"86", X"8E");
			signal hundredths : integer := 0;
			signal tenths : integer := 0;
			signal sec_ones : integer := 0;
			signal sec_tens: integer := 0;
			signal min_ones : integer := 0;
			signal min_tens : integer := 0;
			signal slow_clk: unsigned(31 downto 0) :=(others=>'0'); -- variable to count up and slow our clk
	
		begin
				process (clk, Time_rst, rst_l)
				begin
					if Time_rst = '1' or rst_l = '0' then
						hundredths <=0;
						tenths <= 0;
						sec_ones <= 0;
						sec_tens <= 0;
						min_ones <= 0;
						min_tens <= 0;
						slow_clk <= (others=> '0');
					elsif rising_edge(clk) then
						if enable_time = '1' then
							if slow_clk = (DIV_VAL-1) then
						--	if slow_clk = (5-1) then
								hundredths <= hundredths + 1;
								if hundredths = 9 then
									hundredths <= 0;
									tenths <= tenths +1;
									
								if tenths = 9 then
									tenths <= 0;
									sec_ones <= sec_ones +1;
									
								if sec_ones	= 9 then
									sec_ones <= 0;
									sec_tens <= sec_tens +1;
									
								if sec_tens = 5 then
									sec_tens <= 0;
									min_ones <= min_ones +1;
								
								if min_ones = 9 then
									min_ones <= 0;
									min_tens <= min_tens +1;
								
								if min_tens = 5 then
									min_tens <= 0;
									
								end if;
								end if;	
								end if;
								end if;	
								end if;
								end if;
								slow_clk <= (others=> '0');
								
								else
									slow_clk<=slow_clk+1;
							end if;
						end if;
					end if;
						HEX0 <= table(hundredths);
						HEX1 <= table(tenths);
						HEX2 <= table(sec_ones) -x"80";
						HEX3 <= table(sec_tens);
						HEX4 <= table(min_ones) -x"80";
						HEX5 <= table(min_tens);
					
				end process;
				
	end Behavioral;
	
						
						
						
						