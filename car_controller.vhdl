----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:29:31 06/07/2025 
-- Design Name: 
-- Module Name:    car_controller - Behavioral 
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

entity car_controller is
    Port ( board_clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           BTNL : in  STD_LOGIC;
           BTNR : in  STD_LOGIC;
           car_x : out  STD_LOGIC_VECTOR (9 downto 0);
           car_y_top : out  STD_LOGIC_VECTOR (9 downto 0);
           car_y_bot : out  STD_LOGIC_VECTOR (9 downto 0);
           car_lane : out std_logic);
end car_controller;

architecture Behavioral of car_controller is

constant left: integer := 240;
constant lane_w: integer := 80;
constant car_w: integer := 60;
constant car_h: integer := 120;
constant car_y_bottom: integer := 469;
constant car_y_topp: integer := car_y_bottom - car_h + 1;


begin

	process(board_clock)
	variable lane: std_logic := '0';
	variable car_x_int : integer;
	variable lane_int : integer;
begin
		if rising_edge(board_clock) then
			if reset = '1' then
				lane := '0';
			else
				if BTNR = '1' then
					lane := '1';
				elsif BTNL = '1' then
					lane := '0';
				end if;
			end if;
		end if;
lane_int := to_integer(unsigned("0" & std_logic_vector'(0 => lane)));
		car_x_int := left + (lane_int*lane_w) + ((lane_w - car_w) / 2);
	
		car_x <= std_logic_vector(to_unsigned(car_x_int,10));
		car_y_top <= std_logic_vector(to_unsigned(car_y_topp,10));
		car_y_bot <= std_logic_vector(to_unsigned(car_y_bottom,10));
		car_lane <= lane;
	end process;

end Behavioral;


