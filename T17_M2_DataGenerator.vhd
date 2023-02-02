----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 20.11.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_Data_Generator - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T17_M2_DataGenerator is
   Port (   i_digitSelect : in STD_LOGIC_VECTOR (3 downto 0);           --Selects the digit on the display 
            i_switchMod : in STD_LOGIC_VECTOR (2 downto 0);             --i_switchMod the switches for the modulation
            i_switchErr : in STD_LOGIC_VECTOR (1 downto 0);             --i_switchErr the switches for the error
            i_0toF : in STD_LOGIC_VECTOR (6 downto 0);                  --The 7-seg binary value of the 0 to F 
            i_RandomNumber : in STD_LOGIC_VECTOR (6 downto 0);          --The 7-Seg binary value of the random number
            i_SymbolCount1Hz : in STD_LOGIC_VECTOR (3 downto 0);        --The 7-Seg binary value of i_SymbolCount1Hz
            i_tempCount : in STD_LOGIC;                                 --Toggle between tens and units in temperature 
            i_symbolSelect : in STD_LOGIC;                              --Toggle between symbols generated in the symbol generator
            i_segmentCountValue : in STD_LOGIC_VECTOR (1 downto 0);     --Used in the XADC temp for averaging and display
            i_CE1Hz : in std_logic;                                     --The 1Hz clock enable
            i_systemClock : in std_logic;                               --System clock
            o_Ready_To_Send : out std_logic;
            i_Ready_to_Receive : in STD_LOGIC;
            
            o_output1 : out std_logic_VECTOR (6 downto 0);              --output display 1
            o_output2 : out std_logic_VECTOR (6 downto 0);              --output display 2
            o_output3 : out std_logic_VECTOR (6 downto 0);              --output display 3
            o_output4 : out std_logic_VECTOR (6 downto 0);
            o_FourDigit : out STD_LOGIC_VECTOR (7 downto 0);
            o_data_value : out STD_LOGIC_VECTOR (6 downto 0));             --output display 4
        
end T17_M2_DataGenerator;

architecture Behavioral of T17_M2_DataGenerator is
    
    component xadc_wiz_0 is 
    Port (  daddr_in : in STD_LOGIC_VECTOR (6 downto 0); --Address bus for dynamic reconfiguration port
            den_in : in STD_LOGIC;                       --Enable signal for dynamic reconfiguration
            di_in : in STD_LOGIC_VECTOR (15 downto 0);   --Input data bus for the dynamoc reconfiguration
            dwe_in : in STD_LOGIC;                       --write enable for the dynamoc reconfiguration
            do_out : out STD_LOGIC_VECTOR (15 downto 0); --Output data bus for dynamic reconfiguration
            drdy_out : out STD_LOGIC;                    --Data ready signal for dynamoc reconfiguration
            dclk_in : in STD_LOGIC;                      --Clock input for dynamoc reconfiguration
            reset_in : in STD_LOGIC;                     --Reset signal for the dynamoc reconfiguration
            busy_out : out STD_LOGIC;                           --ADC busy signal
            channel_out : out STD_LOGIC_VECTOR (4 downto 0);    --Channel selection outputs
            eoc_out : out STD_LOGIC;                            --end of conversional signal
            eos_out : out STD_LOGIC;                            --End of Sequence signal
            alarm_out : out STD_LOGIC;                          --output from all alerms 
            vp_in : in STD_LOGIC;                               --Deicte Analog input pair
            vn_in : in STD_LOGIC;                               
            vccaux_alarm_out : out  STD_LOGIC;                  -- VCCAUX-sensor alarm output
            vccint_alarm_out : out  STD_LOGIC;                  -- VCCINT-sensor alarm output
            user_temp_alarm_out : out  STD_LOGIC;               --temp alerm output (Over heating alert) 
            ot_out : out STD_LOGIC);                
    end component;
    
    signal r_ST1Output : STD_LOGIC_VECTOR (6 downto 0);     --signal student number output for 1 
    signal r_ST2Output : STD_LOGIC_VECTOR (6 downto 0);     --signal student number output for 2
    
    --XADC variables
    signal ADCintcon : STD_LOGIC_VECTOR (11 downto 0);      --The output from the ADC
    signal Waitintcon : STD_LOGIC_VECTOR (3 downto 0);      --The spare from the ADC register (Least Significate bit) 
    signal EnableInt : STD_LOGIC:= '1';                     --Enables the ADC
    signal r_tempNum : STD_LOGIC_VECTOR (6 downto 0);       --The temperature as a number. 
    
    signal r_dataValue : STD_LOGIC_VECTOR (6 downto 0);     --The output from the data generator
    
   

begin

    T17_M2_StudentNumber1 : entity work.T17_M2_StudentNumber1(Behavioral)       --Student number entity and passing variables in and out
        Port map (o_ST1Output => r_ST1Output, i_SymbolCount => i_SymbolCount1Hz);

    T17_M2_StudentNumber2 : entity work.T17_M2_StudentNumber2(Behavioral)       --Student number entity and passing variables in and out
        Port map (o_ST2Output => r_ST2Output, i_SymbolCount => i_SymbolCount1Hz);

    T17_M2_XADCtemp : entity work.T17_M2_XADCtemp(Behavioral)       --XADC temp entity and passing variables in and out
           Port map (i_XADCoutput => ADCintcon, o_temp => r_tempNum, i_TempCount => i_TempCount, i_clk => i_CE1Hz, i_segmentCount => i_segmentCountValue);
           
    T17_M2_SymbolConverter : entity work.T17_M2_SymbolConverter(Behavioral)     --Symbol Converter entity and passing variables in and out
        Port map (o_Output1 => o_Output1, o_Output2 => o_Output2, 
        o_Ready_To_Send =>o_Ready_To_Send, i_Ready_To_Receive => i_Ready_To_Receive,
        i_dataValue => r_dataValue, i_SymbolSelect => i_SymbolSelect, 
        o_FourDigit => o_FourDigit, i_Clk => i_Systemclock);
        
    T17_M2_SwitchBoard : entity work.T17_M2_SwitchBoard(Behavioral)     --Switch Board entity and passing variables in and out
        Port map (i_digitSelect => i_digitSelect, i_switchMod => i_switchMod, i_switchErr => i_switchErr, i_ST1Output => r_ST1Output, i_ST2Output => r_ST2Output, i_0toF => i_0toF, o_Output3 => o_Output3, o_Output4 => o_Output4, i_RandomNumber => i_RandomNumber, i_TempNum => r_tempNum);
        
    ADCimp: xadc_wiz_0 
        Port map ( daddr_in => "0000000",               --The address of the input register
                   den_in   => EnableInt,               --The den_in is 1
                   di_in    => (others => '0'),         --di_in is 0
                   dwe_in   => '0',                     --dwe is 0
                   do_out (15 downto 4) => ADCintcon,   --Set the output register
                   do_out (3 downto 0) => Waitintcon,   --set the spare register
                   dclk_in  => i_systemClock,           --dclk_in to the system clock
                   reset_in => '0',                     --reset equals 0
                   busy_out => open,                    --the busy output equas 0
                   channel_out => open,                 --channel is open
                   eoc_out => EnableInt,                --eoc is 1
                   eos_out => open,                     --eos is open
                   alarm_out => open,                   --ADC Alerm is open pin meaning it does not matter if 1 or 0
                   vp_in => '0',                        --vp in is 0 so grouned
                   vn_in => '0',                        --vn in is 0 so grouned
                   ot_out => open,                      --ot out is open pin
                   vccaux_alarm_out => open,            --Alerm outs to open
                   vccint_alarm_out => open,            --Alerm outs to open
                   user_temp_alarm_out => open);        --Set the temp alerm to open
    
with i_digitSelect select                           --With the digit select
        r_DataValue <=  "1001111" when "0000",      --when 0000 data value equals 1
                        "0001111" when "0001",      --when 0000 data value equals 2
                        "1000010" when "0010",      --when 0000 data value equals 3
                        "0000000" when "0011",      --when 0000 data value equals 4
                        i_0toF    when "0100",      --when 0000 data value equals O to F number
                        i_RandomNumber when "0101", --when 0000 data value equals random number
                        r_ST1Output when "0110",    --when 0000 data value equals Student Number 1 output
                        r_ST2Output when "0111",    --when 0000 data value equals Student Number 2 output
                        r_TempNum when "1000",      --when 0000 data value equals Temperature output
                        "0000001" when "1111",      --When 1111 is 0000 on teh display 
                        r_TempNum when others;       --When others set it to 0
o_Data_Value <= r_DataValue;
end Behavioral;

