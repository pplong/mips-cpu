library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.fadd_lib.all;

entity adder is
  
  port (

    SIG_A_ALI : in SIG;
    EXP_A_ALI : in EXP;
    FRA_A_ALI : in FRA;
    SIG_B_ALI : in SIG;
    EXP_B_ALI : in EXP;
    FRA_B_ALI : in FRA;
    STICKY : in std_logic;

    SIG_ADD : out SIG;
    EXP_ADD : out EXP;
    FRA_ADD : out FRA);
    
end adder;

architecture blackbox of adder is

begin  -- blackbox

  SIG_ADD<=SIG_A_ALI;
  EXP_ADD<=EXP_A_ALI;
  FRA_ADD<=unsigned(FRA_A_ALI)+unsigned(FRA_B_ALI)
            when SIG_A_ALI=SIG_B_ALI and STICKY='0'
            else unsigned(FRA_A_ALI)+unsigned(FRA_B_ALI(27 downto 1)&'1')
            when SIG_A_ALI=SIG_B_ALI
            else unsigned(FRA_A_ALI)-unsigned(FRA_B_ALI)
            when STICKY='0'
            else unsigned(FRA_A_ALI)-unsigned(FRA_B_ALI(27 downto 1)&'1');

end blackbox;
