----------------------------------------------------------------------------------
--Team 17 UP861111 
--Company: University of Portsouth
--Engineers Sameul Gandy
-- Create Date: 26/10/2020
-- Module Name: ClockEnable16Hz - Behavioral
-- Project Name: Basys 3 Hello World Demo
-- Target Devices: Basys 3 Artix7 XC7A35T cpg236 -1 
--- Description: Basys 3 Hello VHDL World - Clock Enable entity 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity T17_M3_Modem is
         Port ( i_CE2Hz : in STD_LOGIC;                         --clock enable 2Hz
           i_Reset : in STD_LOGIC;                              --i reset
           i_CE16Hz : in STD_LOGIC;                             --clock enable 16Hz
           i_Systemclock : in std_logic;                        --system clock 
           i_Error_Select : in STD_LOGIC_VECTOR (1 downto 0);   --error selct from buttons
           i_Wave_Count : in STD_LOGIC_VECTOR (2 downto 0);     --wave count to count what element of the wave array
           i_Ready_To_Send : in std_logic;                      --RS232 Ready to send
           i_CRCcount : in std_logic_vector (1 downto 0);       --CRC count to check what bit is being used
           i_Sym_In : in STD_LOGIC_VECTOR (1 downto 0);         --input bits
           o_I_Norm : out STD_LOGIC_VECTOR (7 downto 0);        --Q from the modulation
           o_Q_Norm : out STD_LOGIC_VECTOR (7 downto 0);        --Q from the modulation
           o_Ready_to_Recieve : out STD_LOGIC;                  --output from ready to recieve
           o_Sym_Out : out STD_LOGIC_VECTOR (1 downto 0);       --bits out from the demod
           o_Sym_Er : out std_logic;                            --sys error
           o_Random : out STD_LOGIC_VECTOR (7 downto 0);        --the random numver
           
           o_SegmentCathodes : out STD_LOGIC_VECTOR (6 downto 0);       
           o_SegmentAnodes : out STD_LOGIC_VECTOR (3 downto 0 ));       
end T17_M3_Modem;

architecture Behavioral of T17_M3_Modem is
signal r_Sent : std_logic;                          --r_sent for modulation
signal r_Sym_O : STD_LOGIC_VECTOR (1 downto 0);     --symbols out to the verdict
signal r_I_Norm : STD_LOGIC_VECTOR (7 downto 0);    --The I signal between Tx and channel block
signal r_Q_Norm : STD_LOGIC_VECTOR (7 downto 0);    --The Q signal between Rx and channel block
signal r_I_Rand : STD_LOGIC_VECTOR (7 downto 0);    --The I signal between channel block and Rx
signal r_Q_Rand : STD_LOGIC_VECTOR (7 downto 0);    --The Q signal between channel block and Rx
    
begin
    
    T17_M3_Modulate_QAM : entity work.T17_M3_Modulate_QAM (Behavioral) --pass variables into the Modulate
        Port map(i_Clk => i_Systemclock, i_reset =>i_reset, 
        i_Sym_In => i_Sym_In, i_Wave_Count => i_Wave_Count,
        o_I  => r_I_Norm, o_Q  => r_Q_Norm, o_Sent => r_Sent);  
            
    T17_M3_Channel_Block : entity work.T17_M3_Channel_Block (Behavioral) --pass variables into the channel block
         Port map (i_CE16Hz => i_CE16Hz,i_Clk => i_Systemclock,
         i_reset =>i_reset, i_Error_Select => i_Error_Select,        
         i_I_Norm => r_I_Norm, i_Q_Norm => r_Q_Norm, 
         o_Random => o_Random,
         o_I_Rand => r_I_Rand, o_Q_Rand => r_Q_Rand); 
            
    T17_M3_Demodulate_QAM : entity work.T17_M3_Demodulate_QAM (Behavioral) --pass variables into the Demod
         Port map(i_Clk => i_SystemClock, i_Wave_Count => i_Wave_Count,
        i_I_Wave_in => r_I_Rand, i_Q_Wave_in => r_Q_Rand, i_reset =>i_reset,
        o_Sym_Er => o_Sym_Er,i_Ready_to_Send => i_Ready_to_Send,
        i_CRCcount => i_CRCcount,
        o_Sym_Out => o_Sym_Out, o_Ready_to_recieve => o_Ready_to_recieve);	   

end Behavioral;
