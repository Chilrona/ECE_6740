library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.opcode_package.all;

entity write_back is
    port
    (
        instruction_wb : in std_logic_vector(31 downto 0);

        ram_data : in std_logic_vector(31 downto 0);
        alu_result_wb : in std_logic_vector(31 downto 0);

        wr_addr : out std_logic_vector(4 downto 0);
        reg_data : out std_logic_vector(31 downto 0);
        reg_we : out std_logic
    );
end entity write_back;

architecture Behavioral of write_back is
    begin

    process(instruction_wb)
    begin
        if instruction_wb(31 downto 26) = LW then
            reg_data <= ram_data;
        else
            reg_data <= alu_result_wb;
        end if;

        if (is_n_wb(instruction_wb(31 downto 26))) then
            reg_we <= '0';
        else
            reg_we <= '1';
        end if;

        if instruction_wb(31 downto 26) = JAL or instruction_wb(31 downto 26) = JALR then
            wr_addr <= "11111";
        else
            wr_addr <= instruction_wb(25 downto 21);
        end if;
    end process;

end Behavioral;