library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.fadd_lib.all;

entity fadd is
  
  port (
    clk   : in std_logic;
    UINTA : in std_logic_vector(31 downto 0);
    UINTB : in std_logic_vector(31 downto 0);
    ANSWER : out std_logic_vector(31 downto 0));
  
end fadd;

architecture blackbox of fadd is


 component  fadd1 is
  
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

end component;

signal sNAN : std_logic;
signal sINFP : std_logic;
signal sINFN : std_logic;
signal sSIG_ADD : SIG;
signal sEXP_ADD : EXP;
signal sFRA_ADD : FRA;

component fadd2 is
  
  port (
    clk : in std_logic;
    NAN : in std_logic;
    INFP : in std_logic;
    INFN : in std_logic;
    SIG_ADD : in SIG;
    EXP_ADD : in EXP;
    FRA_ADD : in FRA;

    ANSWER : out std_logic_vector(31 downto 0));
    
    
end component;

signal ANSWER_latched : std_logic_vector (31 downto 0);

begin  -- blackbox

  faddfisrt: fadd1 port map (
    clk=>clk,
    UINTA=>UINTA,
    UINTB=>UINTB,
    NAN=>sNAN,
    INFP=>sINFP,
    INFN=>sINFN,
    SIG_ADD=>sSIG_ADD,
    EXP_ADD=>sEXP_ADD,
    FRA_ADD=>sFRA_ADD);

  faddsecond: fadd2 port map (
    clk=>clk,
    NAN=>sNAN,
    INFP=>sINFP,
    INFN=>sINFN,
    SIG_ADD=>sSIG_ADD,
    EXP_ADD=>sEXP_ADD,
    FRA_ADD=>sFRA_ADD,
    ANSWER=>ANSWER_latched);

  latch: process (clk)
  begin
    if rising_edge(clk) then
      ANSWER <= ANSWER_latched;
    end if;
  end process;

end blackbox;
