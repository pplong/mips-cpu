library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prescaler is
  port (
    clk : in std_logic;
    iclk : out std_logic
  );
end prescaler;

architecture blackbox of prescaler is
  signal cnt : unsigned(5 downto 0) := "000000";
begin
  proc: process(clk) begin
    if rising_edge(clk) then
      cnt <= cnt + 1;
    end if;
  end process;
  iclk <= cnt(5);
end blackbox;
