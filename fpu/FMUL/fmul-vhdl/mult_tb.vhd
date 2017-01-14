library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult_tb is
end mult_tb;

architecture TESTBENCH of mult_tb is

  component multiplier
   Port(
     FLOAT1 : in unsigned(31 downto 0);
     FLOAT2 : in unsigned(31 downto 0);
     SIGN : out std_logic;
     EXP : out unsigned(8 downto 0); -- 1 bit lager in case of overflow
     FRCT : out unsigned(25 downto 0)
     );
   end component;

  signal myCLK : std_logic := '0';
  constant CYCLE : time := 10 ns;
  signal F1 : unsigned(31 downto 0) := x"23479133";
  signal F2 : unsigned(31 downto 0) := x"28957321";
  signal SIGN : std_logic;
  signal EXP : unsigned(8 downto 0);
  signal FRCT : unsigned(25 downto 0);

begin --tb
  TB : multiplier
    port map (
      FLOAT1 => F1,
      FLOAT2 => F2,
      SIGN => SIGN,
      EXP => EXP,
      FRCT => FRCT
      );

  trial : process
  begin
    wait for CYCLE;
    F1 <= F1 + 1;
    F2 <= F2 + 1;
  end process trial;
end TESTBENCH;
