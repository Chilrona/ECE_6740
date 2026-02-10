library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity sign_extend is  
    port
    (
        rst_l : in std_logic;
        clk : in std_logic;
        opcode : in std_logic_vector(5 downto 0);
        imm : in unsigned(15 downto 0);
        imm_extended : out unsigned(31 downto 0)
    );
end entity;

architecture Behavioral of sign_extend is

begin
    process (clk, rst_l)
    begin
        if (rst_l = '0') then
            imm_extended <= (others=>'0');
        elsif rising_edge(clk) then
            
            imm_extended(15 downto 0) <= imm;
            
            if (imm(15) = '1' and is_signed_imm(opcode)) then
                imm_extended(31 downto 16) <= (others=>'1');
            else
                imm_extended(31 downto 16) <= (others=>'0');
            end if;
        end if;
    end process;
end Behavioral;