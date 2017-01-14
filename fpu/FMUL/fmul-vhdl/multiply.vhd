library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is

  Port (
    FLOAT1 : in unsigned(31 downto 0);
    FLOAT2 : in unsigned(31 downto 0);
    SIGN : out std_logic;
    EXP : out unsigned(8 downto 0); -- 1 bit lager in case of overflow
    FRCT : out unsigned(25 downto 0);
    STICKY : out std_logic
    );

end multiplier;

architecture Behavioral of multiplier is

  signal F1_H : unsigned(13 downto 0); --upper 13+1 bits
  signal F1_L : unsigned(9 downto 0); --lower 10 bits
  signal F2_H : unsigned(13 downto 0); --upper 13+1 bits
  signal F2_L : unsigned(9 downto 0); --lower 10 bits

  signal H1H2 : unsigned(27 downto 0); --F1_H * F2_H

  signal TMPH1L2 : unsigned(23 downto 0); --F1_H * F2_L
  signal TMPH2L1 : unsigned(23 downto 0); --F2_H * F1_L

  signal H1L2 : unsigned(23 downto 0); -- after shifting
  signal H2L1 : unsigned(23 downto 0); -- after shifting
  signal L1L2 : unsigned(19 downto 0); -- for sticky bit calc.
  signal TMPsticky : std_logic := '0'; -- sticky bit
  signal actualSticky : std_logic := '0'; -- sticky bit

  signal FANS : unsigned(27 downto 0); --fraction answer
  signal carry : std_logic; --28th bit of FANS

begin -- multiplier, go for it!

  -- culculate sign bit
  SIGN <= '0'
          when (FLOAT1(31) = '0' and FLOAT2(31) = '0')
          or (FLOAT1(31) = '1' and FLOAT2(31) = '1')
          else '1';

  F1_H <= "1" & FLOAT1(22 downto 10);
  F1_L <= FLOAT1(9 downto 0);
  F2_H <= "1" & FLOAT2(22 downto 10);
  F2_L <= FLOAT2(9 downto 0);

  -- partial products
  H1H2 <= F1_H * F2_H;
  TMPH1L2 <= F1_H * F2_L;
  TMPH2L1 <= F2_H * F1_L;

  H1L2 <= shift_right(TMPH1L2, 10);
          --when TMPH1L2(1 downto 0) = "00"
          --else shift_right(TMPH1L2, 9); -- and want to make LSB "1";
  H2L1 <= shift_right(TMPH2L1, 10);
          --when TMPH2L1(1 downto 0) = "00"
          --else shift_right(TMPH2L1, 9); -- and  this one too.. "1";
          --^ i have problem here! just leave it for now, do it

  L1L2 <= F1_L * F2_L;

  TMPsticky <= '0' when (TMPH1L2(9 downto 0) = "0000000000") and
            (TMPH2L1(9 downto 0) = "0000000000") and
            (L1L2 = x"00000")
            else '1';

  --culculating fraction
  FANS <= H1H2 + H1L2 + H2L1;

  --see carry bit (28th bit)
  carry <= '1' when (FANS and x"8000000") = x"8000000"
           else '0';

  actualSticky <= '1' when ((carry = '1') and FANS(0) = '1')
                  or (TMPsticky = '1')
                  else '0';

  -- excution on overflow bit (output)
  EXP <= ("0" & FLOAT1(30 downto 23)) + ("0" & FLOAT2(30 downto 23)) + 1
         when carry = '1'
         else ("0" & FLOAT1(30 downto 23)) + ("0" & FLOAT2(30 downto 23));
  -- fraction bits(output)
  -- top 1 bit is always '1'
  -- no need to refer to it
  FRCT <= FANS(26 downto 2) & "1"
          when (carry = '1') and (actualsticky = '1')
          else FANS(26 downto 1)
          when carry = '1'
          else FANS(25 downto 1) & "1"
          when actualsticky = '1'
          else FANS(25 downto 0);

  STICKY <= actualSticky;

end Behavioral;
