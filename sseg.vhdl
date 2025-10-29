----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:53:34 06/12/2025 
-- Design Name: 
-- Module Name:    sseg - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity sseg is
port (
game_state   : in std_logic_vector(1 downto 0);
d0: out std_logic_vector(7 downto 0);
d1: out std_logic_vector(7 downto 0); 
d2: out std_logic_vector(7 downto 0);
d3: out std_logic_vector(7 downto 0));
end sseg;

architecture Behavioral of sseg is

signal state : std_logic_vector(1 downto 0) := game_state;
signal d0s :  std_logic_vector(7 downto 0) ;
signal d1s :  std_logic_vector(7 downto 0) ;
signal d2s :  std_logic_vector(7 downto 0) ;
signal d3s :  std_logic_vector(7 downto 0) ;

begin


process(state)
begin
	if state = "10" then  
		d0s <= "11000111" ;
		d1s <= "11000000" ;
		d2s <= "10010010" ;
		d3s <= "10000110" ;
	else 
		d0s <= "11111111" ;
		d1s <= "11111111" ;
		d2s <= "11111111" ;
		d3s <= "11111111" ;
		
		end if;
end process;

d0 <= d0s;
d1 <= d1s;
d2 <= d2s;
d3 <= d3s;




end Behavioral;

