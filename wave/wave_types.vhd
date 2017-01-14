library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package wave_types is
  subtype WAVE is std_logic_vector(11 downto 0);
  subtype COUNTER is unsigned(19 downto 0);
end wave_types;

