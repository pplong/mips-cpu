library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity exception_inv is
  
  port (
    SIG_A : in  std_logic;
    EXP_A : in  std_logic_vector(7 downto 0);
    FRA_A : in  std_logic_vector(22 downto 0);
    NAN   : out std_logic;
    INF   : out std_logic;
    ZERO  : out std_logic);

end exception_inv;

architecture blackbox of exception_inv is

begin  -- blackbox

  NAN<='1' when
    EXP_A=x"ff" and unsigned(FRA_A)/=0
    else '0';
  INF<='1' when
    EXP_A=x"00"
    else '0';
  ZERO<='1' when
    (EXP_A=x"ff" and unsigned(FRA_A)=0) or
    (EXP_A=x"fe") or
    (EXP_A=x"fd")
    else '0';

end blackbox;
