library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity register_split is
	port (
		command	:	in std_logic_vector(15 downto 0);
		register1, register2:	out std_logic_vector(3 downto 0);
		number:	out std_logic_vector(7 downto 0)
	);
end entity;

architecture main of register_split is

signal c1,c2,c3,c4	:	std_logic_vector(3 downto 0);
begin
	c1 <= command(15 downto 12);
	c2 <= command(11 downto  8);
	c3 <= command( 7 downto  4);
	c4 <= command( 3 downto  0);
	
	with c1 select
		register1 <=
			c2 when "0100", -- rh
			c2 when "0101", -- rl
			c3 when others;
	with c1 select
		register2 <=
			"0000" when "0100", -- rh
			"0000" when "0101", -- rl
			c4 when others;     
	with c1 select
		number <=
			c3&c4 when "0100", -- rh
			c3&c4 when "0101", -- rl
			"00000000" when others;
	
end architecture;