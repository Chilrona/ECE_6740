library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;


entity Zeros is
    port
    {
        rst_l : in std_logic;
		clk : in std_logic;
        --jump and branch ports
        jump_addr : out unsigned(9 downto 0);
		sel_jump : out std_logic;
        --address to jump to value
        q_1 : in std_logic_vector (31 DOWNTO 0)
    };
    end entity Zeros;

    architecture Behavioral of Zeros is


    begin


    process(clk)
    begin
         if rst_l = '0' then
            jump_addr <= (others => '0');
            sel_jump

        elsif rising_edge(clk) then


        end if;
    end Behavioral;


