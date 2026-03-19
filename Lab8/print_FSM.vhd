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
			tx : out STD_LOGIC
		);
						
	end entity print_FSM;	
					
	architecture Behavioral of print_FSM is 

	signal neg_flag : std_logic;
	signal clk_count : integer;
	signal instruction_FSM : std_logic_vector(37 downto 0);
	
	type state_type is (MAGIC, DIV, POP);
	signal state : state_type:= POP;
	
	signal i : integer:= 0;
	signal pos_val : std_logic_vector(31 downto 0);
	signal RS_signal : std_logic_vector(31 downto 0);
	signal opcode_signal : std_logic_vector(5 downto 0);
	
	type stack_type is array (0 to 9) of std_logic_vector(7 downto 0);
	signal stack : stack_type;
	
	--FIFO_WORD signals
	signal rdreq_word : std_logic:= '0';
	signal wrreq_word : std_logic:= '0';
	signal q_word : STD_LOGIC_VECTOR (37 DOWNTO 0);
	signal empty_word : std_logic;
	signal full_word : std_logic;
	signal usedw_word : STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal almost_full : std_logic;
	
	
	--FIFO_CHAR signals
	signal data_char : STD_LOGIC_VECTOR (7 DOWNTO 0);
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
			rdreq	=> rdreq_char,
			wrclk	=> clk,
			wrreq	=> wrreq_char,
			q => send_char,
			rdempty	=> rdempty_char,
			wrfull => wrfull_char,
			wrusedw => wrusedw
		);
		
		DIVIDER : ENTITY work.diva
		PORT MAP
		(
			clock	=> clk,
			denom	=> x"0000000A",
			numer	=> pos_val,
			quotient	=> quotient,
			remain => remain
		);

		U : ENTITY work.UART_trans
		PORT MAP 
		(
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
		 state <= POP;
		 clk_count <= 0;
	elsif rising_edge(clk) then
		
		case state is
		
		when MAGIC =>
			
			if opcode_signal = PCH then
				data_char <= RS_signal(7 downto 0);
				state <= POP;
				rdreq_word <= '0';
			elsif opcode_signal = PDU then
				pos_val <= RS_signal;
				state <= DIV;
				rdreq_word <= '0';
			elsif opcode_signal = PD and RS_signal(31) = '1' then
				pos_val <= std_logic_vector((unsigned(RS_signal) XOR x"FFFFFFFF") + x"00000001");
				state <= DIV;
				rdreq_word <= '0';
				neg_flag <= '1';
			elsif opcode_signal = PD and RS_signal(31) = '0' then
				pos_val <= RS_signal;
				state <= DIV;
				rdreq_word <= '0';
				neg_flag <= '0';
			end if;
			
		when DIV =>
			if quotient = x"00000000" then
				state <= POP;
				i <= i - 1;
				if neg_flag = '1' then
					wrreq_char <= '1';
					data_char<= x"2D";
				end if;
			elsif clk_count = 3 then 
				state <= DIV;
				clk_count <= 0;
				stack(i) <= std_logic_vector(unsigned(remain(7 downto 0)) + x"30");
				i <= i + 1;
				pos_val <= quotient;
			else 
				clk_count <= clk_count + 1;
				state <= DIV;
			end if;
			
			
		when POP =>
			if i = 0 then
				wrreq_char<= '0';
				if empty_word = '1' then
					state <= POP;
					rdreq_word <= '0';
				else
					state <= MAGIC;
					rdreq_word <= '1';
				end if;
			else
				wrreq_char <= '1';
				data_char <= stack(i);
				i <= i - 1;
				state <= POP;
			end if;

		when others =>
					state <= POP;
		end case;

		end if;
		
		end process;

		process (uart_clk)
		begin
			if rising_edge(uart_clk) then
				if uart_idle = '1' and rdempty_char = '0' then
					send_flag <= '1';
					rdreq_char <= '1';
				else
					send_flag <= '0';
					rdreq_char <= '0';
				end if;
			end if;
		end process;



		
	end Behavioral;	
