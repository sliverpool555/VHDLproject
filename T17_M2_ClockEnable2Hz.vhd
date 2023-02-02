----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 26.10.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_ClockEnable2Hz - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;                                               --Include IEEE library
use IEEE.STD_LOGIC_1164.ALL;                                --from IEEE library access the Ports

entity T17_M2_ClockEnable2Hz is                             --New that enables the clock
Port ( i_Clk : in STD_LOGIC;                                --Sets the i_Clk in STD logic (A bag of bits)
       i_Reset : in STD_LOGIC;                              --Sets the i_Reset in STD logic (A bag of bits)                              --Sets the i_Fast in STD logic (A bag of bits)                            --sets the i_restart in STD logic as a 1 or 0
       o_CE : out STD_LOGIC);                               --Sets the o_CE in STD logic (A bag of bits)
end T17_M2_ClockEnable2Hz;                                  --End Declaration in the Port map

architecture Behavioral of T17_M2_ClockEnable2Hz is         -- Atchitecture of clock to behavioral (Organsied in a logical flow)
    signal r_Counter : integer range 0 to 50000000;         --read count signal set as interger value between 0 and 100000000 (setting the limit of the signal)

begin
    T17_M2_clock_divider: Process (i_Reset,i_Clk, r_Counter) -- CE - Clock divider (counter
    begin
        if i_Reset = '1' then                                --if reset equals 1 then --
            r_Counter <= 0;                                  --set the count to 0 to restart the cycle
        elsif rising_edge(i_Clk) then                        --if there is a rising edge on the clock
            if r_Counter >= (50000000-1) then                --if the counter is greater then 49999999
                r_Counter <= 0;                              --count value to 0
            else                                             
                    r_Counter <= r_Counter + 1;              -- plus the counter up by 1
             end if;
          end if;
    end process T17_M2_clock_divider;
    
    T17_M2_signal_gen: Process (i_reset,i_Clk, r_Counter)    --setup the procss of the signal generator for counter compare
    begin                                                    
        if i_reset = '1' then                                --if the reset is high then
            o_CE <= '0';                                     --set the output to clock enable to 0
        elsif falling_edge(i_Clk) then                       --if the falling edge on the clock then
            if r_counter >= (50000000 - 1) then              --if the counter is below 4999999
                o_CE <= '1';                                 --set the clock enable to 1
            else                                             --if counter is below 4999999
                o_CE <= '0';                                 --set the clock enable to 0
            end if;
         end if;
      end process T17_M2_signal_gen;
end Behavioral;
