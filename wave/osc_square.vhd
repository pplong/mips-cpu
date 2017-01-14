library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity osc_square is
  port (
    clk : in std_logic;
    
    -- t_half には周期の半分に相当するクロックカウントを入れる
    t_half : in unsigned(19 downto 0);

    wave : out WAV
  );
end osc_square;

architecture blackbox of osc_square is
  signal counter : unsigned(19 downto 0) := "11010011010110101100";
  signal phase : std_logic := '0';
begin
  osc: process(clk)
  begin
    if rising_edge(clk) then
      if counter = t_half then
        counter <= (others => '0');
        phase <= not phase;
      else 
        counter <= counter + 1;
      end if;
    end if;
  end process;
  wave <= (others => phase);
end blackbox;
