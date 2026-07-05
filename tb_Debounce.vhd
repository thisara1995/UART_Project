----------------------------------------------------------------------------------
-- Company: Thisara Samarasekara
-- Engineer: Thisara Samarasekara
-- 
-- Create Date: 02/20/2026 08:00:30 AM
-- Design Name: Debounce circuit Test Bench
-- Module Name: tb_Debounce - tb_Debounce_Behav
-- Project Name: Project 1
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_Debounce is
--  Port ( );
end tb_Debounce;

architecture tb_Debounce_Behav of tb_Debounce is
    signal clk          :   STD_LOGIC;
    signal in_signal    :   STD_LOGIC;
    signal out_signal   :   STD_LOGIC; 

begin
    UUT: Entity work.Debounce
    generic map (
        COUNT_MAX => 5)
    port map (
        CLK         => clk,
        IN_SIGNAL   => in_signal,
        OUT_SIGNAL  => out_signal  
    );
    
     -- Clock Process
    Clock_Process: process
    begin
        for count_val in 0 to 60 loop
            clk <= '1';
            wait for 10ns;
            clk <= '0';
            wait for 10ns;
        end loop;
        std.env.stop;
    end process Clock_Process; 
    
    --Input signal (from mechanical button) sim process
    In_Sig_Sim_Process: process
    begin
        in_signal <= '0';
        wait for 50ns;
        in_signal <= '1';                   -- first button press start (latch button)
        wait for 5ns;
        
        for count_val in 0 to 60 loop       -- Noise
            in_signal <= '1';
            wait for 3ns;
            in_signal <= '0';
            wait for 3ns;
        end loop;
        
        in_signal <= '1';
        wait for 100ns;                     -- first button press stable
        
        in_signal <= '0';                   -- second button press start (latch button)
        wait for 5ns;
        
        for count_val in 0 to 60 loop       -- Noise
            in_signal <= '1';
            wait for 3ns;
            in_signal <= '0';
            wait for 3ns;
        end loop;
        
        in_signal <= '0';
        wait for 100ns;                     -- first button press stable
        
    
    end process In_Sig_Sim_Process;

end tb_Debounce_Behav;
