----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:10:05 06/07/2025 
-- Design Name: 
-- Module Name:    timinggen - Behavioral 
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

entity timinggen is
    Port ( board_clock : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           CE : in  STD_LOGIC;
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC;
           x : out  STD_LOGIC_VECTOR (9 downto 0);
           y : out  STD_LOGIC_VECTOR (9 downto 0);
           display : out  STD_LOGIC);
end timinggen;

architecture Behavioral of timinggen is

constant h_vis: integer := 640;
constant h_fp: integer := 16;
constant h_bp: integer := 48;
constant h_sync_pulse : integer := 96; 
constant h_total : integer := 800;

constant v_vis: integer := 480;
constant v_fp: integer := 10;
constant v_bp: integer := 29;
constant v_sync_pulse: integer := 2;
constant v_total: integer := 521;

signal h_count: integer range 0 to h_total-1 := 0; 
signal v_count: integer range 0 to v_total-1 := 0;

begin

	process(board_clock)
	begin
		if rising_edge(board_clock) then
			if reset = '1' then
				h_count <= 0;
				v_count <= 0;
			elsif CE  = '1' then
				if h_count = h_total - 1 then
					h_count <= 0;
					if v_count = v_total-1 then
						v_count <= 0;
					else 
						v_count <= v_count + 1;
					end if;
				else
					h_count <= h_count + 1;
				end if;
			end if;
		end if;
	end process;
		
	hsync <= '0' when (h_count >= h_vis + h_fp and h_count < h_vis + h_fp + h_sync_pulse) else '1';
	vsync <= '0' when (v_count >= v_vis + v_fp and v_count < v_vis + v_fp + v_sync_pulse) else '1';
	
	display <= '1' when (h_count < h_vis and v_count < v_vis) else '0';
	
	x <= std_logic_vector(to_unsigned(h_count,10));
	y <= std_logic_vector(to_unsigned(v_count,10)); 

end Behavioral;

