entity memory is
port 
(
    rst_l : in std_logic;
    clk : in std_logic;

    instruction_in : in std_logic_vector(31 downto 0);
    instruction_out : out std_logic_vector(31 downto 0);

    q_2 : in std_logic_vector(31 downto 0);
    alu_result : in std_logic_vector(31 downto 0);
    ram_we : in std_logic_vector(31 downto 0);

    ram_data : out std_logic_vector(31 downto 0);
    alu_result_wb : out std_logic_vector(31 downto 0)
);

end entity memory;

architecture Behavioral of memory is
begin

RAM : entity work.my_ram
port map
(
    address	=> alu_result(9 downto 0),
    clock => clk,
    data => q_2,
    wren => ram_we,
    q => ram_data
); 

pass_along: process(clk, rst_l)
	 begin
		if rst_l = '0' then
			instruction_out <= (others=>'0');
		elsif rising_edge(clk) then
			instruction_out <= instruction_in;
		end if;
	end process;
end Behavioral
					