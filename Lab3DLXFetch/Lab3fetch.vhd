library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	entity Lab3fetch is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic;
			jump_addr : in unsigned(15 downto 0);
			sel_jump : in std_logic;
			pc : out unsigned(15 downto 0);
			instruction : out unsigned(31 downto 0)
		);
						
	end entity Lab3fetch;	
					
	architecture Behavioral of Lab3fetch is
	
		signal next_pc : unsigned(15 downto 0);
		signal add_out : unsigned(15 downto 0);
        
	
	begin
	
	U1: ENTITY work.my_ROM 
	PORT MAP
	(
		address => pc,
		clock	=> clk,
		q	=> instruction
	);

		
        add_out <= pc + 1;

        next_pc <= ((others<= sel_jump) and jump_addr)or((others=>not(sel_jump)) and add_out);

        process(clk, rst_l)
        begin 
		  
			if(rst_l = '0') then--checking for reset in pc
				 pc <= (others=>'0');
			elsif rising_edge(clk)
				 pc <=next_pc;
			end if;
        end process;
				
	end Behavioral;
	
						
						
						
						