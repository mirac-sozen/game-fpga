----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:48:53 06/09/2025 
-- Design Name: 
-- Module Name:    top_module - Behavioral 
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

entity top_module is

port (
        board_clock : in  std_logic;
        BTNL        : in  std_logic;
        BTNR        : in  std_logic;
        BTN_RESET   : in  std_logic;
        hsync       : out std_logic;
        vsync       : out std_logic;
        vga_red     : out std_logic_vector(2 downto 0);
        vga_green   : out std_logic_vector(2 downto 0);
        vga_blue    : out std_logic_vector(1 downto 0);
		  SSEG_AN      : out std_logic_vector(3 downto 0);
		  SSEG_CA : out std_logic_vector(7 downto 0));
end top_module;

architecture Behavioral of top_module is

constant N_OBST : integer := 3;
signal btnl_pulse, btnr_pulse, reset_btn_clean, reset_all : std_logic;


signal clk_25mhz  : std_logic;
signal tick       : std_logic;
signal x, y       : std_logic_vector(9 downto 0);
signal video_on   : std_logic;

signal game_state  : std_logic_vector(1 downto 0);
signal game_active : std_logic;
signal game_over   : std_logic;

signal car_lane    : std_logic;
signal car_x       : std_logic_vector(9 downto 0);
signal car_y_top   : std_logic_vector(9 downto 0);
signal car_y_bot   : std_logic_vector(9 downto 0);

signal obst_lane   : std_logic_vector(N_OBST-1 downto 0);
signal obst_y_top  : std_logic_vector(10*N_OBST-1 downto 0);
signal obst_y_bot  : std_logic_vector(10*N_OBST-1 downto 0);

signal collision   : std_logic;

signal d0s :  std_logic_vector(7 downto 0) ;
signal d1s :  std_logic_vector(7 downto 0) ;
signal d2s :  std_logic_vector(7 downto 0) ;
signal d3s :  std_logic_vector(7 downto 0) ;
signal ssagc :  std_logic_vector(7 downto 0) ;
signal ssaga :  std_logic_vector(3 downto 0) ;

begin

clkdiv_inst : entity work.freqdivider
port map (
board_clock => board_clock,
divided     => clk_25mhz
);

tickgen_inst : entity work.tickgenerator
port map (
clk  => board_clock,
tick => tick
);

timing_inst : entity work.timinggen
port map (
board_clock => board_clock,
reset       => reset_all,
CE          => clk_25mhz,
hsync       => hsync,
vsync       => vsync,
x           => x,
y           => y,
display     => video_on
);

btnl_db : entity work.debouncing
port map (
clk       => board_clock,
btn_raw   => BTNL,
btn_pulse => btnl_pulse
);

btnr_db : entity work.debouncing
port map (
clk       => board_clock,
btn_raw   => BTNR,
btn_pulse => btnr_pulse
);

btnrst_db : entity work.debouncing
port map (
clk       => board_clock,
btn_raw   => BTN_RESET,
btn_pulse => reset_btn_clean
);
reset_inst : entity work.resett
port map (
    board_clock => board_clock,
    BTN_RESET   => reset_btn_clean,
    fsm_state   => game_state,
    reset_all   => reset_all
);

fsm_inst : entity work.game_controller
port map (
clk        => board_clock,
reset      => reset_all,
collision  => collision,
btn_left   => btnl_pulse,
btn_right  => btnr_pulse,
game_state => game_state
);

game_active <= '1' when game_state = "01" else '0';
game_over   <= '1' when game_state = "10" else '0';

carctrl_inst : entity work.car_controller
port map (
board_clock => board_clock,
reset       => reset_all,
BTNL        => btnl_pulse,
BTNR        => btnr_pulse,
car_x       => car_x,
car_y_top   => car_y_top,
car_y_bot   => car_y_bot,
car_lane    => car_lane
);

obsgen_inst : entity work.obs_gen
port map (
clk         => board_clock,
reset       => reset_all,
tick        => tick,
game_active => game_active,
obst_lane   => obst_lane,
obst_y_top  => obst_y_top,
obst_y_bot  => obst_y_bot
);

coldet_inst : entity work.collisiondetector
port map (
car_lane    => car_lane,
obst_lane   => obst_lane,
obst_y_bot  => obst_y_bot,
collision   => collision
);

renderer_inst : entity work.pixel_renderer
port map (
x           => x,
y           => y,
video_on    => video_on,
car_lane    => car_lane,
game_over   => game_over,
obst_lane   => obst_lane,
obst_y_top  => obst_y_top,
obst_y_bot  => obst_y_bot,
vga_red     => vga_red,
vga_green   => vga_green,
vga_blue    => vga_blue
);
sseg : entity work.sseg
port map (
game_state  => game_state,
d0           => d0s,
d1    => d1s,
d2    => d2s,
d3   => d3s
);
ssegdriver : entity work.ssegdriver
port map (
MY_CLK  => board_clock,
DIGIT0           => d0s,
DIGIT1    => d1s,
DIGIT2    => d2s,
DIGIT3   => d3s,
SSEG_CA   => SSEG_CA,
SSEG_AN    => SSEG_AN

);

end Behavioral;

