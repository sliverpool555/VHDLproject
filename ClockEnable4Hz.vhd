----------------------------------------------------------------------------------
--Team 17 UP861111 , UP885608 
--Company: University of Portsouth
--Engineers Sameul Gandy and Billy Horton
-- Create Date: 26/10/2020
-- Module Name: ClockEnable4HzHz - Behavioral
-- Project Name: Basys 3 Hello World Demo
-- Target Devices: Basys 3 Artix7 XC7A35T cpg236 -1 
--- Description: Basys 3 Hello VHDL World - Clock Enable entity 
----------------------------------------------------------------------------------
library IEEE;                                               --Include IEEE library
use IEEE.STD_LOGIC_1164.ALL;                                --from IEEE library access the Ports

entity ClockEnable4Hz is                                    --New that enables the clock
Port ( i_Clk : in STD_LOGIC;                                --Sets the i_Clk in STD logic (A bag of bits)
       i_Reset : in STD_LOGIC;                              --Sets the i_Reset in STD logic (A bag of bits)
       o_CE : out STD_LOGIC);                               --Sets the o_CE in STD logic (A bag of bits)
end ClockEnable4Hz;                                         --End Declaration in the Port map

architecture Behavioral of ClockEnable4Hz is                -- Atchitecture of clock to behavioral (Organsied in a logical flow)
    signal r_Counter : integer range 0 to 25000000;         --read count signal set as interger value between 0 and 6250000 (setting the limit of the signal)

begin
    clock_divider: Process (i_Reset, i_Clk, r_Counter)      -- CE - Clock divider (counter
    begin
        if i_Reset = '1' then                                --if reset equals 1 then --
            r_Counter <= 0;                                  --set the count to 0 to restart the cycle
        elsif rising_edge(i_Clk) then                        --if there is a rising edge on the clock
            if r_Counter >= (25000000-1) then                --if the counter is greater then 6249999
                r_Counter <= 0;                              --count value to 0
            else     
             r_Counter <= r_Counter + 1;                     --Add one to the counter                                        
            end if;
          end if;
    end process clock_divider;
    
    signal_gen: Process (i_reset,i_Clk, r_Counter)           --setup the procss of the signal generator for counter compare
    begin                                                    
        if i_reset = '1' then                                --if the reset is high then
            o_CE <= '0';                                     --set the output to clock enable to 0
        elsif falling_edge(i_Clk) then                       --if the falling edge on the clock then
            if r_counter >= (25000000 - 1) then              --if the counter is below 6249999
                o_CE <= '1';                                 --set the clock enable to 1
            else                                             --if counter is below 6249999
                o_CE <= '0';                                 --set the clock enable to 0
            end if;
         end if;
      end process signal_gen;
end Behavioral;
