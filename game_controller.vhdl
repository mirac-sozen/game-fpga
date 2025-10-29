----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:44:34 06/09/2025 
-- Design Name: 
-- Module Name:    game_controller - Behavioral 
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

entity game_controller is
port (
        clk          : in  std_logic;
        reset        : in  std_logic;
        collision    : in  std_logic;
        btn_left     : in  std_logic;
        btn_right    : in  std_logic;
        game_state   : out std_logic_vector(1 downto 0)
    );

end game_controller;

architecture Behavioral of game_controller is

type state_type is (IDLE, RUNNING, GAME_OVER);
    signal current_state, next_state : state_type;
begin
process(clk)
     begin
        if rising_edge(clk) then
             if reset = '1' then
                 current_state <= IDLE;
            else
                 current_state <= next_state;
            end if;
        end if;
    end process;

process(current_state, collision, btn_left, btn_right)
    begin
		  next_state <= current_state;

        case current_state is
            when IDLE =>
                if btn_left = '1' or btn_right = '1' then
                    next_state <= RUNNING;
					 else
						  next_state <= IDLE;
                end if;
			  when RUNNING =>
                if collision = '1' then
                    next_state <= GAME_OVER;
						  else
                next_state <= RUNNING;
                end if;
			when GAME_OVER =>
                null;
end case;
end process;

with current_state select
		game_state <= "00" when IDLE,
		              "01" when RUNNING,
		                "10" when GAME_OVER,
		              "00" when others;




end Behavioral;

