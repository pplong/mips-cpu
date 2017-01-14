library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity alu is
  port (
    data_in1 : in WORD;
    data_in2 : in WORD;
    data_out : out WORD;
    zero : out std_logic;

    op : in std_logic_vector(3 downto 0)
  );
end alu;

architecture Behavioral of alu is
  signal result : WORD;
begin
  calc: process(data_in1, data_in2, op)
    variable res, sub : WORD;
  begin
    case op is
      when "0000" =>
        res := data_in1 and data_in2;
      when "0001" =>
        res := data_in1 or data_in2;
      when "0010" =>
        res := std_logic_vector(signed(data_in1) + signed(data_in2));
      when "0110" =>
        res := std_logic_vector(signed(data_in1) - signed(data_in2));
      when "0111" =>
        res := (others => '0');
        if data_in1(31) /= data_in2(31) then
          res(0) := data_in1(31);
        else
          sub := std_logic_vector(signed(data_in1) - signed(data_in2));
          res(0) := sub(31);
        end if;
--        if signed(data_in1) < signed(data_in2) then
--          res := (0 => '1', others => '0');
--        else
--          res := (others => '0');
--        end if;
      when "1000" =>
        res := std_logic_vector(shift_left(unsigned(data_in1), to_integer(unsigned(data_in2))));
      when "1001" =>
        res := std_logic_vector(shift_right(unsigned(data_in1), to_integer(unsigned(data_in2))));
--      when "1100" =>
--        res := data_in1 nor data_in2;
      when others =>
        res := (others => '-');
    end case;

    result <= res;
  end process;

  data_out <= result;
  zero <= '1' when (result = (31 downto 0 => '0')) else '0';
end Behavioral;
