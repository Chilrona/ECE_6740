library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	entity Lab3fetch is
		port 
		(
			rst_l : in std_logic;
			clk : in std_logic;
            jump_addr : in unsigned(31 downto 0);
            sel_jump : in std_logic;
            pc : out unsigned(31 downto 0);
            instruction : out (31 downto 0)
		);
						
	end entity Lab3fetch;	
					
	architecture Behavioral of Lab3fetch is
	
        signal next_instruction : unsigned(31 downto 0);
        signal mux_out : unsigned(31 downto 0);
        signal add_out : unsigned(31 downto 0);
        
	
	begin
		
        add_out <= next_instruction + 1;

        mux_out <= ((others<= sel_jump) and jump_addr)or((others=>not(sel_jump)) and add_out);

        process(clk, rst_l)
        begin 
            next_instruction <=mux_out;

            if(rst_l = '0') then--checking for reset in pc
                pc <= (others=>'0');
            else 
                pc <=mux_out;
            end if;
        end process;
				
	end Behavioral;
	
						
						
						
						