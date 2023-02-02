----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 05.12.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_XADCtemp - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;   --Required for type conversions

entity T17_M2_XADCtemp is
    Port (i_XADCoutput : in STD_LOGIC_VECTOR (15 downto 4);     --XADC Register output signal 
          o_temp : out STD_LOGIC_VECTOR (6 downto 0);           --Temperature as a 7-seg number
          i_TempCount : in STD_LOGIC;                           --Count between both numbers for the display
	      i_SegmentCount : in STD_LOGIC_VECTOR (1 downto 0);    --2bit binary which is the counters output up for the display
          i_clk : in STD_LOGIC);                                --system clock to keep the process in sync
end T17_M2_XADCtemp;

architecture Behavioral of T17_M2_XADCtemp is
    signal r_intemp : integer range 0 to 999999;        --The number frrom the XADC 
    signal r_tens : integer range 0 to 9;               --The first number to be displayed on the 7-Segment
    signal r_units : integer range 0 to 9;              --The second number to be displayed on the 7-Segment
    signal r_outTemp : integer range 0 to 9;            --The output number for the XADC
    signal r_count : integer range 0 to 3;              --
    signal r_value: integer range 0 to 1000000;         --The combined number for the average
    signal r_celcius : integer range 0 to 99;           --Store the number in celcius
    signal r_averageTemp : integer range 0 to 999999;   --The average number signal

    
begin    

    T17_M2_Averaging : process (i_segmentCount, i_XADCoutput, r_intemp, r_value, r_AverageTemp, i_clk)
    begin
        if rising_edge(i_clk) then                                                  --if rising edge of system (This keeps the process in snyc)
              case i_SegmentCount is                                                --The count value counts the different case statements in
                    when "00" =>r_intemp <= TO_INTEGER(unsigned(i_XADCoutput));     --When the count is 00 set in_temp to the XADC output
                        r_value <= r_value+r_InTemp;                                --Add the in_temp to r_value
                    when "01" => r_intemp <= TO_INTEGER(unsigned(i_XADCoutput));    --When the count is 10 set in_temp to the XADC output
                        r_value <= r_value+r_InTemp;                                --Add the in_temp to r_value
                    when "10" => r_intemp <= TO_INTEGER(unsigned(i_XADCoutput));    --When the count is 01 set in_temp to the XADC output
                        r_value <= r_value+r_InTemp;                                --Add the in_temp to r_value
                    when "11" => r_intemp <= TO_INTEGER(unsigned(i_XADCoutput));    --When the count is 11 set in_temp to the XADC output
                         r_value<= r_value+r_InTemp;                                --Add the in_temp to r_value
			             r_averagetemp <= (r_Value/4);                              --workout average temperature
			             r_value <= 0;                                              --reset the value to 0 for the next count though
                    when others => r_intemp <= TO_INTEGER(unsigned(i_XADCoutput));  --when others add to the r_value 
			             r_value<= r_value+r_InTemp;
                 end case;
            end if;
    end process T17_M2_Averaging;

    T17_M2_tensOrUnits : process (i_TempCount, r_tens, r_units, r_averageTemp, r_celcius)
    begin

        r_celcius <= ((r_averageTemp * 504)/4096) - 273;    --The formula to turn the XADC temp into celsuis
        r_tens <= r_celcius / 10;                           --dived the celcius by 10
        r_units <= r_celcius - (r_tens *10);                --celcius takeaway tens * 10 and this equals the units
        
        case i_TempCount is                     --which between the tens and units on temp count
            when '0' => r_outTemp <= r_tens;    --when 0 the tens is the output
            when '1' => r_outTemp <= r_units;   --when 1 the units is the output
            when others => r_outTemp <= 0;
        end case;

    end process T17_M2_tensOrUnits;
                     
    with r_outTemp select
        o_temp <=        "0000001" when 0,      --when the out temp is 0 set the output of program to 7-segment 0
	                     "1001111" when 1,      --when the out temp is 1 set the output of program to 7-segment 1 
	                     "0010010" when 2,      --when the out temp is 2 set the output of program to 7-segment 2
	                     "0000110" when 3,      --when the out temp is 3 set the output of program to 7-segment 3  
	                     "1001100" when 4,      --when the out temp is 4 set the output of program to 7-segment 4
	                     "0100100" when 5,      --when the out temp is 5 set the output of program to 7-segment 5  
	                     "0100000" when 6,      --when the out temp is 6 set the output of program to 7-segment 6 
	                     "0001111" when 7,      --when the out temp is 7 set the output of program to 7-segment 7 
	                     "0000000" when 8,      --when the out temp is 8 set the output of program to 7-segment 8 
	                     "0000100" when 9,      --when the out temp is 9 set the output of program to 7-segment 9
	                     "0111000" when others; --when the out temp is others set the output of program to 7-segment to F so we know there is a problem   
end Behavioral;
