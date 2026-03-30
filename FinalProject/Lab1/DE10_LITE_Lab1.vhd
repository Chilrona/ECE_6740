
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--PSEUDOCODE but for circuits not code so PSEUDOCIRCUIT
--We need to have the clock, buttons and leds initialized as inputs and outputs
--Initialize the clock at a 2 Hz rate without a clock divider\
--check if reset is pressed and check if the led is at the max value if so reset to zero
--Increment the led values 
entity DE10_LITE_Lab1 is
	port (
			clk : in std_logic;
			rst_l : in std_logic;
			out1 : out std_logic_vector(9 downto 0) --This is for our LEDs
	);

end entity  DE10_LITE_Lab1;


--start up the clock 
--if reset or led value is max value
--then set led value to zero
--else increment led value

architecture Behavioral of  DE10_LITE_Lab1 is
signal temp : unsigned(9 downto 0) := (others=> '0'); --we can use this others thing instead of 000000000... for any size vector
signal slow_clk: unsigned(31 downto 0) :=(others=>'0'); -- variable to count up and slow our clk




begin

	process (clk, rst_l)
	begin
	
		if rst_l = '0' or temp = "1111111111" then
			temp <= (others => '0');
			slow_clk <= (others=> '0');

		elsif button1 = '0' then --do I need sigal parathesis

				if rising_edge(clk) then
					if slow_clk = x"17D7840" then
					--increment the leds here
					temp <= temp + 1;
					slow_clk <= (others=> '0');
					else
						slow_clk<=slow_clk+1;
					end if;
				end if;	
		end if;		
	end process;
	
	out1 <= std_logic_vector(temp); -- updating the led outputs 

end Behavioral;