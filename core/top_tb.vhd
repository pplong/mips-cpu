library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sram.all;

entity top_tb is
end top_tb;

architecture testbench of top_tb is
  component top is
    port (
      mclk1 : in std_logic;
      rs_tx : out std_logic;
      rs_rx : in std_logic;

      ZD : inout std_logic_vector(31 downto 0);
      ZDP : inout std_logic_vector(3 downto 0);
      ZA : out std_logic_vector(19 downto 0);
      XWA : out std_logic;

      ZCLKMA : out std_logic_vector(1 downto 0);

      -- FIXED
      XE1 : out std_logic;
      E2A : out std_logic;
      XE3 : out std_logic;
      XZBE : out std_logic_vector(3 downto 0);
      XGA : out std_logic;
      XZCKE : out std_logic;

      ADVA : out std_logic;
      XFT : out std_logic;
      XLBO : out std_logic;
      ZZA : out std_logic       
      -- FIXED
    );
  end component;
  signal simclk : std_logic := '0';
  signal rx : std_logic := '1';
  signal tx : std_logic := '1';
  
  signal ZD : std_logic_vector(31 downto 0);
  signal ZDP : std_logic_vector(3 downto 0);
  signal ZA : std_logic_vector(19 downto 0);
  signal XWA : std_logic;
  signal ZCLKMA : std_logic_vector(1 downto 0);
  
  signal XE1, E2A, XE3, XGA, XZCKE, ADVA, XFT, XLBO, ZZA : std_logic;
  signal XZBE : std_logic_vector(3 downto 0);

  subtype byte_t is std_logic_vector (7 downto 0);
  type rom_t is array (0 to 21) of byte_t;
  signal SENDDATA : rom_t := (
    x"05", x"00", x"00", x"04",
    x"04", x"00", x"08", x"00",
    x"04", x"00", x"10", x"00",
    x"00", x"22", x"18", x"20",
    x"04", x"60", x"00", x"01",
    x"13", x"a4"
  );
begin
  uut: top port map (
    mclk1 => simclk,
    rs_tx => tx,
    rs_rx => rx,
    
    ZD => ZD,
    ZDP => ZDP,
    ZA => ZA,
    XWA => XWA,
    
    ZCLKMA => ZCLKMA,
    
    XE1 => XE1,
    E2A => E2A,
    XE3 => XE3,
    XZBE => XZBE,
    XGA => XGA,
    XZCKE => XZCKE,
    ADVA => ADVA,
    XFT => XFT,
    XLBO => XLBO,
    ZZA => ZZA
  );

  sram_unit0 : GS8160Z18
  port map (
    A => ZA,
    CK => ZCLKMA(0),
    XBA => XZBE(0),
    XBB => XZBE(1),
    XW => XWA,
    XE1 => XE1,
    E2 => E2A,
    XE3 => XE3,
    XG => XGA,
    ADV => ADVA,
    XCKE => XZCKE,
    DQA => ZD(7 downto 0),
    DQB => ZD(15 downto 8),
    DQPA => ZDP(0),
    DQPB => ZDP(1),
    ZZ => ZZA,
    XFT => XFT,
    XLBO => XLBO);

  sram_unit1 : GS8160Z18
  port map (
    A => ZA,
    CK => ZCLKMA(1),
    XBA => XZBE(2),
    XBB => XZBE(3),
    XW => XWA,
    XE1 => XE1,
    E2 => E2A,
    XE3 => XE3,
    XG => XGA,
    ADV => ADVA,
    XCKE => XZCKE,
    DQA => ZD(23 downto 16),
    DQB => ZD(31 downto 24),
    DQPA => ZDP(2),
    DQPB => ZDP(3),
    ZZ => ZZA,
    XFT => XFT,
    XLBO => XLBO);  

  clockgen: process
  begin
    simclk <= '0';
    wait for 7.26 ns;
    simclk <= '1';
    wait for 7.26 ns;
  end process;

  send: process
    variable cur_byte : integer range 0 to 22;
    variable cur_bit : integer range 0 to 8;
  begin
    wait for 1 us;
    cur_byte := 0;
    while cur_byte < 0 loop
      cur_bit := 0;
      rx <= '0'; wait for 104.16 us;
      while cur_bit < 8 loop
        rx <= SENDDATA(cur_byte)(cur_bit);
        cur_bit := cur_bit + 1;
        wait for 104.16 us;
      end loop;
      rx <= '1'; wait for 104.16 us;
      cur_byte := cur_byte + 1;
    end loop;
    wait;
  end process;
end testbench;

