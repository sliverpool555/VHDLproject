----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 09.12.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: Debounce - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T17_M2_DebounceMod is
    port (  SwitchMod : in STD_LOGIC_VECTOR (2 downto 0);             --The button port in binary signal
            LEDMod : out STD_LOGIC_VECTOR (2 downto 0);           --LED Port in Binary
            o_switchMod : out STD_LOGIC_VECTOR (2 downto 0);  --The final output signal
            Fourmsdelay : in STD_LOGIC;                         --Delay signal for the debounce
            i_clk : in STD_LOGIC;                               --The System Clock
            r_StartStop : in STD_LOGIC);                        --The start stop button
end T17_M2_DebounceMod;

architecture Behavioral of T17_M2_DebounceMod is

signal r_Stop : STD_LOGIC;  --Start Stop Button input signal

begin
    T17_M2_debounce : process (SwitchMod, Fourmsdelay, i_clk, r_StartStop, r_stop)    --Pass the input signals into process
    begin
    if rising_edge (i_clk) then                 --If the rising edge on the clock to keep the process in sync 
        if r_StartStop = '1' then               --If the start stop button is pressed
            if fourmsdelay = '1' then           --The delay is now a 1
                r_Stop <= not r_stop;           --Set the button signal to the inverse 
            end if;                             --End the if statements
        end if;
    end if; 
    if r_Stop = '0' then                        --If the stop is 0 then 
        for n in 0 to 2 loop                    --Loop though all the buttons 3 times
            if SwitchMod(n) = '1' then                --if the button selected equals 1 then 
                if rising_edge (i_clk) then     --if the clock is in 1 to sync this part of the program
                    if fourmsdelay = '1' then   --Then delay is a 1 as well
                        if SwitchMod(n) = '1' then    --If the button selected is a 1
                            LEDMod(n) <= SwitchMod(n);  --The LED selected is the same value as button
                        end if;                 --end ifs
                    end if;
                 end if;
             else                               -- else the button is not pressed then
                LEDMod(n) <= '0';                 --set the selected LED to a 0
            end if;                             --end the if statement
        end loop;                               --end the loop
        o_switchMod <= SwitchMod;                   --After loop set all the buttons equal to the digit select to be used in the switch board in the data generator
     else
          o_switchMod <= "111";              --else set all the digit select equal 1111 becuase it sets the display to 0000 so would show error
    end if;
    end process T17_M2_debounce;    
end Behavioral;