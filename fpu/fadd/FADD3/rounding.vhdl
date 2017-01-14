library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.fadd_lib.all;

entity rounding_fadd is
  
  port (

    SIG_NOR : in SIG;
    EXP_NOR : in EXP;
    FRA_NOR : in FRA;

    SIG_ROU : out SIG;
    EXP_ROU : out EXP;
    FRA_ROU : out FRA);
    
end rounding_fadd;

architecture blackbox of rounding_fadd is

  signal FRA : FRA;
  
begin  -- blackbox

  FRA <= unsigned(FRA_NOR)+8
         when FRA_NOR(2)='1' and (FRA_NOR(3)='1' or FRA_NOR(1)='1' or FRA_NOR(0)='1')
         else FRA_NOR;
  FRA_ROU <= '0' & FRA(27 downto 1)
             when FRA(27)='1'
             else FRA;
  EXP_ROU <= unsigned(EXP_NOR) + 1
             when FRA(27)='1'
             else EXP_NOR;
  SIG_ROU <= SIG_NOR;

end blackbox;
