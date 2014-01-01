library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity ram_gpu_d is
	port (
		command	:	in std_logic_vector(15 downto 0);
		read_address	:	in std_logic_vector(15 downto 0);
		write_address	:	in std_logic_vector(15 downto 0);
		data_in	:	in std_logic_vector(15 downto 0);
		
		clock	:	in std_logic;
		cpu_clock	: 	in std_logic;
		--wren	:	in std_logic;	--write / read enable
		data_out	:	out std_logic_vector(5 downto 0)
	);
end entity;


architecture main of ram_gpu_d is
	component ram_gpu
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
			clock		: IN STD_LOGIC ;
			data		: IN STD_LOGIC_VECTOR (5 DOWNTO 0);
			wren		: IN STD_LOGIC ; -- 1 write ; 0 read
			q		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0)
		);
	end component;

signal c1	:	std_logic_vector (7 downto 0);
signal address	:	std_logic_vector(8 downto 0);
signal data	:	std_logic_vector(5 downto 0);
signal wren	:	std_logic;

begin
--	process(cpu_clock)
--	begin
--		if (cpu_clock'event and cpu_clock='0') then
--			case c1 is
--				when "01100000" => -- write
--					--data <= data_in(5 downto 0);
--					wren <= '1';
--					--address <= write_address(8 downto 0);
--				when others => -- others
--					--data <= "000000";
--					wren <= '0';
--					--address <= read_address(8 downto 0);
--			end case;
--		end if;
--	end process;
	
	address <= write_address(8 downto 0) when (c1 ="01100000")-- or (wren = '1')
			else read_address(8 downto 0);
	
	data <= data_in(5 downto 0) when (c1 ="01100000")-- or (wren = '1')
			else "000000";
	
	wren <= '1' when (address = write_address(8 downto 0)) and (data = data_in(5 downto 0)) and (c1 ="01100000") and (cpu_clock = '0')
			else '0';
	
--	with c1 select
--		address <=
--			write_address(8 downto 0) when "01100000",
--			read_address(8 downto 0) when others;
--	
--	with c1 select
--		data <=
--			data_in(5 downto 0) when "01100000",
--			"000000" when others;

	c1 <= command(15 downto 8);
	
	ram : ram_gpu port map(
		address,
		clock,
		data,
		wren,
		data_out
	);

end architecture;