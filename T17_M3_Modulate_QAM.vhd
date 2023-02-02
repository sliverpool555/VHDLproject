----------------------------------------------------------------------------------
--Team 17 UP861111 
--Company: University of Portsouth
--Engineers Sameul Gandy
-- Create Date: 21/01/2021
-- Module Name: QAM modulation- Behavioral
-- Target Devices: Basys 3 Artix7 XC7A35T cpg236 -1 
--- Description: Basys 3 Hello VHDL World - Clock Enable entity 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity T17_M3_Modulate_QAM is
  Port ( i_Sym_In : in STD_LOGIC_VECTOR (1 downto 0);       --symbols in from data generator
         i_Wave_Count : in STD_LOGIC_VECTOR (2 downto 0);   --wave count as standard logic from 4hz clock
         i_Clk : in STD_LOGIC;                              --system clock
         i_reset : in STD_LOGIC;                            --reset
         o_Sent : out std_logic;                            --sent out the sent to the Demod. (RS232
         o_I : out STD_LOGIC_VECTOR (7 downto 0) ;          --output I 
         o_Q : out STD_LOGIC_VECTOR (7 downto 0));          --output Q
end T17_M3_Modulate_QAM;

architecture Behavioral of T17_M3_Modulate_QAM is

type Wave is array (7 downto 0) of std_logic_vector(7 downto 0);
signal Wave0 : Wave := ("10000000","01010000","01000000","01010000","10000000","10100000","11000000","10100000");   --The wave for a 0
signal Wave1 : Wave := ("10000000","10100000","11000000","10100000","10000000","01010000","01000000","01010000");   --The wave for a 1
signal r_Wave_count : integer range 0 to 7; --wave count in integer form
signal r_I : std_logic_vector (7 downto 0); --r_I the output I signal to this program. gets converted at the end
signal r_Q : std_logic_vector (7 downto 0); --r_Q the output Q signal to this program. gets converted at the end

begin
r_Wave_Count <= to_integer(unsigned(i_Wave_Count));     --convert the wave count to integer to be used as the index

process (i_Sym_In, i_Clk, r_Wave_Count)
begin
    if r_Wave_Count = 7 then        --if the wave count is 7 then
        o_Sent <= '1';              --sent out the bit
    elsif r_Wave_Count = 1 then     --if the wave count is 1 
        o_Sent <= '0';              --set the sent to 0 to reset the wave
    end if;
    if rising_edge (i_Clk) then         --if the system clock is rised
        if i_reset = '1' then           --i reset if high
            o_I <= "00000000";          --reset the I output
            o_Q <= "00000000";          --reset the Q output
        else
                if i_sym_In = "00" then                 --If the symbols from Data Generator are 01 then
                   o_I <= (Wave0(r_Wave_Count));    --Set the output I to the wave0 to element wave count
                   o_Q <= (Wave0(r_Wave_Count));    --Set the output Q to the wave0 to element wave count
                   o_Sent <= '1';

                elsif i_sym_In = "01" then              --If the symbols from Data Generator are 01 then
                   o_I <= (Wave0(r_Wave_Count));    --Set the output I to the wave0 to element wave count
                   o_Q <= (Wave1(r_Wave_Count));    --Set the output Q to the wave1 to element wave count 
                   o_Sent <= '1';

                elsif i_sym_In = "10" then              --If the symbols from Data Generator are 10 then
                   o_I <= (Wave1(r_Wave_Count));    --Set the output I to the wave1 to element wave count 
                   o_Q <= (Wave0(r_Wave_Count));    --Set the output Q to the wave0 to element wave count 
                   o_Sent <= '1'; 

                elsif i_sym_In = "11" then              --If the symbols from Data Generator are 11 then
                   o_I <= (Wave1(r_Wave_Count));    --Set the output I to the wave1 to element wave count 
                   o_Q <= (Wave1(r_Wave_Count));    --Set the output Q to the wave1 to element wave count 
                   o_Sent <= '1';                   --sent the final element in the array
                else
                   o_I <= x"";      --if there is nothing dont change
                   o_Q <= x"";      --if no input change nothing
                end if;                   
            end if;
        end if;                   
    end process;
end Behavioral;
