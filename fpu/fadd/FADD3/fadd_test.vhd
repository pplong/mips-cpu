-- TestBench Template 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.std_logic_textio.all;

use std.textio.all;

use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS

  -- Component Declaration
  COMPONENT fadd
    PORT(
      clk : in std_logic;
      UINTA : IN std_logic_vector(31 downto 0);
      UINTB : IN std_logic_vector(31 downto 0);
      ANSWER : OUT std_logic_vector(31 downto 0));
  END COMPONENT;

  SIGNAL i1 :  std_logic_vector(31 downto 0);
  SIGNAL i2 :  std_logic_vector(31 downto 0);
  SIGNAL o1 :  std_logic_vector(31 downto 0);
  signal clk : std_logic;
BEGIN

  -- Component Instantiation
  uut: fadd PORT MAP(
    clk => clk,
    UINTA => i1,
    UINTB => i2,
    ANSWER => o1);

  --  Test Bench Statements
  tb : PROCESS
    file infile : text is in "/home/bessho/ono/CPU/FADD/FADD3/random_for_read.txt";
    file outfile : text is out "/home/bessho/ono/CPU/FADD/FADD3/sim.txt";
    variable my_line, out_line : LINE;
    variable a, b, c : std_logic_vector(31 downto 0);
  BEGIN

    wait for 40 ns; -- wait until global set/reset completes

    -- Add user defined stimulus here

    while not endfile(infile) loop
      readline(infile, my_line);
      read(my_line, a);
      readline(infile, my_line);
      read(my_line, b);

      i1 <= a;
      i2 <= b;

      wait for 56 ns;

      c := o1;

      write(out_line, c);
      writeline(outfile, out_line);
    end loop;

  END PROCESS;
  clkgen:process
  begin
    clk <= '0';
    wait for 7ns;
    clk <= '1';
    wait for 7ns;
  end process;

  --  End Test Bench

end behavior;
