----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:16:05 06/08/2025 
-- Design Name: 
-- Module Name:    tickgenerator - Behavioral 
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

entity tickgenerator is
    Port ( clk : in  STD_LOGIC;
           tick : out  STD_LOGIC);
end tickgenerator;

architecture Behavioral of tickgenerator is

constant max: integer := 1666666;
signal count: integer range 0 to max := 0;
signal tick_temp : std_logic := '0';

begin
process(clk)
begin
if rising_edge(clk) then
	if count = max-1 then
		count <= 0;
		tick_temp <= '1';
	else
		count <= count + 1;
		tick_temp <= '0';
	end if;
end if;
end process;

tick <= tick_temp;

end Behavioral;

