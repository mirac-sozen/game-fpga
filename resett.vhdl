----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:20:56 06/11/2025 
-- Design Name: 
-- Module Name:    resett - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity resett is
port(board_clock : in std_logic;
BTN_RESET : in Std_logic;
fsm_state : in std_logic_vector (1 downto 0);
reset_all: out std_logic);

end resett;

architecture Behavioral of resett is

begin
process(board_clock)
variable rst_state : std_logic := '0';
begin
    if rising_edge(board_clock) then
        if BTN_RESET = '1' then
            rst_state := '1';
        elsif fsm_state = "00" then
            rst_state := '0';
        end if;

    end if;
	 reset_all <= rst_state;
end process;


end Behavioral;

