library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity result_inv is
  
  port (
    SIG_INV : in std_logic;
    EXP_INV : in std_logic_vector(7 downto 0);
    FRA_INV : in std_logic_vector(22 downto 0);
  --  blockA: in std_logic_vector(31 downto 0);  --debug
    NAN     : in std_logic;
    INF     : in std_logic;
    ZERO    : in std_logic;

    ANSWER  : out std_logic_vector(31 downto 0));
    
end result_inv;


architecture blackbox of result_inv is

begin  -- blackbox

  ANSWER<=SIG_INV & "111" & x"fffffff" when NAN='1' else
           SIG_INV & "111" & x"f800000" when INF='1' else
           SIG_INV & "0000000000000000000000000000000" when ZERO='1' else
         SIG_INV & EXP_INV & FRA_INV;

--  ANSWER<=blockA;
  
end blackbox;
