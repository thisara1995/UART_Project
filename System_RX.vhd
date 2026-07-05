----------------------------------------------------------------------------------
-- Company: THISARA SAMARASEKARA
-- Engineer: THISARA SAMARASEKARA
-- 
-- Create Date: 07/04/2026 06:46:43 AM
-- Design Name: UART System
-- Module Name: System_RX - System_RX_Behav
-- Project Name: Project 2
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

entity System_RX is
    Port ( STREAM_IN    : in STD_LOGIC;
           CLK_IN       : IN STD_LOGIC;
           RST_IN       : in STD_LOGIC;
           DATA_DISPLAY : out STD_LOGIC_VECTOR (0 to 7);
           SEG_INDEX    : out STD_LOGIC_VECTOR (7 downto 0) := "11111111");
end System_RX;

architecture System_RX_Behav of System_RX is

-- variables
    constant clk_freq_var      : integer := 100_000_000;
    constant debounce_Freq_var : integer := 25_000_000; --31_250_000
    
    -- SIGNAL DEFINITION
    signal data             : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');                            -- Least significant bit leads
    signal data_loaded      : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal rx_done          : STD_LOGIC := '0';
    signal ld_data_debounce : STD_LOGIC := '0';
    signal seg_ind          : STD_LOGIC_VECTOR (7 downto 0) := "11111110";
    signal rst_data_debounce: STD_LOGIC := '0';

begin
    SEG_INDEX <= seg_ind;
    
    DEBOUNCE_RST_DATA : entity work.Debounce
        generic map (
            COUNT_MAX   => (clk_freq_var/debounce_Freq_var)
        )
        port map (
            CLK => CLK_IN,
            IN_SIGNAL => RST_IN,
            OUT_SIGNAL => rst_data_debounce
        );

    TX_UART : entity work.rx_UART_Upgrade
        generic map (
            CLK_FREQ   => clk_freq_var,
            BAUD_RATE  => 9600                -- 31_250_000
        )
        port map (
            CLK => CLK_IN,
            I_STREAM => STREAM_IN,
            RST_DEBU => rst_data_debounce,
            O_DATA => data,
            Done_BIT => rx_done
        );
    
    -- Load received data to the display
    -- Press and hold buttons
    LD_RECEIVED_DATA : process(CLK_IN)
    begin
        if rising_edge(CLK_IN) then
            if rx_done = '1' then
                data_loaded <= data(3 downto 0);
            end if;
        end if;
    end process LD_RECEIVED_DATA;
    
    SEG_DATA_DISPLAY : entity work.Bit4_to_7Segment
        port map (
            DATA_IN => data_loaded,
            DECODE_OUT => DATA_DISPLAY,
            RST => rst_data_debounce
        );
    
end System_RX_Behav;
