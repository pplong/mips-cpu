library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.wave_types.all;

-- library UNISIM;
-- use UNISIM.VComponents.all;

-- 440Hz: 151515clk
-- 880Hz: 75757clk

entity top is
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
end top;

architecture Behavioral of top is
  signal iclk, clk : std_logic;

  -- Prescaler
  component prescaler is
    port (
      clk : in std_logic;
      iclk : out std_logic
    );
  end component;
  signal dac_clk : std_logic;

  -- OSC (Square)
  component osc_square
    port (
      clk : in std_logic;
      t_half : in COUNTER;
      wave : out WAV
    );
  end component;
  signal square_t_half : COUNTER := "00010010011111101110"; --75758
  signal square_out : WAVE;

  -- OSC (Saw)
  component osc_saw
    port (
      clk : in std_logic;
      t : in COUNTER;
      wave : out WAVE
    );
  end component;
  signal saw_t : COUNTER := "00100100111111011011"; --151515
  signal saw_out : WAVE;

  signal saw_t_2 : COUNTER := "01001001111110110110";
  signal saw_out_2 : WAVE;

  -- DAC
  component dac
    port (
      clk : in std_logic;
      data : in std_logic_vector(11 downto 0);
      go : in std_logic;
      busy : out std_logic;

      XLDAC : out std_logic;
      XCS : out std_logic;
      SDI : out std_logic
    );
  end component;
  signal dac_go : std_logic := '0';
  signal dac_busy : std_logic := '0';

  signal dac_data : std_logic_vector(11 downto 0) :=
    "111111111111";
begin
  clk <= mclk1;
--   ib: IBUFG port map (
--     i => mclk1,
--     o => iclk
--   );
--   bg: BUFG port map (
--     i => iclk,
--     o => clk
--   );
  rs_tx <= '1';

  prescaler_map: prescaler port map (
    clk => clk,
    iclk => dac_clk
  );

  dac_map: dac port map (
    clk => dac_clk,
    data => dac_data,
    -- data => std_logic_vector(counter(16 downto 5)),
    go => dac_go,
    busy => dac_busy,

    XLDAC => XLDAC,
    XCS => XCS,
    SDI => SDI
  );

  osc_square_map: osc_square port map (
    clk => clk,
    t_half => square_t_half,
    wave => square_out
  );

  osc_saw_map: osc_saw port map (
    clk => clk,
    t => saw_t,
    wave => saw_out
  );

  osc_saw_2_map: osc_saw port map (
    clk => clk,
    t => saw_t_2,
    wave => saw_out_2
  );

  dac_data <= std_logic_vector(unsigned(saw_out_2(11 downto 1)) + unsigned(saw_out(11 downto 1)));
  dac_go <= not dac_busy;
  SCK <= dac_clk;

end Behavioral;
