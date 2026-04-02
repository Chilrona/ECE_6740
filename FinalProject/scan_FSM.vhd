library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;




	entity scan_FSM is
		port 
		(
         rst_l : in std_logic;
         clk : in std_logic;
			uart_clk : in std_logic; --115.2kHz
			uart_samp_clk : in std_logic; --921.6 kHz
         opcode_scan : in std_logic_vector(5 downto 0);
			rx : in std_logic;

			data_out : out std_logic_vector(31 downto 0);
			in_buff_empty : buffer STD_LOGIC := '1'
		);
						
	end entity scan_FSM;	
					
	architecture Behavioral of scan_FSM is 
	
	type state_type is (IDLE, MULT);
	signal state : state_type:= IDLE;
	signal next_state : state_type:= IDLE;
	
	-- concatenation signals
	signal cat1					: std_logic_vector(2 downto 0) := "000";
	signal cat2					: std_logic := '0';
	
	--FIFO_UART_RF signals
	signal data_uart_rf		: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal rdreq_uart_rf		: STD_LOGIC ;
	signal rdreq_uart_rf_old : STD_LOGIC;
	signal wrreq_uart_rf		: STD_LOGIC ;
	signal wrreq_uart_rf_final : STD_LOGIC;
	signal q_char			: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal rdempty_uart_rf	: STD_LOGIC ;
	signal wrfull_uart_rf	: STD_LOGIC; 
	
	
	--FIFO_IN_BUF signals
	signal data_in		: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal data_in_next		: STD_LOGIC_VECTOR (31 DOWNTO 0);
	signal rdreq_in_buf		: STD_LOGIC ;
	signal wrreq_in_buf		: STD_LOGIC ;
	signal full_in_buf		: STD_LOGIC ;
	signal usedw_in_buf		: STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	--UART Signals
	signal rx_sync_sig : std_logic;
	signal char_in : std_logic_vector(7 downto 0);
	
	--multiplication
	signal mult_out : std_logic_vector(31 downto 0);
	
	--neg stuff
	signal neg_flag : std_logic := '0';
	signal next_neg_flag : std_logic := '0';
	

	begin
		
		UART_RF : ENTITY work.FIFO_UART_RF
		PORT MAP
		(
			data => char_in,
			rdclk => clk,
			rdreq	=>	rdreq_uart_rf,
			wrclk	=> uart_clk,
			wrreq	=> wrreq_uart_rf,
			q	=> q_char,
			rdempty => rdempty_uart_rf,
			wrfull =>wrfull_uart_rf
		);
		
		
		IN_BUF : ENTITY work.fifo_in_buf
		PORT MAP
		(
			clock => clk,
			data => data_in,
			rdreq => rdreq_in_buf,
			wrreq	=> wrreq_in_buf,
			empty	=>in_buff_empty,
			full=> full_in_buf,
			q => data_out,
			usedw => usedw_in_buf
		);
		

		UART_RX : entity work.uart_recv
		port map
		(
			c1 => uart_clk,
			rx_sync => rx_sync_sig,
			--rx_sync => rx,
			char => char_in,
			send_flag => wrreq_uart_rf,
			rst_l => rst_l
		);
		
		DA_SAMPLER : entity work.UARTSampler
		port map
		(
			c0 => uart_samp_clk,
			c1 => uart_clk,
			rst_l => rst_l,
			rx => rx,
			rx_sync => rx_sync_sig
			
		);
		
	wrreq_uart_rf_final <= wrreq_uart_rf and not(wrfull_uart_rf);
	mult_out <= std_logic_vector(resize((
		 unsigned(std_logic_vector'(
			  std_logic_vector(data_in(28 downto 0)) & cat1
		 )) +
		 unsigned(std_logic_vector'(
			  std_logic_vector(data_in(30 downto 0)) & cat2
		 ))
	), 32));

		
	process(in_buff_empty, rst_l)
	begin
		if rst_l = '0' then
			rdreq_in_buf <= '0';
		elsif in_buff_empty = '0' then
			rdreq_in_buf <= '1';
		else
			rdreq_in_buf <= '0';
		end if;
	end process;
	
	
	-- begin state machine processes
	
	process (clk, rst_l)
	begin
		if rst_l = '0' then
			 state <= IDLE;
		elsif rising_edge(clk) then
			state <= next_state;
			data_in <= data_in_next;
			neg_flag <= next_neg_flag;
			rdreq_uart_rf_old <= rdreq_uart_rf;

		end if;
		
	end process;

	process(state, next_state, data_in, data_in_next, neg_flag, next_neg_flag, rdreq_uart_rf, wrreq_in_buf, wrreq_uart_rf_final, usedw_in_buf, q_char, mult_out, rdempty_uart_rf, full_in_buf)--fill in later
		begin
			next_state <= state;
			data_in_next <= data_in;
			rdreq_uart_rf <= '0';
			wrreq_in_buf <= '0';
			next_neg_flag <= neg_flag;
		case state is
		
		when IDLE =>
			data_in_next <= x"00000000";
			if rdempty_uart_rf = '1' then
				rdreq_uart_rf <= '0';
				next_state <= IDLE;
			else
				rdreq_uart_rf <= '1';
				next_state <= MULT;
			end if;
		
		when MULT =>
			if rdreq_uart_rf_old = '0' then
				if rdempty_uart_rf = '0' then
					rdreq_uart_rf <= '1';
				end if;
			else
				if q_char = x"0D" and full_in_buf = '0' then 
					next_state <= IDLE;
					wrreq_in_buf <= '1';
					if neg_flag = '1' then
						data_in_next <= std_logic_vector(unsigned(data_in XOR x"FFFFFFFF") + x"00000001");
					else
						data_in_next <= data_in;
					end if;
				elsif q_char = x"2D" and data_in = x"00000000" then
					next_state <= MULT;
					next_neg_flag <= '1';
					if rdempty_uart_rf = '0' then
						rdreq_uart_rf <= '1';
					else
						rdreq_uart_rf <= '0';
					end if;
				elsif q_char >= x"30" and q_char <= x"39" then
					data_in_next <= std_logic_vector(unsigned(mult_out) + (resize(unsigned(q_char),32) - x"00000030"));
					if rdempty_uart_rf = '0' then
						rdreq_uart_rf <= '1';
					else
						rdreq_uart_rf <= '0';
					end if;
					next_state <= MULT;
				else
					next_state <= MULT;
					if rdempty_uart_rf = '0' then
						rdreq_uart_rf <= '1';
					else
						rdreq_uart_rf <= '0';
					end if;
				end if;
			end if;
			
		when others =>
				next_state <= IDLE;
		end case;
		end process;

		
	end Behavioral;	


