library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.fadd_lib.all;

entity fadd2 is
  
  port (
    clk : in std_logic;
    NAN : in std_logic;
    INFP : in std_logic;
    INFN : in std_logic;
    SIG_ADD : in SIG;
    EXP_ADD : in EXP;
    FRA_ADD : in FRA;

    ANSWER : out std_logic_vector(31 downto 0));
    
    
end fadd2;

architecture blackbox of fadd2 is



  component normalize is
    
    port (

      SIG_ADD : in SIG;
      EXP_ADD : in EXP;
      FRA_ADD : in FRA;

      SIG_NOR : out SIG;
      EXP_NOR : out EXP;
      FRA_NOR : out FRA);
    
  end component;

  signal sSIG_NOR : SIG;
  signal sEXP_NOR : EXP;
  signal sFRA_NOR : FRA;

  component rounding_fadd is
    
    port (

      SIG_NOR : in SIG;
      EXP_NOR : in EXP;
      FRA_NOR : in FRA;

      SIG_ROU : out SIG;
      EXP_ROU : out EXP;
      FRA_ROU : out FRA);
    
  end component;

  signal sSIG_ROU : SIG;
  signal sEXP_ROU : EXP;
  signal sFRA_ROU : FRA;

  component result is
    
    port (
      
      SIG_ROU : in SIG;
      EXP_ROU : in EXP;
      FRA_ROU : in FRA;
      NAN : in std_logic;
      INFP : in std_logic;
      INFN : in std_logic;

      ANSWER : out std_logic_vector(31 downto 0));
    
  end component;

begin  -- blackbox

  
norm: normalize port map (
    SIG_ADD=>SIG_ADD,
    EXP_ADD=>EXP_ADD,
    FRA_ADD=>FRA_ADD,
    SIG_NOR=>sSIG_NOR,
    EXP_NOR=>sEXP_NOR,
    FRA_NOR=>sFRA_NOR);

round: rounding_fadd port map (
    SIG_NOR=>sSIG_NOR,
    EXP_NOR=>sEXP_NOR,
    FRA_NOR=>sFRA_NOR,
    SIG_ROU=>sSIG_ROU,
    EXP_ROU=>sEXP_ROU,
    FRA_ROU=>sFRA_ROU);

res: result port map (
    SIG_ROU=>sSIG_ROU,
    EXP_ROU=>sEXP_ROU,
    FRA_ROU=>sFRA_ROU,
    NAN=>NAN,
    INFP=>INFP,
    INFN=>INFN,
    ANSWER=>ANSWER);

end blackbox;

