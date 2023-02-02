----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.01.2021 15:15:46
-- Design Name: 
-- Module Name: T17_M3_ModulationShemes - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity T17_M3_ModulationShemes is
    Port (  i_clk : in STD_LOGIC;                               --the system clock
            i_ce2Hz : in STD_LOGIC;                             --2Hz clock enable
            i_reset : in STD_LOGIC;                             --The reset 
            i_FourDigit : in std_logic_vector(7 downto 0);      --Four digits from the symbol converter
            i_SymbolSelect : in std_logic;                      --symbol select from data generator
            i_Ready_To_Send : in std_logic;                     --ready to send from the multicounter to active the signal
            o_Ready_to_Recieve : out STD_LOGIC;                 --Ready to receive signal to be sent to verdict
            o_CRCcount : out std_logic_vector(1 downto 0);      --CRC logic bits to be passed to verdict
            i_Output1 : in STD_LOGIC_VECTOR (6 downto 0);       --output1 from symbol Converter
            i_Output2 : in STD_LOGIC_VECTOR ( 6 downto 0);      --output2 from symbol converter
            i_SwitchErr : in STD_LOGIC_VECTOR (1 downto 0);     --The input after debounce
            o_sim_out_QAM : out STD_LOGIC_VECTOR (1 downto 0);  --The Output from the QAM in 7-segment binary
            o_sim_out_PSK : out STD_LOGIC_VECTOR (1 downto 0)); --Output from PSK demodulation in 7-segment binary
end T17_M3_ModulationShemes;

architecture Behavioral of T17_M3_ModulationShemes is
    signal r_CE16Hz : STD_LOGIC;                            --16Hz clock enable
    signal r_CE4Hz : STD_LOGIC;                             --4hz clock enable for CRC
    signal r_CRCcount : std_logic_vector(1 downto 0);       --CRC count. 4 bits to count them in
    signal r_Wave_Count : std_logic_vector(2 downto 0);     --WaveCount, this counts in the parts of the wave
    signal input_bits : STD_LOGIC_VECTOR (1 downto 0);      --the input bits after converson that go into the modulation shemes
    signal o_outputBits : STD_LOGIC_VECTOR (1 downto 0);    --output from the demod
    signal r_Ready_to_Recieve_QAM : STD_LOGIC;              --ready to recieve for QAM Demodulation
    signal r_Ready_to_Recieve_QPSK : STD_LOGIC;             --ready to receive PQSK for Demodulation
    
begin

    process (r_Ready_to_Recieve_QAM, r_Ready_to_Recieve_QPSK)
    begin
    
        if (r_Ready_to_Recieve_QPSK = '1') AND (r_Ready_to_Recieve_QAM = '1') then  
            o_Ready_to_Recieve <= '1';  --If ready to receive is high for both set ready to receive
        else
            o_Ready_to_Recieve <= '0';  --If ready to receive is LOW then dont set to receive     
        end if;
    
    end process;
    
    process (r_CE4HZ, r_CRCcount, i_Reset)
    begin
    if i_Reset = '1' then                   --reset is high then CRC is reset to 00
        r_CRCcount <= "00";
    end if;
    if rising_edge(r_CE4Hz) then            --if 4Hz counter 
        if r_CRCcount = "11" then           --if the CRC is 4hz
            r_CRCcount <= "00";             --CRC is 00
        else
            r_CRCcount <= r_CRCcount + '1'; --if at 4Hz but not 11 count up by 1
        end if;
    end if;
    o_CRCcount <= r_CRCcount;               --set the CRC to the CRC
    end process;

    segToBits : process (i_FourDigit, r_CRCcount)
    begin 
        if r_CRCcount = "00" then           --If the CRC is 00 then
            if (i_FourDigit(6) = '0') then  --If fourDigits sixth bit is 0 then
                input_bits(0) <= '0';       --set the Input but to 0
            else
                input_bits(0) <= '1';       --If fourDigits sixth bit is 1 then set input bits to 1
            end if;
        
            if (i_FourDigit(7) = '0') then  --If fourDigits sixth bit is 0 then
                input_bits(1) <= '0';       --set the Input but to 0
            else
                input_bits(1) <= '1';       --If fourDigits seventh bit is 1 then set input bits to 1
            end if;
        elsif r_CRCcount = "01" then        --if CRC count is 01 
            if (i_FourDigit(4) = '0') then  --If the fourth bit of fourth digit is 0 
                input_bits(0) <= '0';       --set the Input but to 0
            else
                input_bits(0) <= '1';       --set the Input but to 1
            end if;
        
            if (i_FourDigit(5) = '0') then  --If the fith bit of fourth digit is 0 
                input_bits(1) <= '0';       --set the Input but to 0
            else
                input_bits(1) <= '1';       --set the Input but to 1
            end if;   
        elsif r_CRCcount = "10" then        --CRC count is 10 (2)
            if (i_FourDigit(0) = '0') then  --Fourth Digit at bit 0 is equal to 0
                input_bits(0) <= '0';       --set the Input but to 0
            else
                input_bits(0) <= '1';       --set the Input but to 1
            end if;
        
            if (i_FourDigit(1) = '0') then  --Fourth Digit at bit 2 is equal to 0
                input_bits(1) <= '0';       --Input_bits 1 is equal to 0
            else
                input_bits(1) <= '1';       --Input_bits 1 is equal to 1
            end if;
        else
            if (i_FourDigit(2) = '0') then  --Four Digit (2) is equal to 0
                input_bits(0) <= '0';       --Input_bits 0 is equal to 0
            else
                input_bits(0) <= '1';       --Input_bits 0 is equal to 1
            end if;
        
            if (i_FourDigit(3) = '0') then  --Four Digit (3) is equal to 0
                input_bits(1) <= '0';       --Input_bits 1 is equal to 0
            else
                input_bits(1) <= '1';       --Input_bits 1 is equal to 1
            end if;
        end if;
    end process segToBits;
    
    
    MODEM : entity work.MODEM(Behavioral)                                       --Passing the variables in the QPSK modem
        Port map (i_Sym_In => input_bits, o_Sym_Out => o_Sim_Out_Psk,
        o_Ready_to_recieve => r_Ready_to_recieve_QPSK, i_Ready_to_Send => i_Ready_to_Send,
         i_Systemclock => i_Clk, i_CE16Hz => r_CE16Hz, i_Wave_Count => r_Wave_Count,
         i_CRCcount => r_CRCcount, 
        i_Reset => i_Reset, i_Error_Select => i_SwitchErr, i_CE2Hz => i_ce2Hz);
    
    T17_M3_MultiCounter16Hz : entity work.T17_M3_multiCounter16Hz (Behavioral)      --Passing the variables into the Multi counter 16Hz to control speed of the QAM and QPSK
        Port Map (i_Clk => i_clk, i_Reset => i_Reset, o_Wave_Count => r_Wave_Count); 
        
    T17_M3_ClockEnable16Hz : entity work.T17_M3_ClockEnable16Hz (Behavioral)        --Passing the variables into the clock enable 16Hz to control speed of the QAM and QPSK
        Port Map (i_Clk => i_clk, i_Reset => i_Reset, o_CE => r_CE16Hz);

    ClockEnable4Hz : entity work.ClockEnable4Hz (Behavioral)                        --Passing the variables into the clock enable 4Hz for CRC
        Port Map (i_Clk => i_clk, i_Reset => i_Reset, o_CE => r_CE4Hz);

    T17_M3_Modem : entity work.T17_M3_Modem (Behavioral)                            --Passing the variables in the QAM modem
        port map (i_Sym_In => input_bits, o_Sym_Out => o_Sim_Out_QAM,
                    o_Ready_to_recieve => r_Ready_to_recieve_QAM, i_Ready_to_Send => i_Ready_to_Send,
                    i_Systemclock => i_Clk, i_CE16Hz => r_CE16Hz, i_Wave_Count => r_Wave_Count,
                    i_CRCcount => r_CRCcount, 
                    i_Reset => i_Reset,i_Error_Select => i_SwitchErr, i_CE2Hz => i_ce2Hz);
end Behavioral;
