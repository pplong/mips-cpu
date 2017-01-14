library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rs232c_write is
  generic (wtime: std_logic_vector(15 downto 0) := x"0242");
  Port ( clk  : in  STD_LOGIC;
         data : in  STD_LOGIC_VECTOR (7 downto 0);
         go   : in  STD_LOGIC;
         busy : out STD_LOGIC;
         tx   : out STD_LOGIC);
end rs232c_write;

architecture blackbox of rs232c_write is
  signal countdown: std_logic_vector(15 downto 0) := (others=>'0');
  signal sendbuf: std_logic_vector(8 downto 0) := (others=>'1');
  signal state: std_logic_vector(3 downto 0) := "1011";
begin
  statemachine: process(clk)
  begin
    if rising_edge(clk) then
      case state is
        when "1011"=>
          if go='1' then
            sendbuf<=data&"0";
            state <= std_logic_vector(unsigned(state) - 1);
            countdown<=wtime;
          end if;
        when others=>
          if unsigned(countdown) = 0 then
            sendbuf <= "1"&sendbuf(8 downto 1);
            countdown<=wtime;
            if state = "0001" then
            	state <= "1011";
            else
	            state <= std_logic_vector(unsigned(state) - 1);
	          end if;
          else
            countdown<=std_logic_vector(unsigned(countdown)-1);
          end if;
      end case;
    end if;
  end process;
  tx<=sendbuf(0);
  busy<= '0' when state="1011" else '1';
end blackbox;

