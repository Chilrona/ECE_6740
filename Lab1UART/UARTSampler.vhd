library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UARTSampler is
		port 
		(
			KEY : in unsigned(1 downto 0);
			GPIO : inout unsigned(35 downto 0)
		);
						
	end entity UARTSampler;	
	
						
	architecture Behavioral of UARTSampler is