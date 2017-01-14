library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.fadd_lib.all;

entity fadd1 is
  
  port (
    clk   : in std_logic;
    UINTA : in std_logic_vector(31 downto 0);
    UINTB : in std_logic_vector(31 downto 0);

    NAN : out std_logic;
    INFP : out std_logic;
    INFN : out std_logic;
    SIG_ADD : out SIG;
    EXP_ADD : out EXP;
    FRA_ADD : out FRA);

end fadd1;

architecture blackbox of fadd1 is

component decomposer is
    
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
    
  end component;

  signal sSIG_A : SIG;
  signal sEXP_A : EXP;
  signal sFRA_A : FRA;
  signal sSIG_B : SIG;
  signal sEXP_B : EXP;
  signal sFRA_B : FRA;

  component exceptional is
    
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
    
  end component;

  signal sNAN : std_logic;
  signal sINFP : std_logic;
  signal sINFN : std_logic;

  component align is
    
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
    
  end component;

signal sSIG_A_ALI : SIG;
signal sEXP_A_ALI : EXP;
signal sFRA_A_ALI : FRA;
signal sSIG_B_ALI : SIG;
signal sEXP_B_ALI : EXP;
signal sFRA_B_ALI : FRA;
signal sSTICKY : std_logic;

component adder is
  
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

end component;

signal a,b : std_logic_vector(31 downto 0);
signal sign : SIG;
signal exponent : EXP;
signal fraction : FRA;
signal exc_snan : std_logic;
signal exc_sinfp : std_logic;
signal exc_sinfn : std_logic;

begin  -- blackbox

  decomp:  decomposer port map (
    clk=>clk,
    UINTA=>a,
    UINTB=>b,
    SIG_A=>sSIG_A,
    EXP_A=>sEXP_A,
    FRA_A=>sFRA_A,
    SIG_B=>sSIG_B,
    EXP_B=>sEXP_B,
    FRA_B=>sFRA_B);

  exc:  exceptional port map (
    SIG_A=>sSIG_A,
    EXP_A=>sEXP_A,
    FRA_A=>sFRA_A,
    SIG_B=>sSIG_B,
    EXP_B=>sEXP_B,
    FRA_B=>sFRA_B,
    NAN=>exc_snan,
    INFP=>exc_sinfp,
    INFN=>exc_sinfn);

  algn: align port map (
    SIG_A=>sSIG_A,
    EXP_A=>sEXP_A,
    FRA_A=>sFRA_A,
    SIG_B=>sSIG_B,
    EXP_B=>sEXP_B,
    FRA_B=>sFRA_B,
    SIG_A_ALI=>sSIG_A_ALI,
    EXP_A_ALI=>sEXP_A_ALI,
    FRA_A_ALI=>sFRA_A_ALI,
    SIG_B_ALI=>sSIG_B_ALI,
    EXP_B_ALI=>sEXP_B_ALI,
    FRA_B_ALI=>sFRA_B_ALI,
    STICKY=>sSTICKY);

  add: adder port map (
    SIG_A_ALI=>sSIG_A_ALI,
    EXP_A_ALI=>sEXP_A_ALI,
    FRA_A_ALI=>sFRA_A_ALI,
    SIG_B_ALI=>sSIG_B_ALI,
    EXP_B_ALI=>sEXP_B_ALI,
    FRA_B_ALI=>sFRA_B_ALI,
    STICKY=>sSTICKY,
    SIG_ADD=>sign,
    EXP_ADD=>exponent,
    FRA_ADD=>fraction);

  latch: process (clk)
  begin  -- process latch
    if rising_edge(clk) then
      SIG_ADD<=sign;
      EXP_ADD<=exponent;
      FRA_ADD<=fraction;
      a<=UINTA;
      b<=UINTB;
      NAN<=exc_snan;
      INFP<=exc_sinfp;
      INFN<=exc_sinfn;
      
    end if;
  end process latch;

end blackbox;
