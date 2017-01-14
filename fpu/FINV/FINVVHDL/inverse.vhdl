library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity inverse is
  
  port (

    clk : in std_logic;
    SIG_A : in std_logic;
    EXP_A : in std_logic_vector(7 downto 0);
    FRA_A : in std_logic_vector(22 downto 0);
    DATA_A : in std_logic_vector(31 downto 0);
    DATA_B : in std_logic_vector(31 downto 0);

    SIG_INV : out std_logic;
    EXP_INV : out std_logic_vector(7 downto 0);
    FRA_INV : out std_logic_vector(22 downto 0));
    
   -- blockA : out std_logic_vector(31 downto 0));  --debug
  
end inverse;


architecture blackbox of inverse is

component fadd is
  
  port (
    clk   : in std_logic;
    UINTA : in std_logic_vector(31 downto 0);
    UINTB : in std_logic_vector(31 downto 0);
    ANSWER : out std_logic_vector(31 downto 0));
  
end component;

component fmul is
  
  port (
    clk   : in std_logic;
    FLOAT1 : in unsigned(31 downto 0);
    FLOAT2 : in unsigned(31 downto 0);
    ANS : out unsigned(31 downto 0));
  
end component;

signal mul_ans : unsigned(31 downto 0);
signal mul_ans_std : std_logic_vector(31 downto 0);
signal DATA_A_SIGN : unsigned(31 downto 0);
signal FRA_INV32 : std_logic_vector(31 downto 0);
signal FRA_A32 : unsigned(31 downto 0);

begin  -- blackbox

  add: fadd port map (
    clk    => clk,
    UINTA  => mul_ans_std,
    UINTB  => DATA_B,
    ANSWER => FRA_INV32);

  mul : fmul port map (
    clk    => clk,
    FLOAT1  => DATA_A_SIGN,
    FLOAT2  => FRA_A32,
    ANS => mul_ans);

 -- mul_ans_std<=std_logic_vector(mul_ans);
  FRA_A32<=unsigned("001111111" & FRA_A);
  DATA_A_SIGN<=unsigned("1" & DATA_A(30 downto 0));
  SIG_INV<=SIG_A;
  EXP_INV<=std_logic_vector(253-unsigned(EXP_A));
 -- FRA_INV<=FRA_INV32(22 downto 0);
 -- blockA<=DATA_B;                       --debug

  latch1: process(mul_ans)
  begin
    mul_ans_std<=std_logic_vector(mul_ans);

  end process latch1;

  latch2: process(FRA_INV32)
  begin
    FRA_INV<=FRA_INV32(22 downto 0);
  end process latch2;
  
  
  
end blackbox;
