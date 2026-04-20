library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity fetch is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic;
			jump_addr : in std_logic_vector(9 downto 0);
			sel_jump : in std_logic;

			stall : in std_logic;

			pc : buffer std_logic_vector(9 downto 0);
			instruction : out std_logic_vector(31 downto 0)
		);
						
	end entity fetch;	
					
	architecture Behavioral of fetch is
	
		signal next_pc : std_logic_vector(9 downto 0):=(others=>'0');
		signal add_out : std_logic_vector(9 downto 0):=(others=>'0');
		signal std_pc : std_logic_vector(9 downto 0):=(others=>'0');        
	
	begin
	
	U1: ENTITY work.my_ROM 
	PORT MAP
	(
		address => std_pc,
		clock	=> clk,
		q	=> instruction
	);
		
		next_pc <= std_logic_vector(unsigned(std_pc) + 1) when stall = '0' else std_pc;
		std_pc <= pc when sel_jump = '0' else jump_addr;	

        process(clk, rst_l)
        begin 
			if(rst_l = '0') then--checking for reset in pc
				pc <= (others=>'0');
			elsif rising_edge(clk) then
				pc <= next_pc;
			end if;
        end process;
				
	end Behavioral;
	
						
						
						
						