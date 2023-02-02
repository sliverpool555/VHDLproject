----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.01.2021 21:01:47
-- Design Name: 
-- Module Name: T17_M3_Verdict - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity T17_M3_Verdict is
Port (	i_clk : in STD_LOGIC;                                 --System Clock
		i_CE1Hz : in STD_LOGIC;                               --1Hz clock enable
		i_CE2Hz : in STD_LOGIC;                               --2Hz clock enable
		i_SymbolSelect : in std_logic;
		LEDsDG : out std_logic_vector(3 downto 0);
		i_sim_out_QAM : in STD_LOGIC_VECTOR (1 downto 0);     --output from QAM demod
		i_sim_out_QPSK : in STD_LOGIC_VECTOR (1 downto 0);     --output from QPSK demod
		i_output1 : in STD_LOGIC_VECTOR (6 downto 0);         --Output from symbol Converter
		i_output2 : in STD_LOGIC_VECTOR (6 downto 0);         --Output from symbol Converter
		i_output3 : in STD_LOGIC_VECTOR (6 downto 0);         --Output from Switch Board
		i_output4 : in STD_LOGIC_VECTOR (6 downto 0);         --Output from Switch Board
		i_switchDG : in STD_LOGIC_VECTOR (3 downto 0);        --Switches for the Data Generator
		i_CRCcount : in std_logic_vector (1 downto 0);
		i_switchMod : in STD_LOGIC_VECTOR (2 downto 0);       --Switch for the modulation
		i_data_value : in STD_LOGIC_VECTOR ( 6 downto 0);     --comes from data generator
		i_FourDigit : in STD_LOGIC_VECTOR (7 downto 0);       --Comes from Symbol converter as binary and needs to be convertered to 4 7-seg numbers
		o_display1 : out STD_LOGIC_VECTOR (6 downto 0);       --7-segment binary for  display driver 1
		o_display2 : out STD_LOGIC_VECTOR (6 downto 0);       --7-segment binary for  display driver 1
		o_display3 : out STD_LOGIC_VECTOR (6 downto 0);       --7-segment binary for  display driver 1
		o_display4 : out STD_LOGIC_VECTOR (6 downto 0));      --7-segment binary for  display driver 1
end T17_M3_Verdict;

architecture Behavioral of T17_M3_Verdict is
    
    type Qarray  is array (0 to 3) of STD_LOGIC_VECTOR ( 6 downto 0);
    signal QAM : Qarray := ("0000000","0000000","0000000","0000000");
    signal QPSK : Qarray := ("0000000","0000000","0000000","0000000");
    signal r_QPSK : Qarray := ("0000000","0000000","0000000","0000000");
    signal r_QAM : Qarray := ("0000000","0000000","0000000","0000000");
    type digitArray is array (0 to 3) of STD_LOGIC_VECTOR ( 6 downto 0);
    signal Digit : digitArray := ("0000000","0000000","0000000","0000000");
    
    signal j : integer range 0 to 2;
    signal i : integer range 0 to 4;                --stores integer value for the for loop
     
    signal k : integer range 0 to 2;
    signal g : integer range 0 to 4;                --stores integer value for the for loop
    
    signal u : integer range 0 to 4; 
    
    signal d : integer range 0 to 4;                --To switch between display
    signal r_Sym_Received : std_logic_vector(1 downto 0);
    
    signal QPSK1 : STD_LOGIC_VECTOR ( 6 downto 0);
    signal QPSK2 : STD_LOGIC_VECTOR ( 6 downto 0);
    signal QPSK3 : STD_LOGIC_VECTOR ( 6 downto 0);
    signal QPSK4 : STD_LOGIC_VECTOR ( 6 downto 0);
    
    signal r_QAM_Value : STD_LOGIC_VECTOR ( 3 downto 0);
    signal r_QPSK_Value : STD_LOGIC_VECTOR ( 3 downto 0);
    signal r_QAM_Out : STD_LOGIC_VECTOR ( 6 downto 0);
    signal r_QPSK_Out : STD_LOGIC_VECTOR ( 6 downto 0);
    
begin

convert : process (i_clk, i_sim_out_QAM,I_Sim_out_QPSK, QAM, QPSK, i_SymbolSelect, r_QAM_Out, r_QPSK_Out, r_QAM_Value, r_QPSK_Value)
begin
    --Now converting QAM  (I forgot the input is in 2 bits and needs to be added)
    
    if rising_edge(i_clk) then        --unsure on the clock maybe too slow
        if i_CRCcount = "10" then 
            r_QAM_Value(3)<=i_Sim_Out_QAM(1);
            r_QAM_Value(2)<=i_Sim_Out_QAM(0);
            if i_sim_out_QAM(0) = '0' then 
                 QAM(0) <= "0000001";
            else 
                 QAM(0) <= "1001111";
            end if;
            if i_sim_out_QAM(1) = '0' then 
                 QAM(1) <= "0000001";
            else 
                 QAM(1) <= "1001111";
            end if;
        elsif i_CRCcount = "11" then
            r_QAM_Value(1)<=i_Sim_Out_QAM(1);
            r_QAM_Value(0)<=i_Sim_Out_QAM(0);
            if i_sim_out_QAM(0) = '0' then 
                 QAM(2) <= "0000001";
            else 
                 QAM(2) <= "1001111";
            end if;
            if i_sim_out_QAM(1) = '0' then 
                 QAM(3) <= "0000001";
            else 
                 QAM(3) <= "1001111";
            end if;
            case r_QAM_Value is                              -- All Statements below are depended on segment count value
              when "0000" => r_QAM_out <= "0000001";
              when "0100" => r_QAM_out <= "1001111";
              when "1000" => r_QAM_out <= "0010010";
              when "1100" => r_QAM_out <= "0000110";
              when "0001" => r_QAM_out <= "1001100";
              when "0101" => r_QAM_out <= "0100100";
              when "1001" => r_QAM_out <= "0100000";
              when "1101" => r_QAM_out <= "0001111";
              when "0010" => r_QAM_out <= "0000000";
              when "0110" => r_QAM_out <= "0000100";
              when "1010" => r_QAM_out <= "0001000";
              when "1110" => r_QAM_out <= "1100000";
              when "0011" => r_QAM_out <= "0110001";
              when "0111" => r_QAM_out <= "1000010";
              when "1011" => r_QAM_out <= "0110000";
              when "1111" => r_QAM_out <= "0111000";
            end case;
            r_QAM <= QAM;
        end if;
    end if;
    
    --Now converting QPSK 
    
    if rising_edge(i_clk) then        --unsure on the clock maybe too slow
        if i_CRCcount = "10" then
            r_QPSK_Value(3)<=i_Sim_Out_QPSK(1);
            r_QPSK_Value(2)<=i_Sim_Out_QPSK(0);
            if i_sim_out_QPSK(0) = '0' then 
                 QPSK(0) <= "0000001";
            else 
                 QPSK(0) <= "1001111";
            end if;
            if i_sim_out_QPSK(1) = '0' then 
                 QPSK(1) <= "0000001";
            else 
                 QPSK(1) <= "1001111";
            end if;
        elsif i_CRCcount = "11" then
            r_QPSK_Value(1)<=i_Sim_Out_QPSK(1);
            r_QPSK_Value(0)<=i_Sim_Out_QPSK(0);
            if i_sim_out_QPSK(0) = '0' then 
                 QPSK(2) <= "0000001";
            else 
                 QPSK(2) <= "1001111";
            end if;
            if i_sim_out_QPSK(1) = '0' then 
                 QPSK(3) <= "0000001";
            else 
                 QPSK(3) <= "1001111";
            end if;
            case r_QPSK_Value is                              -- All Statements below are depended on segment count value
              when "0000" => r_QPSK_out <= "0000001";
              when "0100" => r_QPSK_out <= "1001111";
              when "1000" => r_QPSK_out <= "0010010";
              when "1100" => r_QPSK_out <= "0000110";
              when "0001" => r_QPSK_out <= "1001100";
              when "0101" => r_QPSK_out <= "0100100";
              when "1001" => r_QPSK_out <= "0100000";
              when "1101" => r_QPSK_out <= "0001111";
              when "0010" => r_QPSK_out <= "0000000";
              when "0110" => r_QPSK_out <= "0000100";
              when "1010" => r_QPSK_out <= "0001000";
              when "1110" => r_QPSK_out <= "1100000";
              when "0011" => r_QPSK_out <= "0110001";
              when "0111" => r_QPSK_out <= "1000010";
              when "1011" => r_QPSK_out <= "0110000";
              when "1111" => r_QPSK_out <= "0111000";
            end case;
            r_QPSK <= QPSK;
        end if;
    end if;
    end process convert;

spiltFourDigit : process (i_clk, i_FourDigit, digit,  u)
begin 
    if rising_edge(i_clk) then
        if i_FourDigit(u) = '0' then
            digit(u) <= "0000001";
        else 
            digit(u) <= "1001111";
        end if;
        u <= u + 1;
        
        if u = 4 then
            u <= 0;
        end if;
    end if;
end process spiltFourDigit;


Verdict : process (i_switchMod, i_output1, i_output2, i_output3, i_output4,i_Data_Value,r_QAM_Out, r_QPSK_Out, digit, QAM, QPSK, d, r_QPSK)
begin 
    case i_switchMod is 
            when x"11" => 
                o_display1 <= i_output1; --same as the data generator
                o_display2 <= i_output2;
                o_display3 <= i_output3;
                o_display4 <= i_output4;
            when "001" => 
                o_display1 <= digit(0);
                o_display2 <= digit(1);
                o_display3 <= digit(2);
                o_display4 <= digit(3);
            when "010" => 
                
            --need to switch like the symbol converter
                o_display1 <= r_QAM_Out;
                o_display2 <= "0000001";
                o_display3 <= i_data_value; --Billys idea (If it fails try this)
                o_display4 <= "0000001";
                r_Sym_Received <=i_Sim_Out_QAM;
                
                d <= d + 1;
                if d > 3 then 
                    d <= 0;
                end if;
                
            when "011" => 
                o_display1 <= QAM(0);
                o_display2 <= QAM(1);
                o_display3 <= QAM(2);
                o_display4 <= QAM(3);
                r_Sym_Received <=i_Sim_Out_QAM;
            when "101" => 
                o_display1 <= digit(0);
                o_display2 <= digit(1);
                o_display3 <= digit(2);
                o_display4 <= digit(3);
            when "110" =>
                --need to switch like the symbol converter
                o_display1 <= r_QPSK_Out;
                o_display2 <= "0000001";
                o_display3 <= i_data_value; --Billys idea (If it fails try this)
                o_display4 <= "0000001";
                r_Sym_Received <=i_Sim_Out_QPSK;
                
                d <= d + 1;
                if d > 3 then 
                    d <= 0;
                end if;
            when "111" =>
                o_display1 <= r_QPSK(0);
                o_display2 <= r_QPSK(1);
                o_display3 <= r_QPSK(2);
                o_display4 <= r_QPSK(3);
                r_Sym_Received <=i_Sim_Out_QPSK;
            when others =>
                o_display1 <= i_output1; --same as the data generator
                o_display2 <= i_output2;
                o_display3 <= i_output3;
                o_display4 <= i_output4;   
        end case;
    end process Verdict;
    
process (i_CRCcount) 
begin

case i_CRCcount is
    when "00" => LEDsDG <= i_FourDigit(7)&i_FourDigit(6)& r_Sym_Received(0)& r_Sym_Received(1);
    when "01" => LEDsDG <= i_FourDigit(5)&i_FourDigit(4)& r_Sym_Received(0)& r_Sym_Received(1);
    when "10" => LEDsDG <= i_FourDigit(3)&i_FourDigit(2)& r_Sym_Received(0)& r_Sym_Received(1);
    when "11" => LEDsDG <= i_FourDigit(1)&i_FourDigit(0)& r_Sym_Received(0)& r_Sym_Received(1);
end case;

end process;
    
end Behavioral;
--Four Digit is just 4 bit binary so needs to be converted to 4 7-seg numbers

-- once all the numbers are in 7 segment numbers I can then put into switch statement


