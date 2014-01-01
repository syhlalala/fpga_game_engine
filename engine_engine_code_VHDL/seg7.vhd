library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity seg7 is
port(
code: in std_logic_vector(3 downto 0);
seg_out : out std_logic_vector(6 downto 0)
);
end seg7;

architecture behave of seg7 is

begin
process(code)
begin
	case code is 
		when  "0000" =>
		seg_out<="0111111";		
		when "0001" =>
		seg_out<="0000011";			
		when "0010" =>
		seg_out<="1101101";
		when "0011"=>
		seg_out<="1001111";
		when "0100" =>
		seg_out<="1010011";
		when "0101" =>
		seg_out <="1011110";		
		when "0110" =>
		seg_out <="1111110";
		when "0111" =>
		seg_out <="0000111";
		when "1000" =>
		seg_out <="1111111";		
		when "1001" =>
		seg_out <="1011111";
		when "1010" =>
		seg_out <="1110111";
		when "1011" =>
		seg_out <="1111010";
		when "1100" =>
		seg_out <="0111100";
		when "1101" =>
		seg_out <="1101011";
		when "1110" =>
		seg_out <="1111100";
		when "1111" =>
		seg_out <="1110100";
		when others =>seg_out<="0000000";

		end case;
	end process;
	

 end behave;