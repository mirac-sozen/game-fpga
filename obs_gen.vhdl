----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:50:59 06/07/2025 
-- Design Name: 
-- Module Name:    obs_gen - Behavioral 
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

entity obs_gen is
    port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        tick        : in  STD_LOGIC;
        game_active : in  STD_LOGIC;
        obst_lane   : out STD_LOGIC_VECTOR(2 downto 0);
        obst_y_top  : out STD_LOGIC_VECTOR(29 downto 0);
        obst_y_bot  : out STD_LOGIC_VECTOR(29 downto 0)
    );
end obs_gen;

architecture Behavioral of obs_gen is

constant N_OBST : integer := 3;
constant OBST_HEIGHT  : integer := 120;
constant OBST_STEP    : integer := 4;
constant SCREEN_HEIGHT: integer := 480;
constant GAP          : integer := 200;
constant SPAWN_SPACING  : integer := OBST_HEIGHT + GAP;

type pattern_enum is (L, R);
type pattern_array is array(0 to N_OBST-1) of pattern_enum;

constant OBST_PATTERN : pattern_array := (L, R, R);

type y_array is array(0 to N_OBST-1) of integer range -1023 to 1023;
type lane_array is array(0 to N_OBST-1) of integer range 0 to 1;

signal y_tops : y_array := (others => 0);
signal y_bots : y_array := (others => OBST_HEIGHT - 1);
signal lanes  : lane_array := (others => 0);
function spawn_y(i: integer) return integer is
begin
  return -SPAWN_SPACING * i;
end function;


begin

process(clk)
variable highest_y : integer;
begin
	if rising_edge(clk) then
		if reset = '1' then
			for i in 0 to N_OBST - 1 loop
				  y_bots(i) <= -SPAWN_SPACING * i - 5;
                y_tops(i) <= -SPAWN_SPACING * i - OBST_HEIGHT - 5;
				
				case OBST_PATTERN(i) is
					when L => lanes(i) <= 0;
					when R => lanes(i) <= 1;
				end case;
			end loop;
		
		elsif tick = '1' and game_active = '1' then
			for i in 0 to N_OBST - 1 loop
				if y_bots(i) + OBST_STEP < SCREEN_HEIGHT then
					y_bots(i) <= y_bots(i) + OBST_STEP;
					y_tops(i) <= y_tops(i) + OBST_STEP;
				else
				  highest_y := SCREEN_HEIGHT;
                    for j in 0 to N_OBST - 1 loop
                        if y_bots(j) < highest_y then
                            highest_y := y_bots(j);
                        end if;
                    end loop;
              y_bots(i) <= highest_y - SPAWN_SPACING;
                    y_tops(i) <= highest_y - SPAWN_SPACING - (OBST_HEIGHT - 1);
                end if;
            end loop;
        end if;
	end if;
end process;

gen_output : for i in 0 to N_OBST - 1 generate
obst_lane(i) <= std_logic(to_unsigned(lanes(i), 1)(0));
obst_y_top((i+1)*10-1 downto i*10) <= std_logic_vector(to_signed(y_tops(i), 10));
obst_y_bot((i+1)*10-1 downto i*10) <= std_logic_vector(to_signed(y_bots(i), 10));
end generate;

end Behavioral;

