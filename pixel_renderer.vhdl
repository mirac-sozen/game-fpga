----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:42:18 06/08/2025 
-- Design Name: 
-- Module Name:    pixel_renderer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity pixel_renderer is
port(x         : in std_logic_vector(9 downto 0);
     y         : in std_logic_vector(9 downto 0);
     video_on  : in std_logic;
     car_lane  : in std_logic;
     game_over : in std_logic;
	  obst_lane    : in std_logic_vector(2 downto 0);
	  obst_y_top   : in std_logic_vector(29 downto 0);
	  obst_y_bot   : in std_logic_vector(29 downto 0);
	  vga_green : out std_logic_vector(2 downto 0);
	  vga_red: out std_logic_vector(2 downto 0);
	  vga_blue: out std_logic_vector(1 downto 0));
end pixel_renderer;

architecture Behavioral of pixel_renderer is

constant TRACK_LEFT  : integer := 240;
constant LANE_WIDTH  : integer := 80;
constant CAR_WIDTH   : integer := 60;
constant CAR_HEIGHT  : integer := 120;
constant CAR_Y_TOP   : integer := 350;
constant CAR_Y_BOT   : integer := CAR_Y_TOP + CAR_HEIGHT - 1;
constant OBST_WIDTH   : integer := 60;
constant OBST_HEIGHT  : integer := 120;
constant N_OBST : integer := 3;

begin

process(x, y, video_on, car_lane, game_over, obst_lane, obst_y_top, obst_y_bot)
    variable car_x : integer;
	 variable x_val, y_val : integer;
    variable lane_i : integer;
    variable y_top, y_bot : integer;
	 variable x_int, y_int : integer;
	 variable draw_obstacle : std_logic;
	 variable lane_ii : integer;
begin
draw_obstacle := '0';

x_int := to_integer(unsigned(x));
y_int := to_integer(unsigned(y));

vga_red   <= "000";
vga_green <= "000";
vga_blue  <= "00";

if game_over = '1' and video_on = '1' then
    vga_red   <= "111";
    vga_green <= "000";
    vga_blue  <= "00";
elsif video_on = '1' then
	if (x_int = 239 or x_int = 240) or (x_int = 400 or x_int = 401) then
		vga_red   <= "111";
		vga_green <= "111";
		vga_blue  <= "11";
	end if;
	if (x_int >= 319 and x_int <= 320) and ((y_int mod 40) < 20) then
		vga_red   <= "111";
		vga_green <= "111";
		vga_blue  <= "11";
	end if;
	
	for i in 0 to N_OBST-1 loop
		lane_i := to_integer(unsigned(obst_lane(i downto i)));
      y_top  := to_integer(signed(obst_y_top((i+1)*10-1 downto i*10)));
      y_bot  := to_integer(signed(obst_y_bot((i+1)*10-1 downto i*10)));
	
		x_val := TRACK_LEFT + lane_i * LANE_WIDTH + (LANE_WIDTH - OBST_WIDTH) / 2;
		
		if (x_int >= x_val and x_int < x_val + OBST_WIDTH) and (y_int >= y_top and y_int <= y_bot) then
			draw_obstacle := '1';
      end if;
	end loop;
	
	if draw_obstacle = '1' then
		vga_red   <= "111";
      vga_green <= "000";
      vga_blue  <= "00";
   end if;
	
	if car_lane = '0' then
    lane_ii := 0;
	else
    lane_ii := 1;
	end if;

car_x := TRACK_LEFT + lane_ii * LANE_WIDTH + (LANE_WIDTH - CAR_WIDTH) / 2;
	if (x_int >= car_x and x_int < car_x + CAR_WIDTH) and (y_int >= CAR_Y_TOP and y_int <= CAR_Y_BOT) then
		vga_red   <= "000";
      vga_green <= "111";
      vga_blue  <= "00";
	end if;

end if;

end process;
end Behavioral;

