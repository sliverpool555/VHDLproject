----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 09.12.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_DisplayDriver - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

-- Display Driver

library IEEE;                   --Include IEEE library 
use IEEE.STD_LOGIC_1164.ALL;    --from IEEE library access the Ports

entity T17_M2_DisplayDriver is                                 
Port ( i_Output1 : in STD_LOGIC_VECTOR (6 downto 0);            --The output number for display 1       
       i_Output2 : in STD_LOGIC_VECTOR (6 downto 0);            --The output number for display 2
       i_Output3 : in STD_LOGIC_VECTOR (6 downto 0);            --The output number for display 3
       i_Output4 : in STD_LOGIC_VECTOR (6 downto 0);            --The output number for display 3
       i_SegmentCount : in STD_LOGIC_VECTOR (1 downto 0);       --The signal that counts in the displays            
       o_SegmentCathodes : out STD_LOGIC_VECTOR (6 downto 0);   --The output signal to the 7-Seg chosen
       o_SegmentAnodes : out STD_LOGIC_VECTOR (3 downto 0));     --The output that controls what 7-segment is used
end T17_M2_DisplayDriver;                                       

architecture Behavioral of T17_M2_DisplayDriver is              
                  
begin
    T17_M2_DisplayDriver : process (i_SegmentCount, i_Output1, i_Output2, i_Output3, i_Output4) --Pass the input signals into the process
    begin
         case i_SegmentCount is                              -- All Statements below are depended on segment count value
              when "00" => o_SegmentCathodes <= i_Output1;   --Set output1 to the output1 number
                   o_SegmentAnodes <= "1110";                --Only turn on display 1
              when "01" => o_SegmentCathodes <= i_Output2;   --Set output2 to the output2 number
                   o_SegmentAnodes <= "1101";                --Only turn on display 2
              when "10" => o_SegmentCathodes <= i_Output3;   --Set output3 to the output3 number
                   o_SegmentAnodes <= "1011";                --Only turn on display 3
              when "11" => o_SegmentCathodes <= i_Output4;   --Set output4 to the output4 number
                   o_SegmentAnodes <= "0111";                --Only turn on display 1
              when others => o_SegmentCathodes <= "XXXXXXX"; --If not above, just dont care what is on the display
                   o_SegmentAnodes <= "XXXX";                --leave the displays as they are
          end case;
    end process T17_M2_DisplayDriver; 	             	
end Behavioral;
