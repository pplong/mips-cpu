library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end top_tb;

architecture testbench of top_tb is
  component top is
    port (
      mclk1 : in std_logic;
      rs_tx : out std_logic;
      rs_rx : in std_logic;

      -- DAC
      XLDAC : out std_logic;
      XCS : out std_logic;
      SCK : out std_logic;
      SDI : out std_logic
      -- DAC
    );
  end component;
  signal simclk : std_logic := '0';
  signal rx : std_logic := '1';
  signal tx : std_logic := '1';

  signal pxldac, pxcs, psck, psdi : std_logic;
begin
  uut: top port map (
    mclk1 => simclk,
    rs_tx => tx,
    rs_rx => rx,
      
    XLDAC => pxldac,
    XCS => pxcs,
    SCK => psck,
    SDI => psdi
  );

  clockgen: process
  begin
    simclk <= '0';
    wait for 7.26 ns;
    simclk <= '1';
    wait for 7.26 ns;
  end process;
end testbench;

