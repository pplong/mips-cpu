library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity regs is
  port (
    clk : in std_logic;

    write_enable : in std_logic;
    write_reg : in std_logic_vector (4 downto 0);
    write_data : in std_logic_vector (31 downto 0);

    read_reg1 : in std_logic_vector (4 downto 0);
    read_reg2 : in std_logic_vector (4 downto 0);

    reg_data1 : out std_logic_vector (31 downto 0);
    reg_data2 : out std_logic_vector (31 downto 0)
  );
end regs;

architecture Behavioral of regs is
  subtype reg_t is std_logic_vector (31 downto 0);
  type regs_t is array (0 to 31) of reg_t;
  signal regs : regs_t := (others => (others => '0'));
begin
  wr: process (clk)
  begin
    if rising_edge(clk) then
      if write_enable = '1' then
        regs(to_integer(unsigned(write_reg))) <= write_data;
      end if;
    end if;
  end process;

  reg_data1 <= x"00000000" when read_reg1 = "00000" else 
               regs(to_integer(unsigned(read_reg1)));
  reg_data2 <= x"00000000" when read_reg2 = "00000" else 
               regs(to_integer(unsigned(read_reg2)));
end Behavioral;

