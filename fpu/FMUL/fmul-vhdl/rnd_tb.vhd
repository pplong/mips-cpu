library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rnd_tb is
end rnd_tb;

architecture TESTBENCH of rnd_tb is
  -- under construction from here on
  component rounding

    Port(
      FRCT : in unsigned(25 downto 0);
    --^ 23 mantissa + 3 GRS
      EXP_IN : in unsigned(8 downto 0);
    --^ if it is (8 downto 0) then it went to overflow exc.
      STICKY_IN : in std_logic;
      ROUNDED : out unsigned(22 downto 0);
    --^ final ans for mantissa 23bits
      EXP_OUT : out unsigned(8 downto 0)
    --^ overflow may happen (so 9 bits)
    );

  end component;

  signal myCLK : std_logic := '0';
  constant CYCLE : time := 10 ns;
  signal EXAMPLE : unsigned(25 downto 0)
    := "01110111001101101011010010";
  signal EXP : unsigned(8 downto 0) := "000000000";
  signal STICKY : std_logic := '1';

begin --tb
  TB : rounding
    port map (
      FRCT => EXAMPLE,
      EXP_IN => EXP,
      STICKY_IN => STICKY
      );

  trial : process
  begin
    wait for CYCLE;
    EXAMPLE <= EXAMPLE + 1;
    EXP <= EXP + 1;
  end process trial;
end TESTBENCH;
