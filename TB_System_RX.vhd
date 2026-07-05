----------------------------------------------------------------------------------
-- Company: THISARA SAMARASEKARA
-- Engineer: THISARA SAMARASEKARA
-- 
-- Create Date: 07/04/2026 06:18:38 PM
-- Design Name: 
-- Module Name: TB_System_RX - TB_System_RX_Behav
-- Project Name: PROJECT 2
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

entity TB_System_RX is
--  Port ( );
end TB_System_RX;

architecture TB_System_RX_Behav of TB_System_RX is
    signal clk_in, rst_in                :   STD_LOGIC := '0';
    signal stream_in                     :   STD_LOGIC := '1';
    signal data_display                  :   STD_LOGIC_VECTOR(0 to 7);

begin
    UUT: Entity work.System_RX
    port map(
        CLK_IN => clk_in,
        STREAM_IN => stream_in,  
        RST_IN => rst_in, 
        DATA_DISPLAY => data_display
    );
    
     -- Clock Process
    Clock_Process: process 
    begin
        for count_val in 0 to 150 loop
            clk_in <= '1';
            wait for 5ns;
            clk_in <= '0';
            wait for 5ns;
        end loop;
        std.env.stop;
    end process Clock_Process; 
    
    -- Stimulus Process
    Stimulus: process 
    variable data             :   STD_LOGIC_VECTOR(7 downto 0);             -- indexing 76543210
    variable bit_length       : time := 40ns;
    begin
        stream_in <= '1';
        wait for 200ns;
        
        stream_in <= '1';                -- idle state
        wait for 70ns;
        stream_in <= '0';                -- start bit
        wait for bit_length;
        
        -- data bits
        data := "00001001";             -- data packet
        for i in 0 to 7 loop            -- sending LSB first
            stream_in <= data(i);
            wait for bit_length;
        end loop;
        
        stream_in <= '1';                -- stop bit
        wait for bit_length;
        stream_in <= '1';                -- cleanup/idle bit
        wait for bit_length;
------------------------------------------------------------------------------------        
        stream_in <= '1';                -- idle state
        wait for 10ns;
        stream_in <= '0';                -- start bit
        wait for bit_length;
        
        -- data bits
        data := "00000101";             -- data packet
        for i in 0 to 7 loop            -- sending LSB first
            stream_in <= data(i);
            wait for bit_length;
        end loop;
        
        stream_in <= '1';                -- stop bit
        wait for bit_length;
        stream_in <= '1';                -- cleanup/idle bit
        wait for bit_length;
        wait;
    end process Stimulus;

end TB_System_RX_Behav;
