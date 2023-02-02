----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 06.10.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_StudentNumber1 - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

Entity T17_M2_StudentNumber2 is
Port( i_SymbolCount : in STD_LOGIC_VECTOR (3 downto 0); --Count what symbol the student number is on
      o_ST2Output : out STD_LOGIC_VECTOR (6 downto 0)); --output number to display as it is only once at a time
end T17_M2_StudentNumber2;

architecture Behavioral of T17_M2_StudentNumber2 is

begin
    T17_M2_StudentNumber2 : process (i_symbolCount)     --count what symbol to be on
    begin 
        case i_symbolCount is
            when "0000" => o_ST2Output <=  "0000000";   --If count is on 0000 then set the output to 8 as it would be shown on 7-Seg
            when "0001" => o_ST2Output <=  "0100000";   --If count is on 0001 then set the output to 6 as it would be shown on 7-Seg
            when "0010" => o_ST2Output <=  "1001111";   --If count is on 0011 then set the output to 1 as it would be shown on 7-Seg
            when "0011" => o_ST2Output <=  "1001111";   --If count is on 0101 then set the output to 1 as it would be shown on 7-Seg
            when "0100" => o_ST2Output <=  "1001111";   --If count is on 0100 then set the output to 1 as it would be shown on 7-Seg
            when "0101" => o_ST2Output <=  "1001111";   --If count is on 0101 then set the output to 1 as it would be shown on 7-Seg      
            when others => o_ST2Output <= "XXXXXXX";    --if not mentioned then keep output the same                  
        end case;
     end process T17_M2_StudentNumber2;    
end Behavioral;