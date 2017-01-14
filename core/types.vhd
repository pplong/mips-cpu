library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types is
  subtype BYTE is std_logic_vector (7 downto 0);
  subtype WORD is std_logic_vector (31 downto 0);
  subtype REG is std_logic_vector (4 downto 0);
  subtype ADDR is std_logic_vector (19 downto 0);
  subtype BLKRAM_ADDR is std_logic_vector (14 downto 0);
  subtype WAV is std_logic_vector(11 downto 0);
  subtype COUNTER is unsigned(19 downto 0);
end types;

