--
-- Initializing Block RAM from external data file
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;


entity blockram_b is

  port(CLK : in std_logic;
       WR : in std_logic;
       ADDR : in std_logic_vector(9 downto 0);
       DIN : in std_logic_vector(31 downto 0);
       DOUT : out std_logic_vector(31 downto 0));
end blockram_b;


architecture syn of blockram_b is
  type RamType is array(1023 downto 0) of bit_vector(31 downto 0);
  impure function InitRamFromFile (RamFileName : in string) return RamType is
    FILE RamFile : text is in RamFileName;
    variable RamFileLine : line;
    variable RAM : RamType;
  begin
    for I in RamType'range loop
      readline (RamFile, RamFileLine);
      read (RamFileLine, RAM(I));
    end loop;
    return RAM;
  end function;
  signal RAM : RamType := InitRamFromFile("./approb.txt");

begin
  process (CLK)
  begin
    if CLK'event and CLK = '1' then
      if WR = '1' then
        RAM(conv_integer(ADDR)) <= to_bitvector(DIN);
      end if;
      DOUT <= to_stdlogicvector(RAM(1023-conv_integer(ADDR)));
    end if;
  end process;
end syn;
