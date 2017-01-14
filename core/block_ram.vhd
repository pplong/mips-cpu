library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity block_ram is
  port (
    clk : in std_logic;

    we : in std_logic;
    w_addr : in BLKRAM_ADDR;
    w_data : in WORD;

    r_addr : in BLKRAM_ADDR;
    r_data : out WORD
  );
end block_ram;

architecture Behavioral of block_ram is
  type blkram_t is array (0 to 32767) of WORD;
  signal ram : blkram_t := (
    x"900a0003", x"fd400000", x"08000002", x"80124fdb",
    others => (others => '0'));
  attribute ram_style : string;
  attribute ram_style of ram : signal is "block";
  signal read_addr : BLKRAM_ADDR := (others => '0');
begin
  blkram: process(clk)
  begin
    if rising_edge(clk) then
      if we = '1' then
        ram(to_integer(unsigned(w_addr))) <= w_data;
      end if;
      read_addr <= r_addr;
    end if;
  end process;

  r_data <= ram(to_integer(unsigned(read_addr)));
end Behavioral;
