--引数の大小並び替え
--符号部、指数部、仮数部に分解
--仮数部は28に拡張、指数部は9に拡張

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.fadd_lib.all;

entity decomposer is
  
  port (

    clk : in std_logic;
    UINTA : in std_logic_vector(31 downto 0);
    UINTB : in std_logic_vector(31 downto 0);

    SIG_A : out SIG;                    --Aのほうが大きくなるように
    EXP_A : out EXP;
    FRA_A : out FRA;
    SIG_B : out SIG;
    EXP_B : out EXP;
    FRA_B : out FRA);
    
end decomposer;

architecture blackbox of decomposer is


  signal BIG : std_logic_vector(31 downto 0);
  signal SMALL : std_logic_vector(31 downto 0);
  
begin  -- blackbox

  BIG<=UINTA when UINTA(30 downto 0)>UINTB(30 downto 0)
        else
        UINTB;
  SMALL<=UINTB when UINTA(30 downto 0)>UINTB(30 downto 0)
          else
          UINTA;

  SIG_A<=BIG(31);
  EXP_A<='0' & BIG(30 downto 23);
  FRA_A<=x"0000000" when BIG(30 downto 23)=0
          else
          "01" & BIG(22 downto 0) & "000";
  SIG_B<=SMALL(31);
  EXP_B<='0' & SMALL(30 downto 23);
  FRA_B<=x"0000000" when SMALL(30 downto 23)=0
          else
          "01" & SMALL(22 downto 0) & "000";
  

end blackbox;

