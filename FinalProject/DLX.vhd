library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

	entity DLX is
		port 
		(
			KEY : in std_logic_vector(1 downto 0);
			ADC_CLK_10 : in std_logic;
			MAX10_CLK1_50 : in std_logic;
			MAX10_CLK2_50 : in std_logic;
			GPIO : inout std_logic_vector(35 downto 0);
			HEX0 : out unsigned(7 downto 0);
			HEX1 : out unsigned(7 downto 0);
			HEX2 : out unsigned(7 downto 0);
			HEX3 : out unsigned(7 downto 0);
			HEX4 : out unsigned(7 downto 0);
			HEX5 : out unsigned(7 downto 0);
			LEDR : out std_logic_vector(9 downto 0)
		);
						
	end entity DLX;	
					
	architecture Behavioral of DLX is  

		--clk and rst signals
		signal clk : std_logic;
		signal rst_l : std_logic;
		signal uart_clk : std_logic;
		signal uart_samp_clk : std_logic;
		
		signal pc_decode : std_logic_vector(9 downto 0);
		signal pc_execute : std_logic_vector(9 downto 0);
		
		signal instruction_decode : std_logic_vector(31 downto 0);
		signal instruction_execute : std_logic_vector(31 downto 0);
		signal instruction_mem : std_logic_vector(31 downto 0);
		signal instruction_wb : std_logic_vector(31 downto 0);
		
		signal q_1 : std_logic_vector (31 DOWNTO 0) := (others=>'0');
      signal q_2 : std_logic_vector(31 downto 0) := (others=>'0');
		signal q_2_mem : std_logic_vector(31 downto 0) := (others=>'0');
		signal op1 : std_logic_vector(31 downto 0);
		
		signal imm_extended : std_logic_vector(31 downto 0);
		signal jump_addr_final : std_logic_vector(9 downto 0);
		signal branch_addr : std_logic_vector(9 downto 0);
      signal jump_addr : std_logic_vector(9 downto 0);
		signal take_jump : std_logic;
		signal sel_jump : std_logic;
		signal take_branch : std_logic;
		
		
		signal alu_result : std_logic_vector(31 downto 0);
		signal alu_result_wb : std_logic_vector(31 downto 0);
		
		signal ram_data : std_logic_vector(31 downto 0);
		signal reg_data : std_logic_vector (31 downto 0);
		
		signal wr_addr : std_logic_vector(4 downto 0 );

		--write enable signals
		signal reg_we : std_logic;
		signal ram_we : std_logic;
		signal stall : std_logic;

		signal stall_final : std_logic;
		
		--the flushes
		signal flush_fetch : std_logic;
		signal flush_decode : std_logic;
		signal flush_execute :std_logic;

		signal flush_decode_final : std_logic;

		-- print signals
		signal print_stall : std_logic;
		signal print_flush_decode : std_logic;
		-- signal tx : std_logic;
		
		-- scan signals
		signal got_data : std_logic_vector(31 downto 0);
		signal in_buf_empty : std_logic;
		
		--pll signals
		signal areset		: STD_LOGIC := '0';
		signal c0		: STD_LOGIC :='0'; --153600 Hz
		signal c1		: STD_LOGIC :='0'; --115.2 kHz 
		signal locked : std_logic;
		
		--lil timmy
		signal Time_rst : std_logic;
		signal enable_time : std_logic;

		signal testbench : std_logic := '0';
	
	begin
	--testbench muxes to make life easier
	testbench <= '0';
	rst_l <= (KEY(0) and locked) when testbench = '0' else KEY(0);
	uart_clk <= c1 when testbench = '0' else clk;
	uart_samp_clk <= c0 when testbench = '0' else clk;
	
	--setting up the clk and rst and tx
	--rst_l <= KEY(0) and locked;
	--rst_l <= KEY(0);
	clk <= MAX10_CLK1_50;
	areset <= not (KEY(0));
	
	FETCH: entity work.fetch 
	port map
	(
		rst_l => rst_l,
		clk => clk,
      jump_addr => jump_addr_final,
      sel_jump => sel_jump,
		tag_for_flush => flush_fetch,
		stall => stall_final,
      pc => pc_decode,
      instruction => instruction_decode
	);

    DECODE: entity work.decode
	port map
	(
		rst_l => rst_l,
      clk => clk,
      data => reg_data,
      instruction_in => instruction_decode,
		instruction_out => instruction_execute,
		tag_for_flush => flush_decode_final,
		pc_in => pc_decode,
		pc_out => pc_execute,
		we => reg_we,
		wr_addr => wr_addr,
      q_1 => q_1,
      q_2 => q_2,
		imm_extended => imm_extended
	);

	EXECUTE: entity work.execute
	port map
	(
		rst_l => rst_l,
		clk => clk,
		q_1 => q_1,
		q_2 => q_2,
		imm_extended => imm_extended,
		pc_in => pc_execute,
		instruction_in => instruction_execute,
		instruction_in_wb => instruction_wb,
		got_data => got_data,
		reg_data => reg_data,
		tag_for_flush => flush_execute,
		instruction_out => instruction_mem,
		alu_result => alu_result,
		branch_addr => branch_addr,
		take_branch => take_branch,
		ram_we => ram_we,
		q_2_out => q_2_mem,
		op1_out => op1,
		Time_rst => Time_rst,
		enable_time => enable_time
	);
	MEMORY: entity work.memory
	port map
	(
		rst_l => rst_l,
		clk => clk,
		instruction_in => instruction_mem,
		instruction_out => instruction_wb,
		q_2 => q_2_mem,
		alu_result => alu_result,
		ram_we => ram_we,
		ram_data => ram_data,
		alu_result_wb => alu_result_wb
	);

	WB : entity work.write_back
	port map
	(
        instruction_wb => instruction_wb,
        ram_data => ram_data,
        alu_result_wb => alu_result_wb,
        wr_addr => wr_addr,
        reg_data => reg_data,
        reg_we => reg_we
	);
	
	
	OOO : entity work.OVERSEER 
    port map
    (
        clk => clk,

        instruction_decode => instruction_decode,
        instruction_execute => instruction_execute,
        instruction_wb => instruction_wb,

        take_branch => take_branch,
		  in_buf_empty => in_buf_empty,

        flush_fetch => flush_fetch,
        flush_decode => flush_decode,
        flush_execute => flush_execute,

        take_jump => take_jump,
        jump_addr => jump_addr,

        stall => stall
    );
	 
	 FSM: entity work.print_FSM
		port map
		(
         rst_l => rst_l,
         clk => clk,
			opcode_FSM => instruction_mem(31 downto 26),
			op1 => op1,
			print_stall => print_stall,
			print_flush_decode => print_flush_decode,
			tx => GPIO(1), 
			uart_clk => uart_clk,
			--uart_clk => c1
			--uart_clk => clk
			LEDR => LEDR
		);
		 
		SCAN : entity work.scan_FSM
		port map 
		(
         rst_l => rst_l,
         clk => clk,
			uart_clk => uart_clk,
			uart_samp_clk => uart_samp_clk,
			--uart_clk =>  c1, --115.2kHz
			--uart_clk => clk,
			--uart_samp_clk => c0, --921.6 kHz
			--uart_samp_clk => clk,
         opcode_scan => instruction_decode(31 downto 26),
			flush_decode => flush_decode,
			rx => GPIO(0),

			data_out => got_data,
			in_buff_empty => in_buf_empty
		);
		
		
		PLLTX: entity work.pll 
		PORT MAP
		(
			areset=> areset,
			inclk0=>MAX10_CLK1_50,
			c0=>c0,
			c1=>c1,
			locked=>locked
		);
		
		TIM: 	entity work.Timer 
		port map
		(
				Time_rst => Time_rst,
				enable_time => enable_time,
				MAX10_CLK1_50 => MAX10_CLK1_50,
				rst_l => rst_l,
				HEX0=>HEX0,
				HEX1=>HEX1,
				HEX2=>HEX2,
				HEX3=>HEX3,
				HEX4=>HEX4,
				HEX5=>HEX5
		);
						

	
	 
	 stall_final <= stall or print_stall;
	 flush_decode_final <= flush_decode or print_flush_decode; 
	
	 jump_addr_final <= branch_addr when take_jump = '0' else jump_addr;
	 sel_jump <= take_branch or take_jump;	 
	

				
	end Behavioral;