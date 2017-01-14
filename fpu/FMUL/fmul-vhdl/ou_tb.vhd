library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ou_tb is
end ou_tb;

architecture TESTBENCH of ou_tb is

  component over_underflow is
  Port(
    EXP_IN : in unsigned(8 downto 0);
    OVER_UNDER : out unsigned(1 downto 0)
    -- "10" means overflow
    -- "01" means underflow
    -- "00" holds no flag on
    );
   end component;

  signal myCLK : std_logic := '0';
  signal EXP : unsigned(8 downto 0) := "011111100";
  signal OVER_UNDER : unsigned(1 downto 0);
  constant CYCLE : time := 10 ns;

begin --tb
  TB : over_underflow
    port map (
      EXP_IN => EXP,
      OVER_UNDER => OVER_UNDER
      );

  trial : process
  begin
    wait for CYCLE;
    EXP <= EXP + 1;
  end process trial;
end TESTBENCH;
