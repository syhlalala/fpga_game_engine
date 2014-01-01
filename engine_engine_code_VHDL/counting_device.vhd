library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity counting_device is
	port (
		clock, reset	:	in std_logic; --
		enable	:	in std_logic; -- set enable
		data_in	:	in std_logic_vector(15 downto 0);
		data_out	:	out std_logic_vector(15 downto 0)
	);
end entity;

architecture main of counting_device is

signal tmp : std_logic_vector(15 downto 0) := "0000000000000000";

begin
	data_out <= tmp;

	process(clock, reset)
	begin
		if (reset = '1') then
			tmp <= "0000000000000000"; --16' 0
		elsif (clock'event and clock='1') then --rising edge 
			case enable is
				when '0' => tmp <= tmp +1;
				when '1' => tmp <= data_in;
			end case;
		end if;
	end process;

end architecture;