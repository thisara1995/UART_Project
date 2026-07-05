----------------------------------------------------------------------------------
-- Company: Thisara Samarasekara
-- Engineer: Thisara Samarasekara
-- 
-- Create Date: 11/12/2025
-- Design Name: UART Transmitter Test Bench
-- Module Name: tb_TX_UART - tb_TX_UART_Behav
-- Project Name: Project 1
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: TX_UART.vhd
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

entity tb_TX_UART is
--  Port ( );
end tb_TX_UART;

architecture tb_TX_UART_Behav of tb_TX_UART is
    signal clk, stream, tx_rst, tx_en, tx_done  :   STD_LOGIC;
            signal data                         :   STD_LOGIC_VECTOR(0 to 7);

begin
    UUT: Entity work.TX_UART
--    generic map(
--        BAUD_RATE => 8_333_325
--    )
    port map(
        CLK => clk,
        TX_RST => tx_rst,
        TX_EN => tx_en,
        DATA => data,
        TX_DONE => tx_done,
        STREAM => stream
    );
    
    -- Clock Process
    Clock_Process: process 
    begin
        for count_val in 0 to 100 loop
            clk <= '1';
            wait for 30ns;
            clk <= '0';
            wait for 30ns;
        end loop;
        std.env.stop;
    end process Clock_Process; 
    
    -- Stimulus Process
    Stimulus: process 
    begin
        data <= "10101001";
        tx_rst <= '0';
        wait for 50ns;
        tx_en <= '1';
        wait for 2500ns;
        data <= "11010101";
        wait for 100ns;
        tx_rst <= '1';
        wait for 60ns;
        tx_rst <= '0';
        wait;
    end process Stimulus;
    
    

    
end tb_TX_UART_Behav;


