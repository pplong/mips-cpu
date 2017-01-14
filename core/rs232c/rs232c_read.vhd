library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rs232c_read is
	generic (
		wtime : std_logic_vector(15 downto 0) := x"0242";
		sampling_interval : std_logic_vector(15 downto 0) := x"0091"
	);
	port (
		clk : in std_logic;
		rx : in std_logic;
		read_complete : in std_logic;

		data_out : out std_logic_vector (7 downto 0);
		has_data : out std_logic
	);
end rs232c_read;

architecture Behavioral of rs232c_read is
	subtype byte_t is std_logic_vector (7 downto 0);
	type buf_t is array (0 to 4095) of byte_t;
	signal buf : buf_t;
	signal buf_head : std_logic_vector (11 downto 0) := "000000000000";
	signal buf_tail : std_logic_vector (11 downto 0) := "000000000000";

	signal s_buf : std_logic_vector (2 downto 0);
	signal data : std_logic_vector (9 downto 0);
	signal busy_st : std_logic := '1';
	signal cnt : std_logic_vector (15 downto 0);
	signal s_cnt : std_logic_vector (15 downto 0);
	signal state : std_logic_vector (3 downto 0) := "0000";
begin
	statemachine: process(clk)
	variable data_buf : std_logic_vector(9 downto 0);
	begin
		if rising_edge(clk) then
			if read_complete = '1' then
				buf_head <= std_logic_vector(unsigned(buf_head) + 1);
			end if;
			case state is
				when "0000" =>
					if rx = '0' then
						state <= "0001";
					end if;
				when "0001" =>
					if rx = '0' then
						state <= "0010";
					else
						state <= "0000";
					end if;
				when "0010" =>
					if rx = '0' then
						state <= "0011";
						cnt <= std_logic_vector(unsigned(wtime) - 3);
						s_cnt <= std_logic_vector(unsigned(sampling_interval) - 3);
						busy_st <= '1';
					else
						state <= "0000";
					end if;
				when others =>
					if unsigned(s_cnt) = 0 then
						s_buf <= s_buf(1 downto 0) & rx;
						s_cnt <= sampling_interval;
					else
						s_cnt <= std_logic_vector(unsigned(s_cnt) - 1);
					end if;
					if unsigned(cnt) = 0 then
						data_buf := 
							((s_buf(0) and s_buf(1)) or
							 (s_buf(1) and s_buf(2)) or
							 (s_buf(0) and s_buf(2)))
							& data(9 downto 1);
						data <= data_buf;
						if state = "1011" then
							busy_st <= '0';
							buf(to_integer(unsigned(buf_tail))) <= data_buf(9 downto 2);
							buf_tail <= std_logic_vector(unsigned(buf_tail) + 1);
							cnt <= x"0800";
							s_cnt <= x"1000";
							state <= "1100";
						elsif state = "1100" then
							state <= "0000";
						else
							state <= std_logic_vector(unsigned(state) + 1);
							cnt <= wtime;
							s_cnt <= sampling_interval;
						end if;
					else
						cnt <= std_logic_vector(unsigned(cnt) - 1);
					end if;
			end case;
		end if;
	end process;
	
	has_data <= '0' when buf_head = buf_tail else '1';
	data_out <= buf(to_integer(unsigned(buf_head)));
end Behavioral;

