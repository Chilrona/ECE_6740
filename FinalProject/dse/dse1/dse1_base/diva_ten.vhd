library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;


ENTITY diva_ten is
		PORT
		(
			clk : in std_logic;
			numer	: in std_logic_vector(31 downto 0);
			quotient	: buffer std_logic_vector(31 downto 0);
			remain : buffer std_logic_vector(31 downto 0)
		);
end entity diva_ten;

architecture Behavioral of diva_ten is

-- signals here
	signal q0 : unsigned(31 downto 0);
	signal q1 : unsigned(31 downto 0);
	signal q2 : unsigned(31 downto 0);
	signal q3 : unsigned(31 downto 0);
	signal q4 : unsigned(31 downto 0);
	signal r : unsigned(31 downto 0);

begin
	-- behavior stuff here
	process(clk)
	begin
		if rising_edge(clk) then
			q0 <= shift_right(unsigned(numer), 1) + shift_right(unsigned(numer), 2);
			q1 <= q0 + shift_right(q0, 4);
			q2 <= q1 + shift_right(q1, 8);
			q3 <= q2 + shift_right(q2, 16);
			q4 <= shift_right(q3, 3);
			r <= unsigned(numer) - shift_left((shift_left(q4, 2) + q4), 1);
			if r > x"00000009" then
				quotient <= std_logic_vector(q4 + x"00000001");
				remain <= std_logic_vector(r - x"0000000A");
			else
				quotient <= std_logic_vector(q4);
				remain <= std_logic_vector(r);
			end if;
		end if;
	end process;
	
end Behavioral;