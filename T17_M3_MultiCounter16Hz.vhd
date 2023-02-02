----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M3_Multicounter16Hz- Behavioral
-- Project Name: UP861111_UP885608_Milestone 3
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity T17_M3_MultiCounter16Hz is
 Port (  i_clk : in STD_LOGIC;                              --System clock pulse
         i_Reset : in STD_LOGIC;                            --reset 
         o_Wave_Count : out STD_LOGIC_VECTOR (2 downto 0)); --sets the wave count
end T17_M3_MultiCounter16Hz;

architecture Behavioral of T17_M3_MultiCounter16Hz is

signal r_Wave_Count : integer range 0 to 7;                 --signal to store wave count

begin

   T17_M3_counter_sequence: process(i_Reset, i_clk, r_Wave_Count) --start process counter sequence
   begin
        if i_Reset = '1' then                       --if reset is 1 
           r_Wave_Count <= 0;                       --reset the wave count

        elsif rising_edge(i_clk) then               --rising edge of clock
               if r_Wave_Count < 8 then             --if wave count below 8
                  r_Wave_Count <= r_Wave_Count + 1; --add one to the wave count
                else
                  r_Wave_Count <= 0;                --reset the wave count to 0
                end if;
          end if;
    end process T17_M3_counter_sequence;

    o_Wave_Count <= std_logic_vector(to_unsigned(r_Wave_Count, o_Wave_Count'length)); --convert the integer wave count to STD_LOGIC_VECTOR

end Behavioral;