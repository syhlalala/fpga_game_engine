library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity jump is
	port (
		command	:	in std_logic_vector(15 downto 0);
		value1, value2 :	in std_logic_vector(15 downto 0);
		
		control :	out std_logic;
		data :	out std_logic_vector(15 downto 0)
	);
end entity;

architecture main of jump is
signal c1,c2,c3,c4	:	std_logic_vector(3 downto 0); --command split

begin
	c1 <= command(15 downto 12);
	c2 <= command(11 downto  8);
	c3 <= command( 7 downto  4);
	c4 <= command( 3 downto  0);
	
	with c2 select
		data <=
			value1 when "0001",
			value1 when "0000",
			"0000000000000000" when others;
	with c1 select
		control <=
			(value2(0) or c2(0)) when "0010",
			'0' when others;
	
end architecture;