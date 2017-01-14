library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fmul_rounding is

  Port(
    --CLK : in std_logic;
    FRCT : in unsigned(25 downto 0);
    --^ 23 mantissa + 3 GRS
    EXP_IN : in unsigned(8 downto 0);
    --^ if it is (8 downto 0) then it went to overflow exc.
    STICKY_IN : in std_logic;
    --^ sticky bit flag
    ROUNDED : out unsigned(22 downto 0);
    --^ final ans for mantissa 23bits
    EXP_OUT : out unsigned(8 downto 0)
    --^ overflow may happen (so 9 bits)
    );

end fmul_rounding;

architecture Behavioral of fmul_rounding is

  signal LSB : std_logic;
  signal ulp_rgs : unsigned(3 downto 0);
  --^ short for ulp, 'R'ound bit, 'G'uard bit, 'S'ticky bit
  signal TO_NORMALIZE : unsigned(23 downto 0);
  --^ add top 1 bit to see if it carries
  signal MSB : std_logic;
  --^ MSB of TO_NORMALIZE
  signal shifted_signal : unsigned(23 downto 0);
  --^ made it in order to put shifted TO_NORMALIZE in

begin
  -- rounding phase
  ulp_rgs <= FRCT(3 downto 1) & "1"
             when ((STICKY_IN = '1') or (FRCT(0) = '1'))
             else FRCT(3 downto 0); -- not sure it is legitimate
  LSB <= '1'
         when ((ulp_rgs and x"4") = x"4")
         and ((ulp_rgs and x"b") > 0)
         else '0';

  -- return 23 bits; upper 22 frct combined with rounded LSB
  TO_NORMALIZE <= ("0" & FRCT(25 downto 3)) + 1
             when LSB = '1'
             else "0" & FRCT(25 downto 3);

  MSB <= TO_NORMALIZE(23);

  shifted_signal <= shift_right(TO_NORMALIZE, 1) when MSB = '1'
                    else TO_NORMALIZE(23 downto 0);
  -- couldnt come up with an idea to do shift_right
  -- and take only (22 downto 0) bits at the same time
  -- so its separated into two discrete sentenses

  ROUNDED <= "0" & shifted_signal(21 downto 0) when MSB = '1'
             else shifted_signal(22 downto 0);

  EXP_OUT <= EXP_IN + 1
             when MSB = '1'
             else EXP_IN;
  -- EXP_OUT is heading to over/underflow unit
  --better put over/underflow circuit here

end Behavioral;
