--小さい方の指数を大きい方に合わせる
library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.fadd_lib.all;

entity align is
  
  port (

    SIG_A : in SIG;
    EXP_A : in EXP;
    FRA_A : in FRA;
    SIG_B : in SIG;
    EXP_B : in EXP;
    FRA_B : in FRA;

    SIG_A_ALI : out SIG;
    EXP_A_ALI : out EXP;
    FRA_A_ALI : out FRA;
    SIG_B_ALI : out SIG;
    EXP_B_ALI : out EXP;
    FRA_B_ALI : out FRA;
    STICKY : out std_logic);
    
end align;

architecture blackbox of align is
  
begin  -- blackbox

  SIG_A_ALI<=SIG_A;
  EXP_A_ALI<=EXP_A;
  FRA_A_ALI<=FRA_A;
  SIG_B_ALI<=SIG_B;

  -- purpose: 仮数部調整のループ文のために
  align: process (EXP_A,EXP_B,FRA_B)

    variable FRA_LOOP : FRA;
    variable EXP_LOOP : EXP;
    variable STICKY_LOOP : std_logic;
    variable diff : unsigned(8 downto 0);
  begin  -- process align
    FRA_LOOP :=FRA_B;
    EXP_LOOP := EXP_B;
    STICKY_LOOP := '0';
    diff := unsigned(EXP_A)-unsigned(EXP_B);
  
    for i in 0 to 25 loop
      next when diff = 0;
      FRA_LOOP := '0' & FRA_LOOP(27 downto 1);
      STICKY_LOOP := STICKY_LOOP or FRA_LOOP(0);
      diff := diff - 1;
      EXP_LOOP := EXP_LOOP + 1;
    end loop;  -- i 
    
    EXP_B_ALI<=EXP_LOOP;
    FRA_B_ALI<=FRA_LOOP;
    STICKY<=STICKY_LOOP;
    
  end process align;

end blackbox;
