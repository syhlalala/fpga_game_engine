library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity cpu is
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
end entity;

architecture main of cpu is
	component counting_device
		port (
			clock, reset	:	in std_logic; --
			enable	:	in std_logic; -- set enable
			data_in	:	in std_logic_vector(15 downto 0);
			data_out	:	out std_logic_vector(15 downto 0)
		);
	end component;
	
	component register_split
		port (
			command	:	in std_logic_vector(15 downto 0);
			register1, register2:	out std_logic_vector(3 downto 0);
			number:	out std_logic_vector(7 downto 0)
		);
	end component;
	
	component register_device
		port (
			command	:	in std_logic_vector(15 downto 0);
			register1, register2:	in std_logic_vector(3 downto 0);
			
			number_set: in std_logic_vector(7 downto 0);
			number_ram, number_alu:	in std_logic_vector(15 downto 0);
			
			clock:	in std_logic;
			
			key : in std_logic_vector(3 downto 0);
			
			value1, value2:	out std_logic_vector(15 downto 0)
			
		);
	end component;
	
	component alu
		port (
			command	:	in std_logic_vector(15 downto 0);
			value1, value2 :	in std_logic_vector(15 downto 0);
			
			result :	out std_logic_vector(15 downto 0)
		);
	end component;
	
	component jump
		port (
			command	:	in std_logic_vector(15 downto 0);
			value1, value2 :	in std_logic_vector(15 downto 0);
			
			control :	out std_logic;
			data :	out std_logic_vector(15 downto 0)
		);
	end component;
	
	component ram_data
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
	end component;
	
	component ram_prog
		port (
			read_address	:	in std_logic_vector(15 downto 0);
			write_address	:	in std_logic_vector(15 downto 0);
			data_in	:	in std_logic_vector(15 downto 0);
			
			clock	:	in std_logic;
			write_clock	: 	in std_logic;
			wren	:	in std_logic;	--write / read enable
			data_out	:	out std_logic_vector(15 downto 0)
		);
	end component;

signal command_address : std_logic_vector(15 downto 0);
signal command_in : std_logic_vector(15 downto 0);
signal count_set_data : std_logic_vector(15 downto 0);
signal count_enable : std_logic;
signal register1, register2 : std_logic_vector(3 downto 0);
signal register_set_number : std_logic_vector(7 downto 0);
signal register_alu_number : std_logic_vector(15 downto 0);
signal register_ram_number : std_logic_vector(15 downto 0);
signal register_value1, register_value2 : std_logic_vector(15 downto 0);

begin
	count : counting_device port map (
		clock => clock_cpu,
		reset => reset,
		enable => count_enable,
		data_in => count_set_data,
		data_out => command_address
	);
	
	reg_split : register_split port map (
		command	=> command_in,
		register1 => register1,
		register2 => register2,
		number => register_set_number
	);
	
	reg : register_device port map(
		command	=> command_in,
		register1 => register1,
		register2 => register2,
		number_set => register_set_number,
		number_ram => register_ram_number,
		number_alu => register_alu_number,
		clock => clock_cpu,
		key => key,
		value1 => register_value1,
		value2 => register_value2
	);
	
	comp: alu port map (
		command => command_in,
		value1 => register_value1,
		value2 => register_value2,
		result => register_alu_number
	);

	jp : jump port map (
		command => command_in,
		value1 => register_value1,
		value2 => register_value2,
		control => count_enable,
		data => count_set_data
	);
	
	dram : ram_data port map(
		command => command_in,
		read_address => register_value2,
		write_address => register_value2,
		data_in => register_value1,
		clock => clock_ram,
		cpu_clock => clock_cpu,
		data_out => register_ram_number
	);
	
	pram : ram_prog port map(
		read_address => command_address,
		write_address => write_address,
		data_in	=> data_in,
		clock => clock_ram,
		write_clock => write_clock,
		wren => wren,
		data_out => command_in
	);
	
	command <= command_in;
	value1 <= register_value1;
	value2 <= register_value2;
	
	test_out <= command_address;
	test_out2 <= command_in;--"000000000000"&register1;

end architecture;