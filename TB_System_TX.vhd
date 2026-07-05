----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/28/2026 04:39:21 PM
-- Design Name: 
-- Module Name: TB_System_TX - tb_System_TX_Behav
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

entity TB_System_TX is
--  Port ( );
end TB_System_TX;

architecture tb_System_TX_Behav of TB_System_TX is

    signal clk_in, send_data, ld_data, rst_data, out_stream           :   STD_LOGIC;
    signal data_in                                                    :   STD_LOGIC_VECTOR(3 downto 0);
    signal out_display                                                :   STD_LOGIC_VECTOR(0 to 7);

begin
    UUT: Entity work.System_TX
    port map(
        CLK_IN => clk_in,
        SEND_DATA => send_data,  
        LD_DATA => ld_data, 
        RST_DATA => rst_data, 
        DATA_IN => data_in, 
        OUT_STREAM => out_stream, 
        OUT_DISPLAY => out_display
    );
    
    -- Clock Process
    Clock_Process: process 
    begin
        for count_val in 0 to 60 loop
            clk_in <= '1';
            wait for 30ns;
            clk_in <= '0';
            wait for 30ns;
        end loop;
        std.env.stop;
    end process Clock_Process; 
    
    -- Stimulus Process
    Stimulus: process 
    begin
        data_in <= "0000";
        ld_data <= '0';
        send_data <= '0';
        rst_data <= '0';
        
        wait for 200ns;
        ld_data <= '1';
        wait for 200ns;
        data_in <= "0001";
        wait for 100ns;
        ld_data <= '0';
        send_data <= '1';
        wait for 200ns;
--        wait for 60ns;
--        tx_rst <= '0';
        wait;
    end process Stimulus;
    
    

end tb_System_TX_Behav;
