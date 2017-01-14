library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exc_tb is
end exc_tb;

architecture TESTBENCH of exc_tb is

  component exception
   Port(
     FLOAT1 : in unsigned(31 downto 0);
     FLOAT2 : in unsigned(31 downto 0);
     EXC_FLAG : out unsigned(3 downto 0)
     );
   end component;

  signal myCLK : std_logic := '0';
  constant CYCLE : time := 10 ns;
  signal F1 : unsigned(31 downto 0) := x"00000000";
  signal F2 : unsigned(31 downto 0) := x"00000000";
  signal EXC_FLAG : unsigned(3 downto 0);

begin --tb
  TB : exception
    port map (
      FLOAT1 => F1,
      FLOAT2 => F2,
      EXC_FLAG => EXC_FLAG
      );

  trial : process
  begin
    wait for CYCLE;
    F1 <= F1 + 1;
    F2 <= F2 + 1;
  end process trial;
end TESTBENCH;
