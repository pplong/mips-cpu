library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity over_underflow is

  Port(
    --CLK : in std_logic;--may not be used
    EXP_IN : in unsigned(8 downto 0);
    OVER_UNDER : out unsigned(1 downto 0)
    -- "10" means overflow
    -- "01" means underflow
    -- "00" holds no flag on
    );

end over_underflow;

architecture Behavioral of over_underflow is

begin
  OVER_UNDER <= "10" when EXP_IN >= 382
                else "01" when EXP_IN <= 127
                else "00";

end Behavioral;
