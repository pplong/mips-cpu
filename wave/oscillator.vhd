library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity oscillator is
  port (
    clk : in std_logic;
    conf : in WORD;
    
    active : out std_logic;
    wave : out WAV
  );
end oscillator;

architecture blackbox of oscillator is
  -- OSC (Square)
  component osc_square
    port (
      clk : in std_logic;
      t_half : in COUNTER;
      wave : out WAV
    );
  end component;
  signal square_out : WAV;

  -- OSC (Saw)
  component osc_saw
    port (
      clk : in std_logic;
      t : in COUNTER;
      wave : out WAV
    );
  end component;
  signal saw_out : WAV;
begin
  osc_square_map: osc_square port map (
    clk => clk,
    t_half => unsigned(conf(19 downto 0)),
    wave => square_out
  );

  osc_saw_map: osc_saw port map (
    clk => clk,
    t => unsigned(conf(19 downto 0)),
    wave => saw_out
  );

  active <= conf(31);
  wave <= square_out when conf(22 downto 20) = "000" else
          saw_out;
end blackbox;
