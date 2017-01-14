library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity synthesizer is
  port (
    clk : in std_logic;
    synth_instr : WORD;

    wave : out WAV
  );
end synthesizer;

architecture blackbox of synthesizer is
  component oscillator
    port (
      clk : in std_logic;
      conf : in WORD;
      
      active : out std_logic;
      wave : out WAV
    );
  end component;
  signal active1, active2 : std_logic;
  signal wave1 : std_logic_vector(12 downto 0) := (others => '0');
  signal wave2 : std_logic_vector(12 downto 0) := (others => '0');
  signal config1, config2 : WORD := (others => '0');
begin
  osc1: oscillator port map (
    clk => clk,
    conf => config1,
    active => active1,
    wave => wave1(11 downto 0)
  );

  osc2: oscillator port map (
    clk => clk,
    conf => config2,
    active => active2,
    wave => wave2(11 downto 0)
  );

  dec: process(clk)
  begin
    if rising_edge(clk) then
      if synth_instr(24 downto 23) = "00" then
        config1 <= synth_instr;
      elsif synth_instr(24 downto 23) = "01" then
        config2 <= synth_instr;
      end if;
    end if;
  end process;

  synth: process(clk)
    variable sum : std_logic_vector(12 downto 0);
  begin
    if rising_edge(clk) then
      if active1 = '0' and active2 = '0' then
        wave <= (others => '0');
      elsif active1 = '1' and active2 = '0' then
        wave <= wave1(11 downto 0);
      elsif active1 = '0' and active2 = '1' then
        wave <= wave2(11 downto 0);
      else
        sum := std_logic_vector(unsigned(wave1) + unsigned(wave2));
        wave <= sum(12 downto 1);
      end if;
    end if;
  end process;
end blackbox;
