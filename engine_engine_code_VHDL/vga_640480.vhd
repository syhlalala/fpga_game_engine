library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.std_logic_unsigned.all;
use		ieee.std_logic_arith.all;

entity vga_640480 is
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
end vga_640480;

architecture behavior of vga_640480 is	
	
	signal r1,g1,b1   : std_logic_vector(2 downto 0);					
	signal hs1,vs1    : std_logic;				
	signal vector_x : std_logic_vector(9 downto 0);		--X坐标
	signal vector_y : std_logic_vector(8 downto 0);		--Y坐标
	signal clk,clk_2,clk_4	:	 std_logic;
	signal x_tmp,x_tmp_2	: std_logic_vector (9 downto 0);		--X坐标
	signal y_tmp,y_tmp_2	: std_logic_vector (8 downto 0);		--Y坐标
	signal x_pos	: std_logic_vector (9 downto 0);
	signal y_pos	: std_logic_vector (8 downto 0);
	signal xx, yy	: std_logic_vector (2 downto 0);
	signal add_mid:std_logic_vector (13 downto 0);
	
begin

clk50 <= clk;

x_tmp <= vector_x-80;
y_tmp <= vector_y-80;
x_tmp_2 <= to_stdlogicvector(to_bitvector(x_tmp) srl 1);
y_tmp_2 <= to_stdlogicvector(to_bitvector(y_tmp) srl 1);
x_pos <= to_stdlogicvector(to_bitvector(x_tmp_2) srl 3);
y_pos <= to_stdlogicvector(to_bitvector(y_tmp_2) srl 3);
add_mid <= y_pos*"10100";
address  <= add_mid(8 downto 0)+x_pos(8 downto 0);
yy <= x_tmp_2(2 downto 0);
xx <= y_tmp_2(2 downto 0);
rom_address <= ram_data & xx & yy;

 -----------------------------------------------------------------------
  process(clk_0)	--对50M输入信号二分频
    begin
        if(clk_0'event and clk_0='1') then 
             clk_2 <= not clk_2;
        end if;
 	end process;
 	
 	
	process (CLK_2)
	begin
		if CLK_2'event and CLK_2 = '1' then
			CLK <= not CLK;
		end if;
	end process;	

 -----------------------------------------------------------------------
	 process(clk,reset)	--行区间像素数（含消隐区）
	 begin
	  	if reset='0' then
	   		vector_x <= (others=>'0');
	  	elsif clk'event and clk='1' then
	   		if vector_x=799 then
	    		vector_x <= (others=>'0');
	   		else
	    		vector_x <= vector_x + 1;
	   		end if;
	  	end if;
	 end process;

  -----------------------------------------------------------------------
	 process(clk,reset)	--场区间行数（含消隐区）
	 begin
	  	if reset='0' then
	   		vector_y <= (others=>'0');
	  	elsif clk'event and clk='1' then
	   		if vector_x=799 then
	    		if vector_y=524 then
	     			vector_y <= (others=>'0');
	    		else
	     			vector_y <= vector_y + 1;
	    		end if;
	   		end if;
	  	end if;
	 end process;
 
  -----------------------------------------------------------------------
	 process(clk,reset) --行同步信号产生（同步宽度96，前沿16）
	 begin
		  if reset='0' then
		   hs1 <= '1';
		  elsif clk'event and clk='1' then
		   	if vector_x>=656 and vector_x<752 then
		    	hs1 <= '0';
		   	else
		    	hs1 <= '1';
		   	end if;
		  end if;
	 end process;
 
 -----------------------------------------------------------------------
	 process(clk,reset) --场同步信号产生（同步宽度2，前沿10）
	 begin
	  	if reset='0' then
	   		vs1 <= '1';
	  	elsif clk'event and clk='1' then
	   		if vector_y>=490 and vector_y<492 then
	    		vs1 <= '0';
	   		else
	    		vs1 <= '1';
	   		end if;
	  	end if;
	 end process;
 -----------------------------------------------------------------------
	 process(clk,reset) --行同步信号输出
	 begin
	  	if reset='0' then
	   		hs <= '0';
	  	elsif clk'event and clk='1' then
	   		hs <=  hs1;
	  	end if;
	 end process;

 -----------------------------------------------------------------------
	 process(clk,reset) --场同步信号输出
	 begin
	  	if reset='0' then
	   		vs <= '0';
	  	elsif clk'event and clk='1' then
	   		vs <=  vs1;
	  	end if;
	 end process;
	
 -----------------------------------------------------------------------	
	process(reset,clk,vector_x,vector_y) -- XY坐标定位控制
	begin  
		if reset='0' then
			        r1  <= "000";
					g1	<= "000";
					b1	<= "000";	
		elsif(clk'event and clk='1')then
			if vector_x>=80 and vector_x<400 and vector_y>=80 and vector_y<400 then
				r1 <=q(2 downto 0);				  	
				b1 <=q(5 downto 3);
				g1 <=q(8 downto 6);
			else				
				r1 <="111";
				b1 <="111";
				g1 <="111";
			end if;

		end if;		 
	    end process;	

	-----------------------------------------------------------------------
	process (r1, g1, b1)	--色彩输出
	begin
		if vector_x <= 640 and vector_y <= 480 then
			r	<= r1;
			g	<= g1;
			b	<= b1;
		else
			r	<= (others => '0');
			g	<= (others => '0');
			b	<= (others => '0');
		end if;
	end process;

end behavior;

