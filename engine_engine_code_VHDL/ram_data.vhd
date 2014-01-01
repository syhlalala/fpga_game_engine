library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ram_data is
	port (
		command	:	in std_logic_vector(15 downto 0);
		read_address	:	in std_logic_vector(15 downto 0);
		write_address	:	in std_logic_vector(15 downto 0);
		data_in	:	in std_logic_vector(15 downto 0);
		
		clock	:	in std_logic;
		cpu_clock	: 	in std_logic;
		--wren	:	in std_logic;	--write / read enable
		data_out	:	out std_logic_vector(15 downto 0)
	);
end entity;


architecture main of ram_data is
	component ram_templet
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			wren		: IN STD_LOGIC ; -- 1 write ; 0 read
			q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	end component;

signal c1	:	std_logic_vector (7 downto 0);
signal address	:	std_logic_vector(12 downto 0);
signal data	:	std_logic_vector(15 downto 0);
signal wren	:	std_logic;

begin
--	process(cpu_clock)
--	begin
--		if (cpu_clock'event and cpu_clock='0') then
--			case c1 is
--				when "00110001" => -- write
--					data <= data_in;
--				when others => -- others
--					data <= "0000000000000000";
--			end case;
--		end if;
--	end process;

	c1 <= command(15 downto 8);
	
	address <= write_address(12 downto 0) when (c1 ="00110001")-- or (wren = '1')
			else read_address(12 downto 0);
	
	data <= data_in when (c1 ="00110001")
			else "0000000000000000";
	
	wren <= '1' when (address = write_address(12 downto 0)) and (data = data_in) and (c1 ="00110001") and (cpu_clock = '0')
			else '0';
	
--	with c1 select
--		address <=
--			read_address(12 downto 0) when "00110000",
--			write_address(12 downto 0) when "00110001",
--			"0000000000000" when others;
--	with c1 select
--		wren <=
--			'1' when "00110001", -- write
--			'0' when "00110000", -- read
--			'0' when others;
	
	
	ram : ram_templet port map(
		address,
		clock,
		data,
		wren,
		data_out
	);

end architecture;