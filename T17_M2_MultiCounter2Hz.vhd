----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 06.10.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_MultiCounter2Hz - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------

library IEEE;                                                             --Include IEEE library
use IEEE.STD_LOGIC_1164.ALL;                                              --from IEEE library access the Ports
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity T17_M2_MultiCounter2Hz is                      
 Port ( i_Clk : in STD_LOGIC;                                             --System Clock
        i_CE : in STD_LOGIC;                                              --Clock Enable at 2Hz
        i_Reset : in std_logic;                                           --i_reset is 1 or 0
        o_CRCSelect : out std_logic_vector(1 downto 0);                   --Reset signal
        o_SymbolSelect : out STD_LOGIC);                                  --Signal that selects what symbol to show  from the symbol converter
end T17_M2_MultiCounter2Hz;                           

architecture Behavioral of T17_M2_MultiCounter2Hz is  
    signal r_SymbolSelect : STD_LOGIC;                                     --symbol select is a std_logic (1 or 0)
    signal r_CRCSelect : STD_LOGIC_Vector (1 downto 0);                    -- as you cannot toggle an output  signal is required

begin 
   T17_M2_counter_sequence: process(i_Reset, i_clk, i_CE,r_SymbolSelect) 
   begin                   
        if rising_edge(i_clk) then  
        if i_Reset = '1' then
            r_SymbolSelect <= '0';
        end if;                                                             --If rising edge of the system clock (Keeps everything in sync)          
            if i_CE = '1' then                                              --If the 2Hz clock is high
                if r_SymbolSelect = '0' then                                --if symbol select is 0 then
                    r_SymbolSelect <= '1';                                  --set it to 1 so it is toggled 
                else
                    r_SymbolSelect <= '0';                                  --then set it to 0
                end if;                                                     -- Toggles the symbol select bit
                if r_CRCSelect < "11" then                                  --if CRC count is less then 11
                    r_CRCSelect <= r_CRCSelect + '1';                       --add one
                else
                    r_CRCSelect <= "00";                                    --if it is 11 then reset the count
                end if;   
             end if;
          end if;
    end process T17_M2_counter_sequence;   
                
    o_SymbolSelect <= r_SymbolSelect;                              --set the signal to the output for the symbol select
    o_CRCSelect <= r_CRCSelect;                                    -- Sets the output to the toggling bit
end Behavioral;