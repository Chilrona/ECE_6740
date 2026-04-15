library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;




	entity print_FSM is
		port 
		(
            rst_l : in std_logic;
            clk : in std_logic;
			uart_clk : in std_logic;
            opcode_FSM : in std_logic_vector(5 downto 0);
			op1 : in std_logic_vector(31 downto 0);

			print_stall : out std_logic;
			print_flush_decode : out std_logic;
			tx : out STD_LOGIC;
			LEDR : out std_logic_vector(9 downto 0)
		);
						
	end entity print_FSM;	
					
	architecture Behavioral of print_FSM is 

	signal neg_flag : std_logic;
	signal next_neg_flag : std_logic;
	signal clk_count : integer:= 0;
	signal n_clk_count : integer := 0;
	signal instruction_FSM : std_logic_vector(37 downto 0);
	
	type state_type is (IDLE, MAGIC, DIV, POP);
	signal state : state_type:= IDLE;
	signal next_state : state_type:= IDLE;
	
	signal i : integer:= 0;
	signal next_i : integer := 0;
	signal pos_val : std_logic_vector(31 downto 0);
	signal next_pos_val : std_logic_vector(31 downto 0);
	signal RS_signal : std_logic_vector(31 downto 0);
	signal opcode_signal : std_logic_vector(5 downto 0);
	
	type stack_type is array (0 to 9) of std_logic_vector(7 downto 0);
	signal stack : stack_type; --:= (others=>(others=>'0'));
	signal new_stack : stack_type; --:= (others=>(others=>'0'));
	
	--FIFO_WORD signals
	signal rdreq_word : std_logic:= '0';
	signal wrreq_word : std_logic:= '0';
	signal q_word : STD_LOGIC_VECTOR (37 DOWNTO 0);
	signal empty_word : std_logic;
	signal full_word : std_logic;
	signal usedw_word : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal almost_full : std_logic;
	
	
	--FIFO_CHAR signals
	signal data_char : STD_LOGIC_VECTOR (7 DOWNTO 0):= (others=>'0');
	signal next_data_char : STD_LOGIC_VECTOR (7 DOWNTO 0):= (others=>'0');
	signal rdreq_char : std_logic;
	signal wrreq_char : std_logic;
	signal rdempty_char : std_logic;
	signal wrfull_char : std_logic;
	signal wrusedw : std_logic_vector (7 downto 0);
	signal send_char : std_logic_vector (7 downto 0);
	
	--DIVVVVAAAAAAA signals
	--signal denom : STD_LOGIC_VECTOR (31 DOWNTO 0);
	--signal numer : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal quotient : STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal remain : STD_LOGIC_VECTOR (31 DOWNTO 0);
	
	-- UART signals
	signal uart_idle : std_logic;
	signal send_flag : std_logic := '0';
	

	begin
		
		instruction_FSM(37 downto 32) <=  opcode_FSM;
		instruction_FSM(31 downto 0) <=  op1;
		
		FIFO1 : ENTITY work.fifo_word 
		PORT MAP
		(
			clock	=> clk,
			data	=> instruction_FSM,
			rdreq	=> rdreq_word,
			wrreq	=> wrreq_word,
			almost_full => almost_full,
			empty	=> empty_word,
			full => full_word,
			q	=> q_word,
			usedw	=>  usedw_word
		);
		
		
		FIFO2 : ENTITY work.fifo_char
		PORT MAP
		(
			data	=> data_char,
			rdclk	=> uart_clk,
			--rdclk	=> clk,
			rdreq	=> rdreq_char,
			wrclk	=> clk,
			wrreq	=> wrreq_char,
			q => send_char,
			rdempty	=> rdempty_char,
			wrfull => wrfull_char,
			wrusedw => wrusedw
		);
		
		DIVIDER : ENTITY work.diva_ten
		PORT MAP
		(
			clk	=> clk,
			numer	=> pos_val,
			quotient	=> quotient,
			remain => remain
		);

		U : ENTITY work.UART_trans
		PORT MAP 
		(
				--c1          => clk,
				c1          => uart_clk,
            rst_l       => rst_l,
				send       	=> send_flag,
            data_in     => unsigned(send_char),
            tx          => tx,
				idle_flag	=> uart_idle
			
		);

	opcode_signal <= q_word(37 downto 32);
	RS_signal <= q_word(31 downto 0);

	process (wrusedw, almost_full)
	begin
		if (to_integer(unsigned(wrusedw)) >= 254) or (almost_full = '1') then
			print_stall <= '1';
			print_flush_decode <= '1';
		else
			print_stall <= '0';
			print_flush_decode <= '0';
		end if;
	end process;
	
	process (rdempty_char, uart_idle)
	begin
	-- add stuff for wrreq_char
		if rdempty_char = '0' and uart_idle= '1' then
			rdreq_char <= '1';
			send_flag <= '1';
		else
			rdreq_char <= '0';
			send_flag <= '0';
		end if;
	end process;
	
	
	process (opcode_FSM)
	begin
		if (opcode_FSM = PCH) or (opcode_FSM = PD) or (opcode_FSM = PDU) then
			wrreq_word <= '1';
		else
			wrreq_word <='0';
		end if;
	end process;

	process (clk, rst_l)
	begin
		if rst_l = '0' then
			 state <= IDLE;
			 clk_count <= 0;
			 i <= 0;
		elsif rising_edge(clk) then
			state <= next_state;
			i <= next_i;
			stack <= new_stack;
			clk_count <= n_clk_count;
			pos_val <= next_pos_val;
			-- data_char <= next_data_char;
			neg_flag <= next_neg_flag;
		

		end if;
		
	end process;
		
	process(state, clk_count, i, opcode_signal, RS_signal, empty_word, almost_full, next_i, stack, pos_val, data_char, neg_flag, quotient, remain )--fill in later
		begin
			next_state <= state;
			n_clk_count <= clk_count;
			next_i <= i;
			new_stack<= stack;
			next_pos_val <= pos_val;
			data_char <= (others=>'0');
			next_neg_flag <= neg_flag;
			rdreq_word <= '0';
			wrreq_char <= '0';
			
			case state is
		
		when IDLE =>
			wrreq_char <= '0';
				if empty_word = '1' then
					next_state <= IDLE;
					rdreq_word <= '0';
				else
					next_state <= MAGIC;
					rdreq_word <= '1';
				end if;
		
		when MAGIC =>
			rdreq_word <= '0';
			if opcode_signal = PCH then
				wrreq_char <= '1';
				data_char <= RS_signal(7 downto 0);
				next_state <= IDLE;

			elsif opcode_signal = PDU then
				next_pos_val <= RS_signal;
				next_state <= DIV;
			elsif opcode_signal = PD and RS_signal(31) = '1' then
				next_pos_val <= std_logic_vector((unsigned(RS_signal) XOR x"FFFFFFFF") + x"00000001");
				next_state <= DIV;
				next_neg_flag <= '1';
			elsif opcode_signal = PD and RS_signal(31) = '0' then
				next_pos_val <= RS_signal;
				next_state <= DIV;
				next_neg_flag <= '0';
			else
				next_state <= IDLE;
			end if;
			
		when DIV =>

			if clk_count > 7 then 
				
				n_clk_count <= 0;
				new_stack(i) <= std_logic_vector(unsigned(remain(7 downto 0)) + x"30");
				next_pos_val <= quotient;
				
				if quotient = x"00000000" then
					next_state <= POP;
					next_i <= i;
					if neg_flag = '1' then
						wrreq_char <= '1';
						data_char<= x"2D";
					end if;
				else
					next_state <= DIV;
					next_i <= i + 1;
				end if;
			else 
				n_clk_count <= clk_count + 1;
				next_state <= DIV;
			end if;
			
			
		when POP =>

			wrreq_char<= '1';
			data_char <= stack(i);
			
			if i = 0 then
				if empty_word = '0' then
					next_state <= MAGIC;
					rdreq_word <= '1';
				else
					next_state <= IDLE;
				end if;
				
			else
				next_i <= i - 1;
				next_state <= POP;
			end if;
			
		when others =>
				next_state <= IDLE;
		end case;
		end process;
		
		LEDR(7 downto 0) <= wrusedw;
		LEDR(9 downto 8) <= "00";

		
	end Behavioral;	


