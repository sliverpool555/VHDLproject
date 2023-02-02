----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 03.12.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_ClockEnable250Hz - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;                                               --Include IEEE library
use IEEE.STD_LOGIC_1164.ALL;                                --from IEEE library access the Ports

entity T17_M2_ClockEnable250Hz is                           --Create new Entity where clock enable is 250Hz
Port ( i_Clk : in STD_LOGIC;                                --input clock
       i_Reset : in STD_LOGIC;                              --the reset as STD_logic
       o_CE : out STD_LOGIC);                               --the output from clock enable as a STD logic
end T17_M2_ClockEnable250Hz;                                --end Entity




architecture Behavioral of T17_M2_ClockEnable250Hz is       --Architecture 
    -- clock enable counter register
    signal r_Counter : integer range 0 to 400000;           --set the read counter to an interger between 0 and 40000 as it is equal to 250Hz 

begin
    T17_M2_clock_divider: Process (i_Reset,i_Clk, r_Counter)-- CE - Clock divider (counter)  
    begin
        if i_Reset = '1' then                               --if the reset is 1 then set count to 0
            r_Counter <= 0;
        elsif rising_edge(i_Clk) then                       --if there is a rising edge on the clock
            if r_Counter >= (400000-1) then                 --if the counter is greater then 399999
                r_Counter <= 0;                             --set the counter to 0 for a reset
            else
                r_Counter <= r_Counter + 1;                 --set the count value to plus one if below 399999
            end if;
          end if;
    end process T17_M2_clock_divider;                       --end the clock divider
    
   
    T17_M2_signal_gen: Process (i_reset,i_Clk, r_Counter)   -- CE -Pulse signal generation (Counter compare)
    begin
        if i_reset = '1' then                               --if the reset is high then
            o_CE <= '0';                                    --set the output to clock enable to 0
        elsif falling_edge(i_Clk) then                      --if the falling edge on the clock then
            if r_counter >= (400000 - 1) then               -- is the counter is below 399999 then 
                o_CE <= '1';                                --set clock enable to 1
            else                                            --otherwise
                o_CE <= '0';                                --set the clock enable to 0
            end if;
         end if;
      end process T17_M2_signal_gen;          
end Behavioral;