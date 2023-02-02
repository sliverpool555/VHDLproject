----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Billy Horton UP886508 and Samuel Gandy UP861111
-- 
-- Create Date: 04.01.2021 11:49:41
-- Design Name: Billy Horton UP886508 and Samuel Gandy UP861111
-- Module Name: Channel Block - Behavioral
-- Project Name: MileStone 3 VHDL
-- Target Devices: BAYS3 Board
-- Tool Versions: 5.0
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity T17_M3_Channel_Block is
  Port  (i_reset : in STD_LOGIC;                            --Reset Input
         i_I_Norm : in STD_LOGIC_VECTOR (7 downto 0);       --Input I wave without Noise
         i_Q_Norm : in STD_LOGIC_VECTOR (7 downto 0);       --Input Q Wave without noise
         i_CE16Hz : in STD_LOGIC;                           --Clock enable at 16Hz
         i_Clk : in STD_LOGIC;                              --System Clock
         i_Error_Select : in STD_LOGIC_VECTOR (1 downto 0); --Error select switches to control errors
         o_I_Rand : out STD_LOGIC_VECTOR (7 downto 0);      --Output I wave with Noise
         o_Random : out STD_LOGIC_VECTOR (7 downto 0);      --Output Random Value for Debugging
         o_Q_Rand : out STD_LOGIC_VECTOR (7 downto 0));     --Output Q wave with Noise
end T17_M3_Channel_block;

architecture Behavioral of T17_M3_Channel_Block is

signal r_Random_Value : std_logic_vector(7 downto 0);       --Output of the Random number entity set to this signal
signal r_PlusMinus : std_logic;                             --Toggles whether the noise is positive or negative

begin
process (i_I_Norm, i_Q_Norm, r_Random_Value,r_PlusMinus)
begin
    if r_PlusMinus = '0' then                               --Chooses whether to plus or minus the random value
        o_I_Rand <= i_I_Norm + r_Random_Value;              -- Applies positive noise to the I Wave
        o_Q_Rand <= i_Q_Norm + r_Random_Value;              -- Applies positive noise to the Q Wave
    else
        o_I_Rand <= i_I_Norm - r_Random_Value;              -- Applies negative noise to the I Wave
        o_Q_Rand <= i_Q_Norm - r_Random_Value;              -- Applies negative noise to the Q Wave
    end if;    
end process ;
    
 Random_Number : entity work.Random_Number(Behavioral)      --Instantiate the Random Number Entity
        port map (clk => i_Clk,i_reset => i_reset, o_Random_Value => r_Random_Value, i_Error_Select => i_Error_Select, o_PlusMinus => r_PlusMinus); 
              
end Behavioral;

