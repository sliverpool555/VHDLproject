----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 06.10.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_MultiCounter1Hz - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;                                                                                    --Include IEEE library
use IEEE.STD_LOGIC_1164.ALL;                                                                     --from IEEE library access the Ports
use IEEE.numeric_std.all;                                                                        --Required for type conversions

entity T17_M2_MultiCounter1Hz is                      
 Port ( i_Clk : in STD_LOGIC;                                                                    -- System clock to ensure synchronisity of all the counters      
        i_CE : in STD_LOGIC;                                                                     -- The 1Hz clock pulse to correctly pulse the counter            
        i_Reset : in std_logic;
        i_Ready_To_Send : in std_logic;
        i_Ready_to_Receive : in STD_LOGIC;                                                       -- readout from the reset button
        o_0toF : out STD_LOGIC_VECTOR (6 downto 0);                                              -- Outputs count values
        o_SymbolCount : out STD_LOGIC_VECTOR (3 downto 0);                            
        o_TempCount : out STD_LOGIC);     
end T17_M2_MultiCounter1Hz;                           

architecture Behavioral of T17_M2_MultiCounter1Hz is                                                 
    -- counter register
    signal r_SymbolCount : integer range 0 to 5;                                                 -- Symbol count is the counter to show the correct digit of the student number entities
    signal r_0toF : integer range 0 to 15;                                                       -- 0toF is the value to be shown for the 0100 output 0 to F counter
    signal r_TempCount : STD_LOGIC;                                                              -- TempCount is a logic bit which toggles to switch which place value of the temperature is shown

begin 

   T17_M2_MultiCounter1Hz: process(i_Reset, i_clk, i_CE, r_SymbolCount, r_TempCount) 
   begin
        if i_Reset = '1' then                                                                    -- if the reset button is pressed resets the integer count values   
           r_SymbolCount <= 0;
           r_0toF  <= 0;                     
        elsif rising_edge(i_clk) then                                                            -- waits for rising edge of the system clock before functioning to clock the process
            if i_CE = '1' then                                                                    -- Waits for the 1Hz clock pulse to increment
               if r_SymbolCount < 5 then                                                         -- Checks to see if the counter is at maximum value   
                  r_SymbolCount <= r_SymbolCount + 1;                                            -- Increments Symbol count value
                else
                  r_SymbolCount <= 0;                                                            -- sets symbol count to 0        
                end if;
                if r_0toF < 15 then                                                              -- Checks to see if the counter is at maximum value
                  r_0toF <= r_0toF + 1;                                                          -- Increments 0toF count value
                else
                  r_0toF <= 0;                                                                   -- Sets 0toF to 0        
                end if;
                r_TempCount <= not r_TempCount;                                                  -- Toggles Tempcount bit
             end if;
          end if;
    end process T17_M2_MultiCounter1Hz;   
                
    o_SymbolCount <= std_logic_vector(to_unsigned(r_SymbolCount, o_SymbolCount'length));         -- Uses numeric standard to convert integer count value to SLV output of correct lenth
    o_TempCount <= r_TempCount;                                                                  -- Sets tempcount value to output

    with r_0toF select                                                                           -- Reads count value then sets output
            o_0toF  <=   "0000001" when 0,                                                        --Sets 0toF output to 0  
	                     "1001111" when 1,                                                         --Sets 0toF output to 1  
	                     "0010010" when 2,                                                         --Sets 0toF output to 2  
	                     "0000110" when 3,                                                         --Sets 0toF output to 3  
	                     "1001100" when 4,                                                         --Sets 0toF output to 4  
	                     "0100100" when 5,                                                         --Sets 0toF output to 5  
	                     "0100000" when 6,                                                         --Sets 0toF output to 6  
	                     "0001111" when 7,                                                         --Sets 0toF output to 7  
	                     "0000000" when 8,                                                         --Sets 0toF output to 8  
	                     "0000100" when 9,                                                         --Sets 0toF output to 9  
	                     "0001000" when 10,                                                        --Sets 0toF output to A  
	                     "1100000" when 11,                                                        --Sets 0toF output to B  
	                     "0110001" when 12,                                                        --Sets 0toF output to C  
	                     "1000010" when 13,                                                        --Sets 0toF output to D
	                     "0110000" when 14,                                                        --Sets 0toF output to E   
	                     "0111000" when 15;                                                        --Sets 0toF output to F      
end Behavioral; 