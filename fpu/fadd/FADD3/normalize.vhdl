library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.fadd_lib.all;

entity normalize is
  
  port (

    SIG_ADD : in SIG;
    EXP_ADD : in EXP;
    FRA_ADD : in FRA;

    SIG_NOR : out SIG;
    EXP_NOR : out EXP;
    FRA_NOR : out FRA);
  
end normalize;

architecture blackbox of normalize is

  component priority_encoder
    port (
      i : in FRA;
      o : out unsigned(4 downto 0)
    );
  end component;

  signal pin : FRA;
  signal shamt : unsigned(4 downto 0);

begin  -- blackbox

  pe: priority_encoder port map (
    i => pin,
    o => shamt
  );
  
  -- purpose: 正規化のループ文のため
  norm: process (SIG_ADD,EXP_ADD,FRA_ADD,shamt)
    variable FRA_LOOP : FRA;
    variable EXP_LOOP : EXP;
    variable SIG_LOOP : SIG;
  begin  -- process nor

    FRA_LOOP := FRA_ADD;
    EXP_LOOP := EXP_ADD;
    SIG_LOOP := SIG_ADD;
    
    if FRA_LOOP(27)='1' and FRA_LOOP(1)='0' then
      FRA_LOOP := '0' & FRA_LOOP(27 downto 2) & FRA_LOOP(0);
      EXP_LOOP := std_logic_vector(unsigned(EXP_LOOP) + 1);
    elsif FRA_LOOP(27)='1' then
      FRA_LOOP := '0' & FRA_LOOP(27 downto 1);
      EXP_LOOP := std_logic_vector(unsigned(EXP_LOOP) + 1);
    end if;

    if FRA_LOOP = (27 downto 0 => '0') then
      FRA_LOOP := x"0000000";
      EXP_LOOP := "000000000";
      SIG_LOOP := '0';
    else
      pin <= FRA_LOOP;
      FRA_LOOP := std_logic_vector(shift_left(unsigned(FRA_LOOP), to_integer(shamt)));
      if unsigned(EXP_LOOP) <= resize(shamt, 9) then
        EXP_LOOP := "000000000";
        FRA_LOOP := x"0000000";
      else
        EXP_LOOP := std_logic_vector(unsigned(EXP_LOOP) - resize(shamt, 9));

        if unsigned(EXP_LOOP) >= 255 then
          EXP_LOOP := "111111111";
          FRA_LOOP := x"0000000";
        elsif unsigned(EXP_LOOP) = 0 then
          EXP_LOOP := "000000000";
          FRA_LOOP := x"0000000";
        end if;
      end if;
    end if;

    SIG_NOR<=SIG_LOOP;
    EXP_NOR<=EXP_LOOP;
    FRA_NOR<=FRA_LOOP;
    
  end process;

end blackbox;
