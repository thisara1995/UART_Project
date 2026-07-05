----------------------------------------------------------------------------------
-- Company: Thisara Samarasekara
-- Engineer: Thisara Samarasekara 
-- 
-- Create Date: 03/22/2026 06:46:05 AM
-- Design Name: 7 segment display decoder
-- Module Name: 4BIT_2_7Segment - 3BIT_2_7Segment_Behav
-- Project Name: Project 1
-- Target Devices: TBD
-- Tool Versions: 
-- Description: Take in 4 bit binary and decode it to 7 segment display with dp (0-9)
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Bit4_to_7Segment is
    Port ( DATA_IN      : in STD_LOGIC_VECTOR (3 downto 0) := "0000";
           DECODE_OUT   : out STD_LOGIC_VECTOR (0 to 7) := "11111111";
           RST          : in STD_LOGIC);
end Bit4_to_7Segment;

architecture Bit4_to_7Segment_Behav of Bit4_to_7Segment is

begin
    decode_process : process (DATA_IN, RST)
    begin
        if (RST = '1') then
            DECODE_OUT <= "11111111";
        else
            if (DATA_IN = "0000") then
            DECODE_OUT <= not "11111100";
        elsif (DATA_IN = "0001")then
            DECODE_OUT <= not "01100000";
        elsif (DATA_IN = "0010")then
            DECODE_OUT <= not "11011010";
        elsif (DATA_IN = "0011")then
            DECODE_OUT <= not "11110010";
        elsif (DATA_IN = "0100")then
            DECODE_OUT <= not "01100110";
        elsif (DATA_IN = "0101")then
            DECODE_OUT <= not "10110110";
        elsif (DATA_IN = "0110")then
            DECODE_OUT <= not "10111110";
        elsif (DATA_IN = "0111")then
            DECODE_OUT <= not "11100000";
        elsif (DATA_IN = "1000")then
            DECODE_OUT <= not "11111110";
        elsif (DATA_IN = "1001")then
            DECODE_OUT <= not "11110110";
        else
            DECODE_OUT <= "11111111";
        end if;
        end if;
    end process decode_process;

end Bit4_to_7Segment_Behav;
