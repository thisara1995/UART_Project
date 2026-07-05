----------------------------------------------------------------------------------
-- Company: Thisara Samarasekara
-- Engineer: Thisara Samarasekara  
-- 
-- Create Date: 03/23/2026 08:21:54 PM
-- Design Name: test bench of 7 segment display decoder
-- Module Name: tb_Bit4_to_7Segment - tb_Bit4_to_7Segment_Behav
-- Project Name: Project 1
-- Target Devices: TBD
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_Bit4_to_7Segment is
--  Port ( );
end tb_Bit4_to_7Segment;

architecture tb_Bit4_to_7Segment_Behav of tb_Bit4_to_7Segment is
    signal data_in      : STD_LOGIC_VECTOR (3 downto 0);
    signal rst          : STD_LOGIC;
    signal decode_out   : STD_LOGIC_VECTOR (7 downto 0);
begin
    UUT: Entity work.Bit4_to_7Segment
    port map (
        DATA_IN     => data_in,
        DECODE_OUT  => decode_out,
        RST         => rst
    );
    
    stimulus: process
    begin
        rst     <= '0';
        wait for 250ns;
        rst     <= '1';
        wait for 250ns;
        rst     <= '0';
        wait for 250ns;
        data_in <= "0001";
        wait for 250ns;
        data_in <= "0010";
        wait for 250ns;
        data_in <= "0011";
        wait for 250ns;
        data_in <= "0100";
        wait for 250ns;
        data_in <= "0101";
        wait for 250ns;
        data_in <= "1000";
        wait for 250ns;
        std.env.stop;
    end process stimulus;

end tb_Bit4_to_7Segment_Behav;


