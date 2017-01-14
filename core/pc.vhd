library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity pc is
  port (
    clk : in std_logic;

    pc_next : in std_logic;
    pc_src : in std_logic;
    pc_nextvalue : in BLKRAM_ADDR;

    ptr : out BLKRAM_ADDR
  );
end pc;

architecture Behavioral of pc is
  signal pctr : BLKRAM_ADDR := (others => '0');
begin
  counter: process(clk)
  begin
    if rising_edge(clk) then
      if pc_next = '1' then
        if pc_src = '1' then
          pctr <= pc_nextvalue;
        else
          pctr <= std_logic_vector(unsigned(pctr) + 1);
        end if;
      end if;
    end if;
  end process;
  
  ptr <= pctr;
end Behavioral;

