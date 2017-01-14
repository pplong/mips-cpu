library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity osc_saw is
  port (
    clk : in std_logic;
    
    -- t には周期に相当するクロックカウントを入れる
    t : in unsigned(19 downto 0);

    wave : out WAV
  );
end osc_saw;

architecture blackbox of osc_saw is
  signal counter : unsigned(19 downto 0) := "00101101010010110011";
  signal outwave : unsigned(11 downto 0) := (others => '0');
begin
  osc: process(clk)
    variable v : unsigned(19 downto 0);
  begin
    if rising_edge(clk) then
      v := counter + 4096;
      if v >= t then
        counter <= v - t;
        outwave <= outwave + 1;
      else 
        counter <= v;
      end if;
    end if;
  end process;
  wave <= std_logic_vector(outwave);
end blackbox;
