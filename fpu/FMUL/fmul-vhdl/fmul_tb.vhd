library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fmul_tb is
end fmul_tb;

architecture TESTBENCH of fmul_tb is

  component fmul
   Port(
     CLK : in std_logic;
     FLOAT1 : in unsigned(31 downto 0);
     FLOAT2 : in unsigned(31 downto 0);
     ANS : out unsigned(31 downto 0)
     );
   end component;

  signal myCLK : std_logic := '0';
  constant CYCLE : time := 10 ns;
  signal F1 : unsigned(31 downto 0) := x"23479133";
  signal F2 : unsigned(31 downto 0) := x"28957321";
  signal ANS : unsigned(31 downto 0);

begin --tb
  TB : fmul
    port map (
      CLK => myCLK,
      FLOAT1 => F1,
      FLOAT2 => F2,
      ANS => ANS
      );

  trial : process
  begin
    wait for CYCLE/2;
    myCLK <= '1';
    F1 <= F1 + 1;
    F2 <= F2 + 1;
    wait for CYCLE/2;
    myCLK <= '0';
  end process trial;
end TESTBENCH;
