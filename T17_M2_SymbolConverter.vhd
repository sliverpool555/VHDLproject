----------------------------------------------------------------------------------
-- Company: University of Portsmouth
-- Engineer: Samuel Gandy (UP861111)  and Billy Horton(UP886508)
-- 
-- Create Date: 29.11.2020 16:34:45
-- Design Name: UP861111_UP885608_Milestone 2
-- Module Name: T17_M2_SymbolConverter - Behavioral
-- Project Name: UP861111_UP885608_Milestone 2
-- Target Devices: BAYS3 Board
-- Tool Versions:  Vivado 2020.1
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


--Digital Modulation Entity

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;   --Required for type conversions

entity T17_M2_SymbolConverter is
Port (i_DataValue : in STD_LOGIC_VECTOR (6 downto 0);       --The datavalue stores the 7-seg binary value
      i_Clk : in std_logic;
      i_Ready_To_Receive : in std_logic;
      o_Ready_To_Send : out std_logic;
      i_SymbolSelect : in STD_LOGIC;                        --1 bit binary value for 
      o_Output1 : out STD_LOGIC_VECTOR (6 downto 0);        --Stores value for the first display
      o_Output2 : out STD_LOGIC_VECTOR (6 downto 0);
      o_FourDigit : out STD_LOGIC_VECTOR (7 downto 0));       --Stores value for the second display
end T17_M2_SymbolConverter;

architecture Behavioral of T17_M2_SymbolConverter is

      signal r_FourDigit : STD_LOGIC_VECTOR (7 downto 0);   --signal that passes the binary value to the bit seperation algirthm 
      signal r_symbolSelect : integer range 0 to 1;         --signal that is a 1 or 0 to chose what display to use

begin

  process (i_DataValue, i_Ready_To_Receive, r_FourDigit)
    begin
    if i_Ready_To_receive = '1' then                        --if ready to receive then look at the data value for the case statement
        case i_DataValue is
            when "0000001" => r_FourDigit <= "00000000";    --when 0 in 7-seg is 0 for fourdigit (Which is 8bit)
            when "1001111" => r_FourDigit <= "00000001";    --when 1 in 7-seg is 1 for fourdigit (Which is 8bit)
            when "0010010" => r_FourDigit <= "00000010";    --when 2 in 7-seg is 2 for fourdigit (Which is 8bit)
            when "0000110" => r_FourDigit <= "00000011";    --when 3 in 7-seg is 3 for fourdigit (Which is 8bit)
            when "1001100" => r_FourDigit <= "00000100";    --when 4 in 7-seg is 4 for fourdigit (Which is 8bit)
            when "0100100" => r_FourDigit <= "00000101";    --when 5 in 7-seg is 5 for fourdigit (Which is 8bit)
            when "0100000" => r_FourDigit <= "00000110";    --when 6 in 7-seg is 6 for fourdigit (Which is 8bit)
            when "0001111" => r_FourDigit <= "00000111";    --when 7 in 7-seg is 7 for fourdigit (Which is 8bit)
            when "0000000" => r_FourDigit <= "00001000";    --when 8 in 7-seg is 8 for fourdigit (Which is 8bit)
            when "0000100" => r_FourDigit <= "00001001";    --when 9 in 7-seg is 9 for fourdigit (Which is 8bit)
            when "0001000" => r_FourDigit <= "00001010";    --when 10 in 7-seg is A for fourdigit (Which is 8bit)
            when "1100000" => r_FourDigit <= "00001011";    --when 11 in 7-seg is B for fourdigit (Which is 8bit)
            when "0110001" => r_FourDigit <= "00001100";    --when 12 in 7-seg is C for fourdigit (Which is 8bit)
            when "1000010" => r_FourDigit <= "00001101";    --when 13 in 7-seg is D for fourdigit (Which is 8bit)
            when "0110000" => r_FourDigit <= "00001110";    --when 14 in 7-seg is E for fourdigit (Which is 8bit)
            when "0111000" => r_FourDigit <= "00001111";    --when 15 in 7-seg is F for fourdigit (Which is 8bit)
            when others =>r_FourDigit <= x"";               --when others dont care about tehe output (stay the same)
        end case;
    end if;
    end process ;
    
        --Bit Separation Algorithm
        o_Ready_To_Send  <= '1';
        o_FourDigit <= r_FourDigit;
    
         T17_M2_BitOutput : process  (i_SymbolSelect, r_FourDigit, i_clk )
         begin
         if rising_edge(i_Clk) then
            o_Ready_To_Send <= '1';
             if i_SymbolSelect = '0' then       --if the smybol select is 0 then
                if (r_FourDigit(0)  = '0') then   -- and the first digit of the combined digits 
                    o_Output1 <= "0000001";     --output a 0 on display 2
                else 
                    o_Output1 <= "1001111";     --otherwise display a 1 on dispaly 2
                end if;
                
                if r_FourDigit(1) = '0' then    --if the second digit is 0
                    o_Output2 <= "0000001";     --output a 0 on display 1
                else
                    o_Output2 <= "1001111";     --otherwise set display 1 to 0
                end if; 
                
             else
                if r_FourDigit(2) = '0' then    --if the thrid digit is 0  
                    o_Output2 <= "0000001";     --then output  is 0
                else
                    o_Output2 <= "1001111";     --if the thrid digit is a 1 then display one
                end if;
                
                if r_FourDigit(3) = '0' then    --If forth digit is 0 
                     o_Output1 <= "0000001";    --Then the output is 0 on output 1
                else
                    o_Output1 <= "1001111";     --If a 1 then display a 1
                end if;
            end if;
          end if;
        end process T17_M2_BitOutput;
end Behavioral;
