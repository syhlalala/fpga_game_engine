library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity alu is
	port (
		command	:	in std_logic_vector(15 downto 0);
		value1, value2 :	in std_logic_vector(15 downto 0);
		
		result :	out std_logic_vector(15 downto 0)
	);
end entity;

architecture main of alu is
signal res :	std_logic_vector(15 downto 0);
signal c1,c2,c3,c4	:	std_logic_vector(3 downto 0); --command split

signal mul_res :	std_logic_vector(31 downto 0);
signal eql_res :	std_logic_vector(15 downto 0);
signal grt_res :	std_logic_vector(15 downto 0);
signal sml_res :	std_logic_vector(15 downto 0);

begin
	c1 <= command(15 downto 12);
	c2 <= command(11 downto  8);
	
	mul_res <= value1 *  value2;
	eql_res <= "0000000000000001" when value1 = value2
				else "0000000000000000";
	grt_res <= "0000000000000001" when value1 > value2
				else "0000000000000000";
	sml_res <= "0000000000000001" when value1 < value2
				else "0000000000000000";
	
	with c2 select
		res <= 
			value1 + value2 when "0000", -- add
			value1 - value2 when "0001", -- sub
			mul_res(15 downto 0) when "0010", -- mul
			eql_res when "0101", --eql
			grt_res when "0110", --grt
			sml_res when "0111", --sml
			value1 and value2 when "1000", -- and
			value1 or value2 when "1001", -- or
			value1 xor value2 when "1010", -- xor
			not value1 when "1011", -- not
			to_stdlogicvector(to_bitvector(value1) srl conv_integer(value2)) when "1100", -- shr
			to_stdlogicvector(to_bitvector(value1) sll conv_integer(value2)) when "1101", -- shl
			value2 when "1110", -- cpy
			"0000000000000000" when others;
	with c1 select
		result <=
			res when "0001", -- arithmetic operation 
			"0000000000000000" when others;

end architecture;