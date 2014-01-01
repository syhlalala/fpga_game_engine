library ieee;
use ieee.std_logic_1164.all;

entity vga_rom is
port(
	clk_0,reset: in std_logic;
	in_command, in_write_addr, in_data_in: in std_logic_vector(15 downto 0);
	in_clock, in_cpu_clock: in std_logic;
	hs,vs: out STD_LOGIC; 
	r,g,b: out STD_LOGIC_vector(2 downto 0);
	test		:		out std_logic_vector(15 downto 0)
);
end vga_rom;

architecture vga_rom of vga_rom is

component vga_640480 is
	 port(
			address		:		  out	STD_LOGIC_VECTOR(8 DOWNTO 0);
			ram_data	:         in std_logic_vector(5 downto 0);
			rom_address	:         out std_logic_vector(11 downto 0);
			reset       :         in  STD_LOGIC;
			clk50       :		  out std_logic; 
			q		    :		  in STD_LOGIC_VECTOR(8 downto 0);
			clk_0       :         in  STD_LOGIC; --50M时钟输入
			hs,vs       :         out STD_LOGIC; --行同步、场同步信号
			r,g,b       :         out STD_LOGIC_vector(2 downto 0)
	  );
end component;

component v_rom IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (11 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (8 DOWNTO 0)
	);
END component;

component ram_gpu_d is
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
end component;

signal address_tmp: std_logic_vector(6 downto 0);
signal clk50: std_logic;
signal q_tmp: std_logic_vector(8 downto 0);
signal address_ram: std_logic_vector(15 downto 0); 
signal ram_data_m: std_logic_vector(5 downto 0);
signal address_rom: std_logic_vector(11 downto 0);
signal address_ram_m: std_logic_vector(8 downto 0);

begin
test <= address_ram;
u1: vga_640480 port map(
						address=>address_ram_m, 
						ram_data=>ram_data_m,
						rom_address=>address_rom,
						reset=>reset, 
						clk50=>clk50, 
						q=>q_tmp, 
						clk_0=>clk_0, 
						hs=>hs, vs=>vs, 
						r=>r, g=>g, b=>b
					);
					
u2: v_rom port map	(	
						address=>address_rom, 
						clock=>clk_0, 
						q=>q_tmp
					);

address_ram <= "0000000" & address_ram_m;
u3: ram_gpu_d port map(
					command	=> in_command,
					read_address => address_ram,
					write_address => in_write_addr,
					data_in => in_data_in,
					
					clock => in_clock,
					cpu_clock => in_cpu_clock,
					data_out => ram_data_m
					);
					
end vga_rom;