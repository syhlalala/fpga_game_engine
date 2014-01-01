library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ram_prog is
	port (
		read_address	:	in std_logic_vector(15 downto 0);
		write_address	:	in std_logic_vector(15 downto 0);
		data_in	:	in std_logic_vector(15 downto 0);
		
		clock	:	in std_logic;
		write_clock	: 	in std_logic;
		wren	:	in std_logic;	--write / read enable
		data_out	:	out std_logic_vector(15 downto 0)
	);
end entity;


architecture main of ram_prog is
	component ram_tprog
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			wren		: IN STD_LOGIC ; -- 1 write ; 0 read
			q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	end component;

signal c1	:	std_logic_vector (7 downto 0);
signal address	:	std_logic_vector(10 downto 0);
signal data	:	std_logic_vector(15 downto 0);

begin
	process(write_clock)
	begin
		if (write_clock'event and write_clock='0') then
			case wren is
				when '1' => -- write
					--address <= write_address(10 downto 0);
					data <= data_in;
				when '0' => -- others
					
					data <= "0000000000000000";
			end case;
		end if;
	end process;
	with wren select
		address <= 
			read_address(10 downto 0) when '0',
			write_address(10 downto 0) when '1';
	ram : ram_tprog port map(
		address,
		clock,
		data,
		wren,
		data_out
	);

end architecture;