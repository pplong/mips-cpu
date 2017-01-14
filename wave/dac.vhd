library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dac is
  port (
    clk : in std_logic;
    data : in std_logic_vector(11 downto 0);
    go : in std_logic;
    busy : out std_logic;

    XLDAC : out std_logic;
    XCS : out std_logic;
    SDI : out std_logic
  );
end dac;

architecture blackbox of dac is
  signal state : unsigned(4 downto 0) := "00000";
  signal sendbuf : std_logic_vector(15 downto 0);
  signal rdata : std_logic_vector(11 downto 0);
  signal o_xldac : std_logic := '1';
  signal o_cs : std_logic := '1';
begin
  proc: process(clk) begin
    if rising_edge(clk) then
      if state = "10001" then
        state <= "00000";
      else
        state <= state + 1;
      end if;
    end if;
    if falling_edge(clk) then
      if state = "10001" then
        o_cs <= '1';
        sendbuf <= "0001" & data;
        o_xldac <= '0';
      elsif state = "01111" then
        o_cs <= '0';
        sendbuf <= sendbuf(14 downto 0) & "0";
        o_xldac <= '1';
      else
        o_cs <= o_cs;
        sendbuf <= sendbuf(14 downto 0) & "0";
        o_xldac <= '1';
      end if;
    end if;
  end process;
  
  XLDAC <= o_xldac;
  XCS <= not o_cs;
  busy <= '0';
  SDI <= sendbuf(15);
end blackbox;
