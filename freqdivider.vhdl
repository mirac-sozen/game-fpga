----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:33:27 05/15/2025 
-- Design Name: 
-- Module Name:    freqdivider - Behavioral 
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

entity freqdivider is
    Port ( board_clock : in  STD_LOGIC;
           divided : out  STD_LOGIC);
end freqdivider;

architecture Behavioral of freqdivider is

constant max: integer := 4;
signal count: integer range 0 to max := 0;
signal divided_temp: std_logic := '0';
begin
process(board_clock)
begin
if rising_edge(board_clock) then
	if count = max-1 then
		count <= 0;
		divided_temp <= '1';
	else
		count <= count + 1;
		divided_temp <= '0';
	end if;
end if;
end process;

divided <= divided_temp;

end Behavioral;

