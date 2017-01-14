--このテストベンチファイルはIS14erの小林氏からいただいたものを改変して利用したものです

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.textio.all;

entity fmul_tester is
end fmul_tester;

architecture test of fmul_tester is
  component FMUL
	port(
          clk      : in std_logic;
          FLOAT1   : in unsigned(31 downto 0);
          FLOAT2   : in unsigned(31 downto 0);
          ANS   : out unsigned(31 downto 0)
          );
  end component;

  signal MCLK1 : std_logic := '0';
  signal aa: unsigned(31 downto 0) := (others=>'0');
  signal bb: unsigned(31 downto 0) := (others=>'0');
  signal cc: unsigned(31 downto 0) := (others=>'0');
  signal isEND : boolean := false;

begin
  fmul_test :
    fmul port map (clk    => mclk1,
                   FLOAT1 => aa,
                   FLOAT2 => bb,
                   ANS => cc
                   );


	read_text: process(mclk1)
	file vtext: text open read_mode is in "/home/ryos/TANIPS/cpuex2014-2/fpu/FMUL/fmul-c/RDATA.txt";
	file otext: text open write_mode is in "/home/ryos/TANIPS/cpuex2014-2/fpu/FMUL/fmul-c/result_vhd.out";
	variable vl: line;
	variable ol: line;
	variable cc2,vt1,vt2 : std_logic_vector(31 downto 0);

	begin
	if rising_edge(mclk1) then
          cc2 := std_logic_vector(cc);
          write(ol, cc2(31));
          write(ol, " ");
          write(ol, cc2(30 downto 23));
          write(ol, " ");
          write(ol, cc2(22 downto 0));
          writeline(otext, ol);
          readline(vtext, vl);
          hread(vl, vt1);
          hread(vl, vt2);
          isEND <= ENDFILE(vtext);
          aa <= unsigned(vt1);
          bb <= unsigned(vt2);
        end if;
end process;

  clkgen: process
  begin
    if isEND then
      wait;
    end if;
    mclk1<='0';
    wait for 5 ns;
    mclk1<='1';
    wait for 5 ns;
  end process;

end test;
