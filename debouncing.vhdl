----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:05:02 06/08/2025 
-- Design Name: 
-- Module Name:    debouncing - Behavioral 
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

entity debouncing is
 port (clk         : in  std_logic;
       btn_raw     : in  std_logic;
       btn_pulse   : out std_logic);
end debouncing;

architecture Behavioral of debouncing is

signal debounced_btn : std_logic := '0';
signal btn_prev      : std_logic := '0';

begin

debounce : process(clk)
	constant MAX_COUNT : integer := 1000000;
	variable counter : integer range 0 to MAX_COUNT := 0;
	variable stable : std_logic := '0';
	variable last_raw  : std_logic := '0'; 
begin
	if rising_edge(clk) then
		if btn_raw /= last_raw then
			counter := 0;
			last_raw := btn_raw;
		elsif counter < MAX_COUNT then
         counter := counter + 1; -- count stable time
		 else
         debounced_btn <= last_raw;  -- accept new stable value
         end if;
	    end if;
end process;

pulse: process(clk)
begin
	if rising_edge(clk) then
		if debounced_btn = '1' and btn_prev = '0' then
			btn_pulse <= '1';
		else
			btn_pulse <= '0';
		end if;
		btn_prev <= debounced_btn;
	end if;
end process;

end Behavioral;

