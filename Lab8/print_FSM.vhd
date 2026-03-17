library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;




	entity print_FSM is
		port 
		(
            rst_l : in std_logic;
            clk : in std_logic;
            RS : in std_logic_vector (4 downto 0);
            FSM_opcode : in std_logic_vector(5 downto 0)
		);
						
	end entity print_FSM;	
					
	architecture Behavioral of print_FSM is 

	
	



	begin
		
		
		ENTITY work.fifo_word 
		PORT
		(
			data		
			rdclk	
			rdreq	
			wrclk	
			wrreq	
			q	
			rdempty	
			wrfull	 
		);



		
	end Behavioral;	