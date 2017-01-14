library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exception is

  Port(
    --CLK : in std_logic;
    FLOAT1 : in unsigned(31 downto 0);
    FLOAT2 : in unsigned(31 downto 0);
    EXC_FLAG : out unsigned(3 downto 0)
    --^ from left; NAN, INF, SUBNORM, ZERO FLAG
    );

end exception;

architecture Behavioral of exception is

  -- exp -> "00" : nothing, "01" : 0xff, "10" : 0x00
  signal exp1 : unsigned(1 downto 0);
  signal exp2 : unsigned(1 downto 0);
  -- frct -> "0" : frct = 0, "1" : frct /= 0
  signal frct1 : std_logic;
  signal frct2 : std_logic;

begin
  exp1 <= "01" when FLOAT1(30 downto 23) = x"ff"
          else "10" when FLOAT1(30 downto 23) = x"00"
          else "00";

  exp2 <= "01" when FLOAT2(30 downto 23) = x"ff"
          else "10" when FLOAT2(30 downto 23) = x"00"
          else "00";

  frct1 <= '0' when ('0' & FLOAT1(22 downto 0)) = x"000000"
           else '1';
  frct2 <= '0' when ('0' & FLOAT2(22 downto 0)) = x"000000"
           else '1';

  EXC_FLAG <= "0001" --NAN FLAG
              when (exp1 = "01" and frct1 = '1') or (exp2 = "01" and frct2 = '1')
          else "0110" -- INF & ZERO FLAG
              when ((exp1 = "01" and frct1 = '0') and (exp2 = "10" and frct2 = '1')) or ((exp1 = "10" and frct1 = '1') and (exp2 = "01" and frct2 = '0'))
          else "1010" -- INF & SUBNORM FLAG
              when ((exp1 = "01" and frct1 = '0') and (exp2 = "10" and frct2 = '0')) or ((exp1 = "10" and frct1 = '0') and (exp2 = "01" and frct2 = '0'))
          else "0010" -- INF FLAG
              when (exp1 = "01" and frct1 = '0') or (exp2 = "01" and frct2 = '0')
          else "0100" --SUBNORM. FLAG
              when (exp1 = "10" and frct1 = '1') or (exp2 = "10" and frct2 = '1')
          else "1000" --ZERO FLAG
              when (exp1 = "10" and frct1 = '0') or (exp2 = "10" and frct2 = '0')
          else "0000";

end Behavioral;
