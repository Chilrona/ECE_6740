library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity PREDICTOR is
    port 
    (
        clk : in std_logic;
		  rst_l : in std_logic;
        opcode_dec : in std_logic_vector(5 downto 0);
        pc_dec : in std_logic_vector(9 downto 0);
        opcode_mem : in std_logic_vector(5 downto 0);
        pc_mem : in std_logic_vector(9 downto 0);
		  branch_result : in std_logic;
        predict_branch : out std_logic
        
    );
                    
end entity PREDICTOR;
architecture BEHAVIORAL of PREDICTOR is

    type t_2bit_array is array (0 to 1023) of std_logic_vector(1 downto 0);

    signal branch_states : t_2bit_array := (others => "01");

begin

    process(opcode_dec, branch_states, pc_dec)
    begin
        if opcode_dec = BNEZ or opcode_dec = BEQZ then
            predict_branch <= branch_states(to_integer(unsigned(pc_dec)))(1);
        else
            predict_branch <= '0';
        end if;
    end process;

    process(clk, rst_l)
    begin
	     if rst_l = '0' then
			  branch_states <= (others => "01");
		  elsif rising_edge(clk) then
			
			  if opcode_mem = BNEZ or opcode_mem = BEQZ then
					if branch_result = '1' then
						 if branch_states(to_integer(unsigned(pc_mem))) < "11" then
							  branch_states(to_integer(unsigned(pc_mem))) <= std_logic_vector(unsigned(branch_states(to_integer(unsigned(pc_mem)))) + 1);
						 end if;
					elsif branch_result = '0' then
						 if branch_states(to_integer(unsigned(pc_mem))) > "00" then
							  branch_states(to_integer(unsigned(pc_mem))) <= std_logic_vector(unsigned(branch_states(to_integer(unsigned(pc_mem)))) - 1);
						 end if;
					end if;
			  end if;
			  
			end if;
    end process;


end BEHAVIORAL;
    