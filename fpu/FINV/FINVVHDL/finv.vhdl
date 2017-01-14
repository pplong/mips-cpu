library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity finv is
  
  port (
    clk : in std_logic;
    UINTA : in std_logic_vector(31 downto 0);
    ANSWER : out std_logic_vector(31 downto 0));

end finv;

architecture blackbox of finv is

  component decomposer_inv is
  
  port (
    clk   : in  std_logic;
    UINTA : in  std_logic_vector(31 downto 0);

    SIG_A : out std_logic;
    EXP_A : out std_logic_vector(7 downto 0);
    FRA_A : out std_logic_vector(22 downto 0);
    INDEX : out std_logic_vector(9 downto 0));
  
end component;

signal sSIG_A : std_logic;
signal sEXP_A : std_logic_vector(7 downto 0);
signal sFRA_A : std_logic_vector(22 downto 0);
signal sINDEX : std_logic_vector(9 downto 0);

component exception_inv is
  
  port (
    SIG_A : in  std_logic;
    EXP_A : in  std_logic_vector(7 downto 0);
    FRA_A : in  std_logic_vector(22 downto 0);
    NAN   : out std_logic;
    INF   : out std_logic;
    ZERO  : out std_logic);

end component;

signal sNAN : std_logic;
signal sINF : std_logic;
signal sZERO : std_logic;

component inverse is
  
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
 --   blockA : out std_logic_vector(31 downto 0));  --debug
    
end component;

signal sSIG_INV : std_logic;
signal sEXP_INV : std_logic_vector(7 downto 0);
signal sFRA_INV : std_logic_vector(22 downto 0);
--signal sblockA : std_logic_vector(31 downto 0);  --debug

component blockram_a is

  port(CLK : in std_logic;
       WR : in std_logic;
       ADDR : in std_logic_vector(9 downto 0);
       DIN : in std_logic_vector(31 downto 0);
       DOUT : out std_logic_vector(31 downto 0));
end component;

signal sDOUTa : std_logic_vector(31 downto 0);

component blockram_b is

  port(CLK : in std_logic;
       WR : in std_logic;
       ADDR : in std_logic_vector(9 downto 0);
       DIN : in std_logic_vector(31 downto 0);
       DOUT : out std_logic_vector(31 downto 0));
end component;

signal sDOUTb : std_logic_vector(31 downto 0);

component result_inv is
  
  port (
    SIG_INV : in std_logic;
    EXP_INV : in std_logic_vector(7 downto 0);
    FRA_INV : in std_logic_vector(22 downto 0);
 --   blockA : in std_logic_vector(31 downto 0);  --debug
    NAN     : in std_logic;
    INF     : in std_logic;
    ZERO    : in std_logic;

    ANSWER  : out std_logic_vector(31 downto 0));
    
end component;

signal zeroconst : std_logic := '0';
signal zerodata : std_logic_vector(31 downto 0) := x"00000000";

signal a : std_logic_vector(31 downto 0);
signal ans : std_logic_vector(31 downto 0);

begin  -- blackbox

  decomp: decomposer_inv port map (
    clk=>clk,
    UINTA=>a,
    SIG_A=>sSIG_A,
    EXP_A=>sEXP_A,
    FRA_A=>sFRA_A,
    INDEX=>sINDEX);

  excep : exception_inv port map (
    SIG_A => sSIG_A,
    EXP_A => sEXP_A,
    FRA_A => sFRA_A,
    NAN   => sNAN,
    INF   => sINF,
    ZERO  => sZERO);

  inv : inverse port map (
    clk     => clk,
    SIG_A   => sSIG_A,
    EXP_A   => sEXP_A,
    FRA_A   => sFRA_A,
    DATA_A  => sDOUTa,
    DATA_B  => sDOUTb,
    SIG_INV => sSIG_INV,
    EXP_INV => sEXP_INV,
    FRA_INV => sFRA_INV);
--    blockA => sblockA);                 --debug

  blocka : blockram_a port map (
    clk=>clk,
    WR=>zeroconst,
    ADDR=>sINDEX,
    DIN=>zerodata,
    DOUT=>sDOUTa);

  blockb : blockram_b port map (
    clk  => clk,
    WR   => zeroconst,
    ADDR => sINDEX,
    DIN  => zerodata,
    DOUT => sDOUTb);

  resul : result_inv port map (
    SIG_INV => sSIG_INV,
    EXP_INV => sEXP_INV,
    FRA_INV => sFRA_INV,
--    blockA=>sblockA,                    --debug
    NAN     => sNAN,
    INF     => sINF,
    ZERO    => sZERO,
    ANSWER  => ans);

  latch :process(clk)
  begin
    if rising_edge(clk) then
      a<=UINTA;
      ANSWER<=ans;
    end if;
  end process latch;


end blackbox;
