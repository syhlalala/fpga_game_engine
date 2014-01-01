library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity top is
port(
datain,clkin,fclk,rst_in: in std_logic;
seg0,seg1:out std_logic_vector(6 downto 0);
onpress:out std_logic_vector(3 downto 0);
		fuck : out std_logic  
);
end top;

architecture behave of top is

	component Keyboard is
	port (
		datain, clkin : in std_logic ; -- PS2 clk and data
		fclk, rst : in std_logic ;  -- filter clock
		--fok : out std_logic ;  -- data output enable signal
		scancode : out std_logic_vector(7 downto 0); -- scan code signal output
		fokout : out std_logic
		) ;
	end component ;

	component seg7 is
	port(
	code: in std_logic_vector(3 downto 0);
	seg_out : out std_logic_vector(6 downto 0)
	);
	end component;
	type states is (
		on_down,
		on_left,
		on_right,
		on_up,
		blank,
		blank_ready
	);
	signal scancode : std_logic_vector(7 downto 0);
	signal rst : std_logic;
	signal clk_f: std_logic;
	signal state: states :=blank;
	signal counter: std_logic_vector(2 downto 0) := "000";
	signal fokout: std_logic;
	begin
	fuck<=fokout;	
	rst<=not rst_in;
	u0: Keyboard port map(datain,clkin,fclk,rst,scancode,fokout);
	u1: seg7 port map(scancode(3 downto 0),seg0);
	u2: seg7 port map(scancode(7 downto 4),seg1);
	process (clkin)
	begin
	if (clkin'event and clkin = '1') then
		if (state=blank) then
			counter<=counter+"1";
			if (counter="111") then
			state<=blank_ready;
			end if;
		else
		case scancode is
			when x"1D"=>
				state<=on_up;
			when x"1C"=>
				state<=on_left;
			when x"23"=>
				state<=on_right;
			when x"1B"=>
				state<=on_down;
			when x"F0"=>
				state<=blank;
				counter<="000";
			when others=>
		end case;
		end if;
		
	end if;
	end process;
	
	with state select 
		onpress <=
			"1111" when blank,
			"1111" when blank_ready,
			"0111" when on_down,
			"1110" when on_left,
			"1101" when on_right,
			"1011" when on_up;
		

end behave;

