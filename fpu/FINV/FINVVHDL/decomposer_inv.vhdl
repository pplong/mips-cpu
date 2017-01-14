library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decomposer_inv is
  
  port (
    clk   : in  std_logic;
    UINTA : in  std_logic_vector(31 downto 0);

    SIG_A : out std_logic;
    EXP_A : out std_logic_vector(7 downto 0);
    FRA_A : out std_logic_vector(22 downto 0);
    INDEX : out std_logic_vector(9 downto 0));
  
end decomposer_inv;


architecture blackbox of decomposer_inv is

begin  -- blackbox

  SIG_A<=UINTA(31);
  EXP_A<=UINTA(30 downto 23);
  FRA_A<=UINTA(22 downto 0);
  INDEX<=UINTA(22 downto 13);
  
end blackbox;
