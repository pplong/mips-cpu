library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.types.all;

entity fpu is
  port (
    clk : in std_logic;

    data_in1 : in WORD;
    data_in2 : in WORD;
    data_out : out WORD;

    funct : in std_logic_vector(5 downto 0)
  );
end fpu;

architecture Behavioral of fpu is
  component fadd is
    port (
      clk : in std_logic;
      UINTA : in WORD;
      UINTB : in WORD;
      ANSWER : out WORD
    );
  end component;
  signal fadd_out : WORD;

  component fmul is
    port (
      CLK : in std_logic;
      FLOAT1 : in unsigned(31 downto 0);
      FLOAT2 : in unsigned(31 downto 0);
      ANS : out unsigned(31 downto 0)
    );
  end component;
  signal fmul_in1 : unsigned(31 downto 0);
  signal fmul_in2 : unsigned(31 downto 0);
  signal fmul_out : unsigned(31 downto 0);

  component finv is
    port (
      clk : in std_logic;
      UINTA : in WORD;
      ANSWER : out WORD
    );
  end component;
  signal finv_out : WORD;
begin
  fadd_map: fadd port map (
    clk => clk,
    UINTA => data_in1,
    UINTB => data_in2,
    ANSWER => fadd_out
  );

  fmul_map: fmul port map (
    CLK => clk,
    FLOAT1 => fmul_in1,
    FLOAT2 => fmul_in2,
    ANS => fmul_out
  );
  fmul_in1 <= unsigned(data_in1);
  fmul_in2 <= unsigned(data_in2);

  finv_map: finv port map (
    CLK => clk,
    UINTA => data_in1,
    ANSWER => finv_out
  );

  calc: process(funct, fadd_out, fmul_out, finv_out)
  begin
    case funct is
      when "000000" | "000001" => data_out <= fadd_out;
      when "000010" => data_out <= std_logic_vector(fmul_out);
      when "000011" => data_out <= finv_out;
      when others => data_out <= (others => '-');
    end case;
  end process;
end Behavioral;
