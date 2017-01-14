library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.fadd_lib.all;

entity result is
  
  port (
    
    SIG_ROU : in SIG;
    EXP_ROU : in EXP;
    FRA_ROU : in FRA;
    NAN : in std_logic;
    INFP : in std_logic;
    INFN : in std_logic;

    ANSWER : out std_logic_vector(31 downto 0));
  
end result;

architecture blackbox of result is

begin  -- blackbox
  ANSWER <= "11111111111100000000000000000000" when NAN='1' else
            "01111111100000000000000000000000" when INFP='1' else
            "11111111100000000000000000000000" when INFN='1' else
            SIG_ROU & EXP_ROU(7 downto 0) & FRA_ROU(25 downto 3);
  

end blackbox;
