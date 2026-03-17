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

	signal sub_en : std_logic;
	signal clk_count : integer;
	
	type state_type is (IDLE, DIV, PUSH, POP);
	signal state : state_type;
	
	signal i : integer;
	
	type stack_type is array (0 to 8) of std_logic_vector(7 downto 0);
	signal stack : stack_type;
	
	--FIFO_WORD signals
	signal data_word : STD_LOGIC_VECTOR (33 DOWNTO 0);
	signal rdclk_word : std_logic_vector;
	signal rdreq_word : std_logic_vector;
	signal rdreq_word : std_logic_vector;
	signal wrclk_word : std_logic_vector;
	signal wrreq_word : std_logic_vector;
	signal q_word : STD_LOGIC_VECTOR (33 DOWNTO 0);
	signal rdempty_word : std_logic_vector;
	signal wrfull_word : std_logic_vector;

	begin
		
		
		FIFO1 ENTITY work.fifo_word 
		PORT MAP
		(
			data	<= data_word,
			rdclk	<= rdclk_word,
			rdreq	<= rdreq_word,
			wrclk	<= wrclk_word
			wrreq	<= wrreq_word,
			q <= q_word,
			rdempty	<= rdempty_word,
			wrfull <= wrfull_word 	 
		);
		
		
		FIFO2 ENTITY work.fifo_char
		PORT MAP
		(
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			rdreq		: IN STD_LOGIC ;
			wrreq		: IN STD_LOGIC ;
			empty		: OUT STD_LOGIC ;
			full		: OUT STD_LOGIC ;
			q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			usedw		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
		
		DIV ENTITY work.diva IS
		PORT MAP
		(
			clock		: IN STD_LOGIC ;
			denom		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			numer		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
			quotient		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
			remain		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);

		
			
	process (clk, rst_l)
	begin
	if rst_l = '0' then
		 state <= IDLE;
		 counter <= 0;
	elsif rising_edge(clk) then

		case state is
		
		when IDLE =>
--			  send_flag <= '0';
--			if rx_sync = '0' then
--				counter <= 0;
--				state <= START;
--			else
--				state <= IDLE;
--			end if;
			
		when DIV =>
--			  if counter < 8 then
--					send_flag <= '0';
--					data(counter) <= rx_sync;
--					counter <= counter +1;
--					state <= START;
--			  else 
--					send_flag <= '1';
--					state <= IDLE;
--				end if;

		when PUSH =>
			
			
		when POP =>
			
			

		when others =>
					state <= IDLE;
		end case;

		end if;
		
		end process;



		
	end Behavioral;	