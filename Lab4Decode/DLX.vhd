library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity DLX is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic;
			jump_addr : in unsigned(9 downto 0);
			sel_jump : in std_logic;
			pc : inout unsigned(9 downto 0);
			instruction : out std_logic_vector(31 downto 0);
            data : in std_logic_vector (2 downto 0);
            q_1 : inout std_logic_vector (2 DOWNTO 0);
            q_2 : inout std_logic_vector(2 downto 0)

		);
						
	end entity DLX;	
					
	architecture Behavioral of DLX is     

	begin
	
	FETCH: entity work.fetch 
	port map
	(
		rst_l => rst_l,
        clk => clk,
        jump_addr => jump_addr,
        sel_jump => sel_jump,
        pc => pc,
        instruction => instruction
	);

    DECODE: entity work.decode
	port map
	(
		rst_l => rst_l,
        clk => clk,
        data => data,
        instruction => instruction,
        q_1 => q_1,
        q_2 => q_2
	);
				
	end Behavioral;