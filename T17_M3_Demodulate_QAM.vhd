----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2021 11:49:21
-- Design Name: 
-- Module Name: Demodulate_QAM - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity T17_M3_Demodulate_QAM is
  Port ( i_Clk : in STD_LOGIC;					--system clock
         i_reset : in STD_LOGIC;				--the reset
         i_CRCcount : in std_logic_vector (1 downto 0);		--CRC count
         i_Wave_Count : in STD_LOGIC_VECTOR (2 downto 0);	--wave count
         i_I_Wave_in : in STD_LOGIC_VECTOR (7 downto 0);	--I wave in (1 8bit at a time)
         i_Q_Wave_in : in STD_LOGIC_VECTOR (7 downto 0);	--Q wave in (1 8bit at a time)
         i_Ready_To_Send : in std_logic;			--ready to send RS232 protocal
         o_Ready_to_Recieve : out STD_LOGIC:='1';		--ready to receive 9RS232 protocal)
         o_Sym_Er : out std_logic;				--For debugging
         o_Sym_Out : out STD_LOGIC_VECTOR (1 downto 0));	--output bits
end T17_M3_Demodulate_QAM;

architecture Behavioral of T17_M3_Demodulate_QAM is

signal r_IInt : integer range 0 to 255;			--IInt is integer for stroing the I
signal r_QInt : integer range 0 to 255;			--QInt is integer for stroing the I
Signal r_Wave_Count_Int : integer range 0 to 7;		--WAVE COUNT FOR RS232
signal VarI2 : integer range 0 to 255;			--stores the value I at the first peak
signal VarQ2 : integer range 0 to 255;			--stores the value Q at the first peak
signal VarI6 : integer range 0 to 255;			--stores the value I  at the second peak
signal VarQ6 : integer range 0 to 255;			--stores the value Q at the second peak
signal r_CRCPass : std_logic_vector (1 downto 0);	--CRC varaible
signal r_Sym_out : std_logic_vector (1 downto 0);	--The symbols out

begin
r_IInt <= to_integer(unsigned(i_I_Wave_In));		--convert the I value in to std_logic vector to integer
r_QInt <= to_integer(unsigned(i_Q_Wave_In));		--convert the Q value in to std_logic vector to integer
r_Wave_Count_Int <= to_integer(unsigned(i_Wave_Count)); --convert the wave count value in to std_logic vector to integer

T17_M3_Demodulate : process (i_Clk, r_IInt, r_QInt, r_Wave_Count_Int, VarI2, VarQ2, VarI6, VarQ6, r_CRCPass, i_Ready_To_Send)
begin

if rising_edge(i_Clk) then		--if the clock is high
    if i_Ready_to_Send = '1' then	--if read to send is received
    if i_reset = '1' then		--if the reset is received
        o_Ready_to_Recieve <= '1';	--Ready to recieve is 1
        VarI2 <= 0;            		--Integers reset            
        VarQ2 <= 0;
        VarI6 <= 0;   
        VarQ6 <= 0;
    else 
        if r_Wave_Count_Int = 2 then	--if the wave count equals 2
            o_Ready_to_Recieve <= '0';	--if ready to receive is 0
            VarI2 <= r_IInt;            -- varibales 2 equal the input at the first peak          
            VarQ2 <= r_QInt;       
        elsif r_Wave_Count_Int = 6 then --If wave count is 6 then
            VarI6 <= r_IInt;   		--set the vars at 6 to the inputs for the second peak
            VarQ6 <= r_QInt;
        end if;
                 
        if r_Wave_Count_Int = 7 then 	--if wave count is 7 then
            if VarI2 > 128 then 	--if the var is above threshold
                VarI2 <= 255; 		--var2 equals 255
            elsif   VarI2 < 128 then  
                VarI2 <= 0;  		--var equals 2 if not 255
            end if;
            
            if VarI6 > 128 then 	--if the var is greater then 128 (threshold)
                VarI6 <= 255; 		--VarI is equal to 255
            elsif   VarI6 < 128 then  	--VarI6 is
                VarI6 <= 0;  		--Var is set to 0
            end if;   
                     
            if VarI6 > 128 then 	--if the varI6 is greater then 128
                VarI6 <= 255; 		--Var6 is 255
            elsif   VarI6 < 128 then    --if varI6 is less then 128 then
                VarI6 <= 0;  		--set the varI6 to 0
            end if;
                       
            if VarQ6 > 128 then 	--if the varQ6 is greater then 128 
                VarQ6 <= 255; 		--the peak is high at the end so it is eqaul to 255
            elsif   VarQ6 < 128 then   
                VarQ6 <= 0;  		--if below 128 set the VarQ6 to 0
            end if;
                    
            else
                if (((VarI2=255)AND(VarQ2=255))OR((VarI6=0)AND(VarQ6=0))) then 		--Analysis of the two points for 00
                     r_Sym_out <= "00";							--Symbols out equal 00
                     o_Sym_Er <= '0';							--redant debugging variable. 
                     o_Ready_to_Recieve <= '1';						--Ready to send
                     
                elsif (((VarI2=255)AND(VarQ2=0))OR((VarI6=0)AND(VarQ6=255))) then	--Analysis of the two points for 00
                     r_Sym_out <= "01";							--set the sim out to 10
                     o_Sym_Er <= '0';							--redant debugging variable. 
                     o_Ready_to_Recieve <= '1';
                     
                elsif (((VarI2=0)AND(VarQ2=255))OR((VarI6=255)AND(VarQ6=0))) then	--Analysis of the two points for 00
                     r_Sym_out <= "10";							--set the sim out to 10
                     o_Sym_Er <= '0';							--redant debugging variable. 
                     o_Ready_to_Recieve <= '1';						--Ready to send other packet 
                     
                elsif (((VarI2=0)AND(VarQ2=0))OR((VarI6=255)AND(VarQ6=255))) then	--Analysis of the two points for 00 
                     r_Sym_out <= "11";							--set the sim out to 11
                     o_Sym_Er <= '0';							--redant debugging variable. 
                     o_Ready_to_Recieve <= '1';						--Ready to send other packet 
                else
                     o_Sym_Er <= '1';							--redant debugging variable and set to 1
                     o_Ready_to_Recieve <= '0';  					--Not ready to receive  
                end if;                       
            end if;       
        end if;
    end if;
end if;
end process T17_M3_Demodulate;

process (i_CRCcount, r_Sym_Out, r_CRCpass)
begin
    if i_CRCcount = "00" then
    r_CRCpass <= "00";                          --Resets the CRC check
        if r_Sym_Out = "00" then                --Checking for first symbol being correct
            r_CRCpass(0) <= '1';                --Passes the check
        else
            r_CRCpass(0) <= '0';                --Fails the check
        end if;
    elsif i_CRCcount = "01" then                
        if r_Sym_Out = "00" then                --Checking for first symbol being correct
            r_CRCpass(1) <= '1';                --Passes the check
        else
            r_CRCpass(1) <= '0';                --Fails the check
        end if;
    end if;
    
    if r_CRCpass = "11" then                    --If both checks pass
        o_Sym_Out <= r_Sym_Out;                 --Update the output
    end if;

end process;

end Behavioral;
