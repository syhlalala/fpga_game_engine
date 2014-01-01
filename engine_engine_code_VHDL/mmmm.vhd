library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity top_ge is
	port (
		clock	:	in std_logic;
		reset	:	in std_logic;
		--key : in std_logic_vector(3 downto 0);
		hs,vs: out STD_LOGIC; 
		r,g,b: out STD_LOGIC_vector(2 downto 0);
		
		keyboard	:	in std_logic;
		filter_clock	:	in std_logic;
		
		seg_0, seg_1, seg_2, seg_3 : out std_logic_vector(6 downto 0);
		seg_4, seg_5, seg_6, seg_7 : out std_logic_vector(6 downto 0)
	);
end entity;

architecture main of mmmm is
	component cpu 
		port (
			clock_cpu	:	in std_logic;
			clock_ram	:	in std_logic;
			reset	:	in std_logic;
			key : in std_logic_vector(3 downto 0);
			
			write_address	:	in std_logic_vector(15 downto 0);  --ram_program
			data_in	:	in std_logic_vector(15 downto 0); --ram_program
			write_clock	:	in std_logic; --ram_program
			wren	:	in std_logic; --ram_program
			
			command	:	out std_logic_vector(15 downto 0);
			value1, value2	:	out std_logic_vector(15 downto 0);
			test_out :	out std_logic_vector(15 downto 0);
			test_out2 :	out std_logic_vector(15 downto 0)
		);
	end component;


	component vga_rom
		port(
			clk_0,reset: in std_logic;
			in_command, in_write_addr, in_data_in: in std_logic_vector(15 downto 0);
			in_clock, in_cpu_clock: in std_logic;
			hs,vs: out STD_LOGIC; 
			r,g,b: out STD_LOGIC_vector(2 downto 0);
			test		:		out std_logic_vector(15 downto 0)
		);
	end component;
	
	component seg7
		port(
			code: in std_logic_vector(3 downto 0);
			seg_out : out std_logic_vector(6 downto 0)
		);
	end component;

	component top
		port(
			datain,clkin,fclk,rst_in		: 	in std_logic;
			seg0,seg1						:	out std_logic_vector(6 downto 0);
			onpress							:	out std_logic_vector(3 downto 0);
			fuck 							: 	out std_logic  
		);
	end component;

signal command, value1, value2 : std_logic_vector(15 downto 0);
signal tmp : std_logic_vector(27 downto 0);

signal test, test2 : std_logic_vector(15 downto 0);
signal key :std_logic_vector(3 downto 0);

begin
	process(clock)
	begin
		if (clock'event and clock = '1') then
			tmp <= tmp + 1;
		end if;
	end process;

	key_board :	top port map (
			datain	=> keyboard,
			clkin	=> filter_clock,
			fclk	=> clock,
			rst_in	=> reset,
			onpress => key,
			seg0 => seg_6,
			seg1 => seg_7
	);

	cpu_m : cpu port map (
			clock_cpu => tmp(4),
			clock_ram => clock,
			reset => '0',
			key => key,
			
			write_address => "0000000000000000",
			data_in => "0000000000000000",
			write_clock	=> '0',
			wren => '0',
			
			command => command,
			value1 => value1, 
			value2 => value2,
			
			test_out => test
			--test_out2 => test2
		);
		
	vga : vga_rom port map(
			clk_0 => clock,
			reset => reset,
			in_command => command,
			in_write_addr => value1,
			in_data_in => value2, 
			in_clock => clock,
			in_cpu_clock => tmp(4),
			hs => hs,
			vs => vs,
			r => r,
			g => g,
			b => b,
			test => test2
		);
	
	s0 : seg7 port map (test(3 downto 0), seg_0);
	s1 : seg7 port map (test(7 downto 4), seg_1);
	s2 : seg7 port map (test(11 downto 8), seg_2);
	s3 : seg7 port map (test(15 downto 12), seg_3);
	
	s4 : seg7 port map (test2(3 downto 0), seg_4);
	s5 : seg7 port map (test2(7 downto 4), seg_5);
	--s6 : seg7 port map (test2(11 downto 8), seg_6);
	--s7 : seg7 port map (test2(15 downto 12), seg_7);

end architecture;