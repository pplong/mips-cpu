library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package fadd_lib is
	subtype SIG is std_logic;
	subtype EXP is std_logic_vector (8 downto 0);
	subtype FRA is std_logic_vector (27 downto 0);	
end fadd_lib;
