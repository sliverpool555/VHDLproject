----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 29.11.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_StudentNumber1 - Behavioral
-- Project Name: UP861111_UP885608_SwitchBoard
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


--switch board

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T17_M2_SwitchBoard is
    port (  i_digitSelect : in STD_LOGIC_VECTOR (3 downto 0);   --Digit Select is for 4 bit binary value
            i_switchMod : in STD_LOGIC_VECTOR ( 2 downto 0);    --modulation input after debounce
            i_switchErr : in STD_LOGIC_VECTOR ( 1 downto 0);    --Switches to control the amount of error
            i_ST1Output : in STD_LOGIC_VECTOR (6 downto 0);     --The student number 1 output as a 7-Seg number value
            i_ST2Output : in STD_LOGIC_VECTOR (6 downto 0);     --The student number 1 output as a 7-Seg number value
            i_0toF : in STD_LOGIC_VECTOR (6 downto 0);          --Output from the 0 to F counter as a 7-Seg number value
            i_RandomNumber : in STD_LOGIC_VECTOR (6 downto 0);  --The output from random nuber as a 7-Seg binary number
            o_output3 : out  STD_LOGIC_VECTOR (6 downto 0);     --The output for display 3 that goes to the data generator and display driver 
            o_output4 : out  STD_LOGIC_VECTOR (6 downto 0);     --The output for display 4 that goes to the data generator and display driver   
            i_TempNum : in STD_LOGIC_VECTOR (6 downto 0 ));     --Output from the temperature XADC
end T17_M2_SwitchBoard;

architecture Behavioral of T17_M2_SwitchBoard is

begin

    T17_M2_SwitchBoard : process (i_digitSelect, i_ST1Output, i_ST2Output, i_0toF, i_RandomNumber, i_TempNum)
    begin

    case i_digitSelect is                   --Using the button inputs in this case statement
        when "0000" =>                      --when the buttons are 00000
            o_output3 <= "1001111";         --fix the binary 7-Seg value to 1 for display 3
            o_output4 <= "0000001";         --Fix the binary 7-Seg value to 0 for display 4
            
        when "0001" => 
            o_output3 <= "0001111";         --fix the binary 7-Seg value to 7 for display 3
            o_output4 <= "1001111";         --fix the binary 7-Seg value to 1 for display 4
            
        when "0010" => 
            o_output3 <= "0110000";         --fix the binary 7-Seg value to E for display 3
            o_output4 <= "0010010";         --fix the binary 7-Seg value to 2 for display 4
    
        when "0011" => 
            o_output3 <= "0000000";         --fix the binary 7-Seg value to 8 for display 3
            o_output4 <= "0000110";         --fix the binary 7-Seg value to 3 for display 4
            
        when "0100" => 
            o_output3 <= i_0toF;            --set the output to 7-seg binary from the 0 to F
            o_output4 <= "1001100";         -- fix the binary 7-Seg value to 4 for display 4
            
        when "0101" =>                      --Random number generator
            o_output3 <= i_RandomNumber;    --set the output to 7-seg binary from the random number
            o_output4 <= "0100100";         --fix the binary 7-Seg value to 5 for display 4
            
        when "0110" =>                      --Student Number 1
            o_output3 <= i_ST1Output;       --Set the output 3 to the student number 1
            o_output4 <= "0100000";         --fix the binary 7-Seg value to 6 for display 4
            
        when "0111" =>                      --Student Number 2
            o_output3 <= i_ST2Output;       --Set the output 3 to the student number 1
            o_output4 <= "0001111";         --fix the binary 7-Seg value to 7 for display 4
        
        when "1000" =>                      --if these buttons Read Temperature of with XADC
            o_output3 <= i_TempNum;         --set output 3 to the 7-seg temp
            o_output4 <= "0000000";         --set the output 4 to 8
            
        when "1111" =>                      --if all switches are high
            o_output3 <= "0000001";         --set output 3 to 0
            o_output4 <= "0000001";         --set output 3 to 0
        
        when others =>                      --when others 
            o_output3 <= i_TempNum;         --set output 3 to the 7-seg temp
            o_output4 <= "0000000";         --set the output 4 to 8
         end case;  
    end process T17_M2_switchBoard;
end Behavioral;
