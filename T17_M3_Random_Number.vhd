----------------------------------------------------------------------------------
--Team 17 UP861111 
--Company: University of Portsouth
--Engineers Sameul Gandy
-- Create Date: 26/10/2020
-- Module Name: Random Number - Behavioral
-- Project Name: Basys 3 Hello World Demo
-- Target Devices: Basys 3 Artix7 XC7A35T cpg236 -1 
--- Description: Basys 3 Hello VHDL World - Clock Enable entity 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Random_Number is
Port ( clk : in STD_LOGIC;                                  --Pass through the system clock
       i_reset : in STD_LOGIC;                              --I_reset
       i_Error_Select : in STD_LOGIC_VECTOR (1 downto 0);   --error select from the buttons. This increase and decreases the error value
       o_PlusMinus : out std_logic;                         --plus or minus to control if the random number is taken away or added
       o_Random_Value : out STD_LOGIC_VECTOR (7 downto 0)); --the random number
end Random_Number;

architecture Behavioral of Random_Number is

signal r_Shift: STD_LOGIC_VECTOR(7 downto 0) := x"01";      --The number shofted between registers
signal r_tap : STD_LOGIC := '0';                            --r_tap is the next signal
signal r_Random_Result : STD_LOGIC_VECTOR(7 downto 0);      --the random result signal storing the result before outputted

begin

process(clk, r_tap, r_Random_result)                        --start process
begin

if rising_edge(clk) then                                    --if the system clock pulses
   if (i_reset='1') then                                    --if rest is high
      r_Shift <= x"01";                                     --shift is reset to first register
   else
      r_tap <= r_Shift(1) XNOR r_Shift(0);                  --the tap is the shift 1 oppsite Or to the shift 0
      r_Shift <= r_tap & r_Shift(7 downto 1);               --Add the r_tap and the shift to each other to incerase the size of the shift number
   end if;
   if (i_Error_select = "01") then                          --if error select is 01 then +-16
        r_Random_Result <= "0000" & r_Shift(3 downto 0);    --set the random result to 3 to 0 bits 
   elsif (i_Error_select = "10") then                       -- +-32
        r_Random_Result <= "000" & r_Shift(4 downto 0);     --set the random result to 4 to 0 bits
   elsif (i_Error_select = "11") then                       
        r_Random_Result <= "00" & r_Shift(5 downto 0);      --set the random result to 5 to 0 bits
   else r_Random_Result <= "00000000";                      -- No Error --else set the random result to 000000000

   end if;
end if;
end process;

o_PlusMinus <= r_Shift(6);          --set the plus minus to the r_shift
o_Random_Value <= r_Random_Result;  --output the random result back to the channel

end Behavioral;