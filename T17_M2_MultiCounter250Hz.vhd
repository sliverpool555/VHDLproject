----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 06.10.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_MultiCounter250Hz - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


--MultiCounter250Hz...

library IEEE;                                                                                                  --Include IEEE library
use IEEE.STD_LOGIC_1164.ALL;                                                                                   --from IEEE library access the Ports
use IEEE.numeric_std.all;                                                                                      --Required for type conversions

entity T17_M2_MultiCounter250Hz is                                                                             --create new  MultiCounter250Hz entity
    port (  i_Clk : in STD_LOGIC;                                                                              --clock input as STD logic so ut is only a 1 or 0
            i_CE : in STD_LOGIC;                                                                               --clock enable is STD logic so ut is only a 1 or 0
            i_Reset : in std_logic;                                                                            --i_reset STD logic so ut is only a 1 or 0
            o_RandomNumber : out STD_LOGIC_VECTOR (6 downto 0);                                                -- Random number is a 7 bit SLV to allow display on the 7 segs                                
            o_segmentCounterValue : out  STD_LOGIC_VECTOR (1 downto 0);                                        --Segment Counter is an SLV for values 00 to 11
            i_digitSelect : in STD_LOGIC_VECTOR (3 downto 0));                                                  
end T17_M2_MultiCounter250Hz;


architecture Behavioral of T17_M2_MultiCounter250Hz is                                                        --set the segment counter to behavioral so it works logicaly and sequencal
    signal r_segmentCounter : integer range 0 to 3;                                                           --the read segment counter is 0 to 3 as an interger
    signal r_RandomNumber : integer range 0 to 15;                                                            -- Signal for easy incrementing and reading of random number
    
begin
   T17_M2_counter_sequence : process(i_Reset, i_clk, i_CE, i_digitSelect, r_segmentCounter, r_RandomNumber)   --set the counter and pass the require variables into the function
   begin
        if i_Reset = '1' then                                                                                 -- if the reset button is pressed resets the integer count values                                       
            r_segmentCounter <= 0;
            r_RandomNumber <= 0;                                     
        elsif rising_edge(i_clk) then                                                                         -- waits for rising edge of the system clock before functioning to clock the process                             
            if i_CE = '1' then                                                                                -- Waits for the 250Hz clock pulse to increment                              
               if r_segmentCounter < 4 then                                                                   -- Checks to see that segment counter is less than the maximum value
                  r_segmentCounter <= r_segmentCounter + 1;                                                   -- increments the Segement counter        
                else                                                 
                  r_segmentCounter <= 0;                                                                      -- Sets the segment counter back to 0 with the overflow tick                           
                 end if;
                 if i_digitselect = "0101" then                                                               -- Ensures the count halts whilst random number is selected
                    r_RandomNumber <= r_RandomNumber;                                                         -- Holds the random number value
                 else 
                    if r_RandomNumber < 15 then                                                               -- Checks to see that random number is less than the maximum value
                      r_RandomNumber <= r_RandomNumber + 1;                                                   -- increments the random number       
                    else                                                    
                      r_RandomNumber <= 0;                                                                    -- Sets the random number back to 0 with the overflow tick                         
                     end if;
                 end if;
             end if;
          end if;
    end process T17_M2_counter_sequence; 
    
     with r_RandomNumber select                                                                               --With the integer count value sets the appropriate SLV output
        o_RandomNumber <=   "0000001" when 0,                                                                 --When digit select equals 0 make the LEDs in the pattern of a 0 on the 7 segment  
	                          "1001111" when 1,                                                                 --When digit select equals 1 make the LEDs in the pattern of a 1 on the 7 segment  
	                          "0010010" when 2,                                                                 --When digit select equals 2 make the LEDs in the pattern of a 2 on the 7 segment  
	                          "0000110" when 3,                                                                 --When digit select equals 3 make the LEDs in the pattern of a 3 on the 7 segment  
	                          "1001100" when 4,                                                                 --When digit select equals 4 make the LEDs in the pattern of a 4 on the 7 segment  
	                          "0100100" when 5,                                                                 --When digit select equals 5 make the LEDs in the pattern of a 5 on the 7 segment  
	                          "0100000" when 6,                                                                 --When digit select equals 6 make the LEDs in the pattern of a 6 on the 7 segment  
	                          "0001111" when 7,                                                                 --When digit select equals 7 make the LEDs in the pattern of a 7 on the 7 segment  
	                          "0000000" when 8,                                                                 --When digit select equals 8 make the LEDs in the pattern of a 8 on the 7 segment  
	                          "0000100" when 9,                                                                 --When digit select equals 9 make the LEDs in the pattern of a 9 on the 7 segment
	                          "0001000" when 10,                                                                --When digit select equals 10 make the LEDs in the pattern of a A on the 7 segment
	                          "1100000" when 11,                                                                --When digit select equals 11 make the LEDs in the pattern of a B on the 7 segment
	                          "0110001" when 12,                                                                --When digit select equals 12 make the LEDs in the pattern of a C on the 7 segment
	                          "1000010" when 13,                                                                --When digit select equals 13 make the LEDs in the pattern of a D on the 7 segment
	                          "0110000" when 14,                                                                --When digit select equals 14 make the LEDs in the pattern of a E on the 7 segment
	                          "0111000" when 15;                                                                --When digit select equals 15 make the LEDs in the pattern of a F on the 7 segment                                    
   o_segmentCounterValue <= std_logic_vector(to_unsigned(r_SegmentCounter, o_SegmentCounterValue'length));    -- Uses numeric standard to convert integer count value to SLV output of correct lenth                   
end Behavioral;
