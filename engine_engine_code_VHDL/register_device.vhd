library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity register_device is
	port (
		command	:	in std_logic_vector(15 downto 0);
		register1, register2:	in std_logic_vector(3 downto 0);
		
		number_set: in std_logic_vector(7 downto 0);
		number_ram, number_alu:	in std_logic_vector(15 downto 0);
		
		clock:	in std_logic;
		
		key : in std_logic_vector(3 downto 0);
		
		value1, value2:	out std_logic_vector(15 downto 0)
		
	);
end entity;

architecture main of register_device is

signal v1, v2, tmp_v:	std_logic_vector(15 downto 0);
signal c1,c2,c3,c4	:	std_logic_vector(3 downto 0); --command split
signal r0, r1, r2, r3, r4, r5, r6, r7 : std_logic_vector(15 downto 0);
signal rtmp : std_logic_vector(15 downto 0);
signal rh, rl : std_logic_vector(7 downto 0);

signal empty_nidaye : std_logic;
begin
	c1 <= command(15 downto 12);
	c2 <= command(11 downto  8);
	c3 <= command( 7 downto  4);
	c4 <= command( 3 downto  0);
	
	with register1 select -- first register value
		v1 <=
			r0 when "0000",
			r1 when "0001",
			r2 when "0010",
			r3 when "0011",
			r4 when "0100",
			r5 when "0101",
			r6 when "0110",
			r7 when "0111",
			"0000000000000000" when others;
	with register2 select -- second register value
		v2 <=
			r0 when "0000",
			r1 when "0001",
			r2 when "0010",
			r3 when "0011",
			r4 when "0100",
			r5 when "0101",
			r6 when "0110",
			r7 when "0111",
			"0000000000000000" when others;
	
	value1 <= v1;
	value2 <= v2;
	rh <= v1(15 downto 8);
	rl <= v1(7 downto 0);
	with c2 select
		tmp_v <=
			number_ram when "0000",
			v1 when others;
	with c1 select
		rtmp <=
			number_alu when "0001", -- arithmetic operation 
			tmp_v when "0011", -- read;
			number_set & rl when "0100", -- rh
			rh & number_set when "0101", -- rl
			v1 when others;
	
	set_value: process(clock)
	begin
		if (clock'event and clock = '0') then
			case register1 is
				--when "0000" => 
				--	r0 <= rtmp;
				--when "0001" => 
				--	r1 <= rtmp;
				when "0010" => 
					r2 <= rtmp;
				when "0011" => 
					r3 <= rtmp;
				when "0100" => 
					r4 <= rtmp;
				when "0101" => 
					r5 <= rtmp;
				when "0110" => 
					r6 <= rtmp;
				when "0111" => 
					r7 <= rtmp;
				when others =>
					empty_nidaye <= '0'; --...
			end case;
		end if;
	end process;
	
	counter: process(clock)
	begin
		if (clock'event and clock = '0') then
			r0 <= r0 + 1;
		end if;
	end process;
	
	keyboard: process(clock)
	begin
		if (clock'event and clock = '0') then
			r1 <= "000000000000" & (key);
		end if;
	end process;
	
end architecture;