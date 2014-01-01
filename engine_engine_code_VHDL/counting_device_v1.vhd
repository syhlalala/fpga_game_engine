library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counting_device_v1 is
	port (
		clock, reset	:	in std_logic; --
		--enable	:	in std_logic; -- set enable
		command	:	in std_logic_vector(15 downto 0); -- include enable
		data_in	:	in std_logic_vector(15 downto 0);
		data_out	:	out std_logic_vector(15 downto 0)
	);
end entity;

architecture main of counting_device_v1 is

signal tmp : std_logic_vector(15 downto 0);
signal c1 : std_logic_vector(3 downto 0);

begin
	data_out <= tmp;
	c1 <= command(15 downto 12);

	process(clock, reset)
	begin
		if (reset = '1') then
			tmp <= "0000000000000000"; --16' 0
		elsif (clock'event and clock='1') then --rising edge 
			case c1 is
				when "0010" => tmp <= tmp +1;
				when '1' => tmp <= data_in;
			end case;
		end if;
	end process;

end architecture;