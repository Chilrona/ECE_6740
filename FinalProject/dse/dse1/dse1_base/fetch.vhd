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
		--signal prev_stall : std_logic;
		--signal posedge_stall : std_logic;
	
	begin
	
	U1: ENTITY work.my_ROM 
	PORT MAP
	(
		address => std_pc,
		clock	=> clk,
		q	=> instruction
	);
		
		next_pc <= std_logic_vector(unsigned(std_pc) + 1);
		--std_pc <= pc when sel_jump = '0' else jump_addr;
	
		--posedge_stall <= '1' when ((prev_stall = '0') and (stall = '1')) else '0';
		
		process(stall, pc, sel_jump, jump_addr)
		begin
			if stall = '1' then
				std_pc <= std_logic_vector(unsigned(pc) - 1);
			elsif sel_jump = '1' then
				std_pc <= jump_addr;
			else
				std_pc <= pc;
			end if;
		end process;

        process(clk, rst_l)
        begin 
			if(rst_l = '0') then--checking for reset in pc
				pc <= (others=>'0');
				--prev_stall <= '0';
			elsif rising_edge(clk) then
				pc <= next_pc;
				--prev_stall <= stall;
			end if;
        end process;
			
				
	end Behavioral;
	
						
						
						
						