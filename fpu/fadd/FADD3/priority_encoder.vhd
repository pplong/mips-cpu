library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fadd_lib.all;

entity priority_encoder is
  port (
    i : in FRA;
    o : out unsigned(4 downto 0)
  );
end priority_encoder;

architecture blackbox of priority_encoder is

begin  -- blackbox
  
  o <= "00000" when i(27) = '1' else
       "00000" when i(26) = '1' else
       "00001" when i(25) = '1' else
       "00010" when i(24) = '1' else
       "00011" when i(23) = '1' else
       "00100" when i(22) = '1' else
       "00101" when i(21) = '1' else
       "00110" when i(20) = '1' else
       "00111" when i(19) = '1' else
       "01000" when i(18) = '1' else
       "01001" when i(17) = '1' else
       "01010" when i(16) = '1' else
       "01011" when i(15) = '1' else
       "01100" when i(14) = '1' else
       "01101" when i(13) = '1' else
       "01110" when i(12) = '1' else
       "01111" when i(11) = '1' else
       "10000" when i(10) = '1' else
       "10001" when i(9) = '1' else
       "10010" when i(8) = '1' else
       "10011" when i(7) = '1' else
       "10100" when i(6) = '1' else
       "10101" when i(5) = '1' else
       "10110" when i(4) = '1' else
       "10111" when i(3) = '1' else
       "11000" when i(2) = '1' else
       "11001" when i(1) = '1' else
       "11010" when i(0) = '1' else
       "XXXXX";

end blackbox;
