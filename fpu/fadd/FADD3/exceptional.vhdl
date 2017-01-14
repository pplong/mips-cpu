--例外のフラグたて
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.fadd_lib.all;

entity exceptional is
  
  port (

    SIG_A : in SIG;
    EXP_A : in EXP;
    FRA_A : in FRA;
    SIG_B : in SIG;
    EXP_B : in EXP;
    FRA_B : in FRA;

    NAN : out std_logic;
    INFP : out std_logic;
    INFN : out std_logic);
  
end exceptional;

architecture blackbox of exceptional is

begin  -- blackbox

  NAN<='1' when
        (EXP_A(7 downto 0)=x"ff" and FRA_A(25 downto 3)/=0) or
        (EXP_B(7 downto 0)=x"ff" and FRA_B(25 downto 3)/=0) or
        (EXP_A(7 downto 0)=x"ff" and EXP_B(7 downto 0)=x"ff" and SIG_A/=SIG_B)
        else '0';
  INFP<='1' when
         (EXP_A(7 downto 0)=x"ff" and SIG_A='0')
         else '0';
  INFN<='1' when
         EXP_A(7 downto 0)=x"ff"
         else '0';
         

end blackbox;
