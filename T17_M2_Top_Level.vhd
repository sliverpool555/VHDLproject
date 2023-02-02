----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 09.12.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_Top_Level - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity T17_M2_Top_Level is
Port ( i_C100MHz : in STD_LOGIC;                                --setup Port, set the i100MHZ clock variable
       i_Reset : in STD_LOGIC;	                                --setip the reset input as a STD_LOGIC it can only be a 1 or 0
       i_StartStop : in STD_LOGIC;                              --Button for the start and stop
       SwitchDG : in STD_LOGIC_VECTOR (3 downto 0);             --Switches for Data Generator
       SwitchMod : in STD_LOGIC_VECTOR ( 2 downto 0);           --Switches for the modulation 
       SwitchErr : in STD_LOGIC_VECTOR (1 downto 0);            --Switches for the Error select
       LEDDG : out STD_LOGIC_VECTOR (3 downto 0);               --LEDs for the data generator switches
       LEDMod :  out STD_LOGIC_VECTOR (2 downto 0);             --LEDs for the modulator switches
       LEDErr :  out STD_LOGIC_VECTOR (1 downto 0);             --LEDs for the Error Select switches          
       i_CE250Hz : in STD_LOGIC;                                --Input to the clock enable at 250Hz
       i_CE1Hz : in STD_LOGIC;                                  --Input to the clock enable at 1Hz
       o_SegmentCathodes : out STD_LOGIC_VECTOR (6 downto 0);   --Signal that takes the outputs and displays the number on the 7 segment
       o_SegmentAnodes : out STD_LOGIC_VECTOR (3 downto 0 );    --Signal to chose what display to use. This controls the multiplex 
       i_SymbolCount1Hz  : in STD_LOGIC_VECTOR (3 downto 0));   --Signal that stores the value of the count for the student numbers
end T17_M2_Top_Level;

architecture Behavioral of T17_M2_Top_Level is
    
    component clk_wiz_0 is                                      --create component for the clocking. This connects the clocking wizard
    Port (clk_out1 : out STD_LOGIC;                             --the output from the clock as a STD logic variable
          reset : in STD_LOGIC;                                 --reset as a 1 or 0
          locked : out STD_LOGIC;                               --output from DCM in STD_LOGIC is 0 or 1
          clk_in1 : in STD_LOGIC);                              --clk in variable as 1 or 0
    end component;
    
    signal r_tempNum : STD_LOGIC_VECTOR (6 downto 0);           --Signal to pass the temperature value in the main (From data generator to display)
    signal r_SystemClock : std_logic;                           --The clock from the
    signal r_CE250Hz : std_logic;                               --Clock Enable for 250Hz
    signal r_CE1Hz : std_logic;                                 --Clock Enable for 1Hz
    signal r_CE2Hz : STD_LOGIC;                                 --Clock Enable for 2Hz
    signal r_CE16Hz : STD_LOGIC;
    
    
    --Switches
    signal r_digitSelect : STD_LOGIC_VECTOR (3 downto 0);       --Passes the button values from buttons to the switch board
    signal r_switchMod : STD_LOGIC_VECTOR ( 2 downto 0);        --r_switchmod is the variable for the
    signal r_switchErr : STD_LOGIC_VECTOR (1 downto 0);
    signal r_CRCSelect : STD_LOGIC_VECTOR (1 downto 0);
    
    signal r_reset : STD_LOGIC;                                 --Reset Signal form the reset button
    
    signal r_Ready_To_Send :  std_logic;
    signal r_Ready_to_Receive :  STD_LOGIC;
    
    signal r_SymbolSelect : STD_LOGIC;                          --Selects what binary number to be shown
    signal r_SymbolCount1Hz : STD_LOGIC_VECTOR (3 downto 0);    --Selects what symbol to show on display 0 and 1
    signal r_SymbolCount2Hz : STD_LOGIC_VECTOR (3 downto 0);    --The count from the 2Hz clock
    signal r_TempCount :  STD_LOGIC;                            --Count the temperature for the average
    signal r_ST1Output : STD_LOGIC_VECTOR (6 downto 0);         --Student Number 1 output
    signal r_ST2Output : STD_LOGIC_VECTOR (6 downto 0);         --Student Number 2 output

    signal r_0toF : STD_LOGIC_VECTOR (6 downto 0);              --The number or letter stored as a signal being pasted between entities
    
    signal r_RandomNumber : STD_LOGIC_VECTOR (6 downto 0);          --signal used to pass the random number between 250Hz multicounter and display driver
    signal r_segmentCounterValue : STD_LOGIC_VECTOR (1 downto 0);   --Signal to connect the multicounter250Hz to Data Generator to Display driver
   
    signal r_output1 : STD_LOGIC_VECTOR (6 downto 0);           --The number to be displayed on 7-seg 1
    signal r_output2 : STD_LOGIC_VECTOR (6 downto 0);           --The number to be displayed on 7-seg 2
    signal r_output3 : STD_LOGIC_VECTOR (6 downto 0);           --The number to be displayed on 7-seg 3
    signal r_output4 : STD_LOGIC_VECTOR (6 downto 0);           --The number to be displayed on 7-seg 4
    
    signal r_sim_out_QAM : STD_LOGIC_VECTOR ( 1 downto 0);      --QAM output signal from the demodulation
    signal r_sim_out_PSK : STD_LOGIC_VECTOR ( 1 downto 0);      --PSK output signal from the demodulation
    
    signal r_FourDigit : STD_LOGIC_VECTOR (7 downto 0);        --Modulation input for display
    
    signal o_display1 : STD_lOGIC_VECTOR ( 6 downto 0);         --These are the 7-segment numbers in binary from teh verdict and goes to the display driver
    signal o_display2 : STD_lOGIC_VECTOR ( 6 downto 0);
    signal o_display3 : STD_lOGIC_VECTOR ( 6 downto 0);
    signal o_display4 : STD_lOGIC_VECTOR ( 6 downto 0);
    
    signal r_CRCcount : std_logic_vector(1 downto 0);
    signal r_data_value :  STD_LOGIC_VECTOR (6 downto 0);
    
begin
    
    T17_M2_DCM : clk_wiz_0 --Pass signals from and to the clock
        port map ( clk_out1 => r_SystemClock, reset => i_Reset, clk_in1 => i_C100MHz); 
        
    T17_M2_Data_Select : entity work.T17_M2_Data_Select(Behavioral) --passing variables into the data select and pass back
        port map (SwitchDG => SwitchDG, Fourmsdelay => r_CE250Hz, o_digitSelect => r_digitSelect, i_clk => r_systemclock, r_StartStop => i_StartStop);

    T17_M3_DebounceErr : entity work.T17_M3_DebounceErr (Behavioral) 
        Port Map (SwitchErr => SwitchErr, LEDErr => LEDErr, Fourmsdelay => r_CE250Hz, o_switchErr => r_switchErr, i_clk => r_systemclock, r_StartStop => i_StartStop);
    
    T17_M2_DebounceMod  : entity work.T17_M2_DebounceMod  (Behavioral) 
        Port Map (SwitchMod => SwitchMod, LEDMod => LEDMod, Fourmsdelay => r_CE250Hz, o_switchMod => r_switchMod, i_clk => r_systemclock, r_StartStop => i_StartStop);

    T17_M2_DisplayDriver : entity work.T17_M2_DisplayDriver(Behavioral) --pass the signals into teh display driver
        Port map (i_Output1 => o_display1, i_Output2 => o_display2, i_Output3 => o_display3, i_Output4 => o_display4, i_SegmentCount => r_segmentCounterValue, o_SegmentCathodes => o_SegmentCathodes, o_SegmentAnodes => o_SegmentAnodes);
        
    T17_M2_ClockEnable1Hz : entity work.T17_M2_ClockEnable1Hz(Behavioral)          --Set the clock enable and pass signals though                                               -- instantiate Clock from main at 2Hz Enable entity
        Port map (i_Clk  => r_SystemClock, i_Reset => i_Reset, o_ce => r_CE1Hz); 
        
    T17_M2_ClockEnable2Hz : entity work.T17_M2_ClockEnable2Hz(Behavioral)           --Set the clock enable and pass signals though                                                -- instantiate Clock from main at 2Hz Enable entity
        Port map (i_Clk  => r_SystemClock, i_Reset => i_Reset, o_ce =>r_CE2Hz);  
        
    T17_M2_ClockEnable250Hz : entity work.T17_M2_ClockEnable250Hz(Behavioral)       --Set the clock enable and pass signals though
        Port map (i_Clk => r_SystemClock, i_Reset => i_Reset, o_CE => r_CE250Hz);
        
    T17_M3_ClockEnable16Hz : entity work.T17_M3_ClockEnable16Hz (Behavioral) 
        Port Map (i_Clk => r_SystemClock, i_Reset => i_Reset, o_CE => r_CE16Hz);
        
    T17_M2_MultiCounter1Hz : entity work.T17_M2_MultiCounter1Hz(Behavioral)         --pass signals into abd out of multicounter                                           
        Port map (i_Clk => r_SystemClock, i_Reset => i_Reset, i_CE => r_CE1Hz, 
                  i_Ready_to_receive => r_Ready_to_receive, i_Ready_to_Send => r_Ready_to_Send, 
                  o_SymbolCount => r_SymbolCount1Hz, o_0toF => r_0toF, o_TempCount => r_tempCount);
        
    T17_M2_MultiCounter2Hz : entity work.T17_M2_MultiCounter2Hz(Behavioral)         --pass signals into abd out of multicounter                                      
        Port map (i_Clk => r_SystemClock, i_Reset => i_Reset, i_CE => r_CE2Hz, 
        o_CRCSelect => r_CRCSelect, o_SymbolSelect => r_SymbolSelect);
        
    T17_M2_MultiCounter250Hz : entity work.T17_M2_multiCounter250Hz(Behavioral)     --pass signals into abd out of multicounter 
        Port map (i_Clk  => r_SystemClock, i_CE => r_CE250Hz, i_Reset => i_Reset, o_RandomNumber => r_RandomNumber, o_segmentCounterValue => r_segmentCounterValue, i_digitSelect => r_digitSelect);   
        
    T17_M3_Verdict : entity work.T17_M3_Verdict (Behavioral) 
        Port map (i_clk => r_SystemClock, i_CE1Hz => i_CE1Hz, i_CE2Hz => r_CE2Hz, 
                  i_sim_out_QAM => r_sim_out_QAM, i_sim_out_QPSK => r_sim_out_PSK,
                  i_CRCcount => r_CRCcount, LEDsDG => LEDDG, 
                  i_Output1 => r_output1, i_Output2 => r_output2, i_Output3 => r_output3, i_Output4 => r_output4,
                  i_switchDG => r_digitSelect, i_switchMod => r_switchMod, i_symbolSelect => r_symbolSelect, 
                  i_FourDigit => r_FourDigit, o_display1 => o_display1, o_display2 => o_display2, o_display3 => o_display3, o_display4 => o_display4, i_data_value => r_data_value);
        
    T17_M3_ModulationShemes : entity work.T17_M3_modulationShemes (Behavioral) 
        Port map (i_clk => r_SystemClock, i_CE2Hz => r_CE2Hz, i_reset => i_reset, 
                  i_output1 => r_output1 , i_output2 => r_output2, i_SwitchErr => r_switchErr,
                  o_Ready_to_recieve => r_Ready_to_receive, i_Ready_to_Send => r_Ready_to_Send, 
                  i_FourDigit => r_FourDigit,i_symbolSelect => r_symbolSelect, o_CRCcount => r_CRCcount,
                  o_sim_out_QAM => r_sim_out_QAM, o_sim_out_PSK => r_sim_out_PSK);    
    
    T17_M2_DataGenerator : entity work.T17_M2_DataGenerator(Behavioral)             --Pass  variables into the data generator and out from
        Port map (  i_digitSelect => r_digitSelect, i_switchMod => r_switchMod, i_switchErr => r_switchErr, i_0toF => r_0toF, i_RandomNumber => r_RandomNumber,
                    i_systemClock => r_SystemClock,i_Ready_to_receive => r_Ready_to_receive, o_Ready_to_Send => r_Ready_to_Send,
                    i_SymbolCount1hz => r_SymbolCount1Hz, i_ce1Hz => r_ce1Hz, i_tempCount => r_tempCount, i_symbolSelect => r_symbolSelect,
                    i_segmentCountValue => r_segmentCounterValue, o_output1 => r_output1, o_output2 => r_output2, o_output3 => r_output3, o_output4 => r_output4, o_FourDigit => r_FourDigit, o_data_value => r_data_value);
    
end Behavioral;
