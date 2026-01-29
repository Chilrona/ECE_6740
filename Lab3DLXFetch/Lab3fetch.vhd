library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity Lab3fetch is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic;
			jump_addr : in unsigned(9 downto 0);
			sel_jump : in std_logic;
			pc : inout unsigned(9 downto 0);
			instruction : out std_logic_vector(31 downto 0)
		);
						
	end entity Lab3fetch;	
					
	architecture Behavioral of Lab3fetch is
	
		signal next_pc : unsigned(9 downto 0):=(others=>'0');
		signal add_out : unsigned(9 downto 0):=(others=>'0');
		signal std_pc : std_logic_vector(9 downto 0):=(others=>'0');
        
	
	begin
	
	U1: ENTITY work.my_ROM 
	PORT MAP
	(
		address => std_pc,
		clock	=> clk,
		q	=> instruction
	);
			std_pc <= std_logic_vector(pc);
		
        add_out <= pc + 1;

        next_pc <= ((9 downto 0 => sel_jump) and jump_addr)or((9 downto 0=>not(sel_jump)) and add_out);

        process(clk, rst_l)
        begin 
		  
			if(rst_l = '0') then--checking for reset in pc
				 pc <= (others=>'0');
			elsif rising_edge(clk) then
				 pc <=next_pc;
			end if;
        end process;
				
	end Behavioral;
	
						
						
						
						