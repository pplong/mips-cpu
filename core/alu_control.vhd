library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity alu_control is
  port (
    opcode : in std_logic_vector (5 downto 0);
    funct : in std_logic_vector (5 downto 0);

    op : out std_logic_vector (3 downto 0)
  );
end alu_control;

architecture Behavioral of alu_control is
begin
  control: process(opcode, funct)
    variable alu_op : std_logic_vector (1 downto 0);
  begin
    case opcode is
      when "100011" | "101011" | "110001" | "111001" | "110010" | "100100" =>
        alu_op := "00";
      when "000100" | "000101" =>
        alu_op := "01";
      when "010010" => -- FP compare 
        alu_op := "11";
      when others =>
        alu_op := "10";
    end case;

    case alu_op is
      when "00" =>
        op <= "0010";
      when "01" =>
        op <= "0110";
      when "10" =>
        if opcode = "000000" then
          case funct is
            when "100000" => op <= "0010"; -- add
            when "100010" => op <= "0110"; -- sub
            when "100100" => op <= "0000"; -- and
            when "100101" => op <= "0001"; -- or
            when "101010" => op <= "0111"; -- slt
            when "000000" => op <= "1000"; -- sll
            when "000010" => op <= "1001"; -- srl
            when "011000" => op <= "0011"; -- mult
            when "011010" => op <= "0100"; -- div
            when "011011" => op <= "0101"; -- rem
            when others => op <= "0000";
          end case;
        else 
          case opcode is
            when "001000" => op <= "0010"; -- add imm.
            when others => op <= "0000";
          end case;
        end if;
      when "11" =>
        if funct = "000000" then
          op <= "----"; -- fslt
        else 
          op <= "0110"; -- feq
        end if;
      when others =>
        op <= "0000";
    end case;
  end process;
end Behavioral;
