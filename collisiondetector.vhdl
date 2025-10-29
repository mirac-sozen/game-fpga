----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:15:51 06/09/2025 
-- Design Name: 
-- Module Name:    collisiondetector - Behavioral 
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

entity collisiondetector is
port (car_lane    : in  std_logic;
obst_lane   : in  std_logic_vector(2 downto 0);
obst_y_bot  : in  std_logic_vector(29 downto 0);
collision   : out std_logic);
end collisiondetector;

architecture Behavioral of collisiondetector is

constant N_OBST      : integer := 3;
constant CAR_Y_BOT   : integer := 349;

begin

process(car_lane, obst_lane, obst_y_bot)
	variable car_lane_int : integer;
	variable obs_lane_int : integer;
	variable y_bot        : integer;
	begin
		collision <= '0';
		car_lane_int := 0 when car_lane = '0' else 1;
		for i in 0 to N_OBST - 1 loop
			obs_lane_int := to_integer(unsigned(std_logic_vector'(0 => obst_lane(i))));
			y_bot := to_integer(unsigned(obst_y_bot((i+1)*10-1 downto i*10)));
			if (obs_lane_int = car_lane_int) and (460>= y_bot) and (y_bot>= CAR_Y_BOT) then
				collision <= '1';
			end if;
		end loop;
	end process;

end Behavioral;

