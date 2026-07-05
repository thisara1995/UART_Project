----------------------------------------------------------------------------------
-- Company: Thisara Samarasekara
-- Engineer: Thisara Samarasekara
-- 
-- Create Date: 02/16/2026 05:41:40 PM
-- Design Name: Debouncer Circuit
-- Module Name: Debounce - Debounce_Behav
-- Project Name: Project 1
-- Target Devices: Zybo Z7-10
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

entity Debounce is
    generic (   COUNT_MAX    : INTEGER range 1 to 1000000000 := 1000000000);
    Port (      CLK          : in  STD_LOGIC;
                IN_SIGNAL    : in  STD_LOGIC;
                OUT_SIGNAL   : out STD_LOGIC := '0');    
end Debounce;

architecture Debounce_Behav of Debounce is
    signal in_signal_synch_0, in_signal_synch : STD_LOGIC := '0';
    signal last_out_state                     : STD_LOGIC := '0';

begin
    synch_process : process (CLK)
    begin
        if (rising_edge(CLK)) then
            in_signal_synch_0 <= IN_SIGNAL;
            in_signal_synch   <= in_signal_synch_0;
        end if;
    end process synch_process;
    
    counter_process : process (CLK, in_signal_synch)
    variable count_index : integer range 0 to COUNT_MAX;
    begin
        if (rising_edge(CLK)) then
            if (in_signal_synch /= last_out_state) then
                if (count_index >= COUNT_MAX) then          -- 6 CCs after first if condition, this triggers
                    count_index := 0;
                    last_out_state <= in_signal_synch;
                else
                    count_index := count_index + 1;
                end if;
            else                                            -- this keeps counting, NEED TO FIX
                count_index := 0;
            end if;
            OUT_SIGNAL <= last_out_state;
        end if;
    end process counter_process;
end Debounce_Behav;
