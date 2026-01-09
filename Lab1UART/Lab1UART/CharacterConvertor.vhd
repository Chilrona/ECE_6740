library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity CharacterConvertor is
		port
			(
				InChar : in  unsigned (7 downto 0);
				OutChar : out unsigned (7 downto 0)
			);
		end entity CharacterConvertor;
		
		architecture Behavioral of CharacterConvertor is
		
		
		begin
		
		process(InChar)
		begin
			if (x"60" < InChar and InChar < x"7B") then
				OutChar <= InChar - x"20";
			elsif (x"40" < InChar and InChar < x"5B") then
				OutChar <= InChar +x"20";
			else
				OutChar <= x"45";
			end if;
		
		end process;
		
		end Behavioral;