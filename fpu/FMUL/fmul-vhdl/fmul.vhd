library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fmul is

  Port(
    CLK : in std_logic;
    FLOAT1: in unsigned(31 downto 0); --第１引数
    FLOAT2: in unsigned(31 downto 0); --第２引数
    ANS: out unsigned(31 downto 0) -- 解答
    );

end fmul;

architecture Behavioral of fmul is
  --> giving it a thought theres no need to check over/underflow twice
  --> so decided to check it at the end of the circuit
  component exception
    Port(
      FLOAT1 : in unsigned(31 downto 0);
      FLOAT2 : in unsigned(31 downto 0);
      EXC_FLAG : out unsigned(3 downto 0)
      );
  end component;

  component multiplier
    Port (
      FLOAT1 : in unsigned(31 downto 0);
      FLOAT2 : in unsigned(31 downto 0);
      SIGN : out std_logic;
      EXP : out unsigned(8 downto 0); -- 1 bit lager in case of overflow
      FRCT : out unsigned(25 downto 0);
      STICKY : out std_logic
      );
  end component;

  component over_underflow
    Port(
      EXP_IN : in unsigned(8 downto 0);
      OVER_UNDER : out unsigned(1 downto 0)
      );
  end component;

  component fmul_rounding
    Port(
      FRCT : in unsigned(25 downto 0);
      EXP_IN : in unsigned(8 downto 0);
      STICKY_IN : in std_logic;
      ROUNDED : out unsigned(22 downto 0); -- ROUNDED MANTISSA
      EXP_OUT : out unsigned(8 downto 0)
      );
  end component;

  signal F1, F2 : unsigned(31 downto 0);
  signal TMPFLAG : unsigned(3 downto 0);
  signal SIGN : std_logic;
  signal EXP_OUT, EXP_IN : unsigned(8 downto 0);
  signal FRCT_OUT, FRCT_IN : unsigned(25 downto 0);
  signal OU : unsigned(1 downto 0);
  signal ROUNDED : unsigned(22 downto 0);
  signal EXP_ANS : unsigned(8 downto 0);
  signal S : std_logic;
  signal EXC_FLAG : unsigned(3 downto 0);
  signal TMP_ANS : unsigned(31 downto 0);
  signal TMP_STICKY : std_logic;
  signal STICKY_IN : std_logic;

  constant NAN : unsigned(31 downto 0)
    := x"ffffffff";
  constant INF : unsigned(31 downto 0)
    := x"7f800000";
  constant ZERO : unsigned(31 downto 0)
    := x"00000000";

begin

  EXEP :
    exception port map (FLOAT1 => F1,
                        FLOAT2 => F2,
                        EXC_FLAG => TMPFLAG); --> (signal) EXC_FLAG
  MULT :
    multiplier port map (FLOAT1 => F1,
                         FLOAT2 => F2,
                         SIGN => SIGN,
                         EXP => EXP_OUT, --> EXP_IN
                         FRCT => FRCT_OUT, --> FRCT_IN
                         STICKY => TMP_STICKY); -->　STICKY_IN
  ----------------------------------------------------------
  RND :
    fmul_rounding port map (FRCT => FRCT_IN,
                            EXP_IN => EXP_IN,
                            STICKY_IN => STICKY_IN,
                            ROUNDED => ROUNDED,
                            EXP_OUT => EXP_ANS
                            );
  OUFLOW :
    over_underflow port map (EXP_IN => EXP_ANS,
                             OVER_UNDER => OU
                             );

  TMP_ANS <= NAN when EXC_FLAG = "0001" -- NAN parameter
             else NAN when (EXC_FLAG = "1010") or (EXC_FLAG = "0110")
             else S & INF(30 downto 0) when EXC_FLAG = "0010"
             --^ INF parameter
             else ZERO(31 downto 0)
             when (EXC_FLAG = "0100") or (EXC_FLAG = "1000")
             --^ SUB NORM. or ZERO parameter
             else ZERO(31 downto 0) when OU = "01" -- underflow
             else S & INF(30 downto 0) when OU = "10" -- overflow
             else S & (EXP_ANS(7 downto 0) - 127) & ROUNDED;
  --^ finally normal solutions here!

  FLOW :
  process (clk)
  begin
    if rising_edge(clk) then
      F1 <= FLOAT1;
      F2 <= FLOAT2;
------------------------------
      S <= SIGN;
      EXC_FLAG <= TMPFLAG;
      FRCT_IN <= FRCT_OUT;
      EXP_IN <= EXP_OUT;
      STICKY_IN <= TMP_STICKY;
------------------------------
      ANS <= TMP_ANS;
    end if;
  end process FLOW;
end Behavioral;
