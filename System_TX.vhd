----------------------------------------------------------------------------------
-- Company: THISARA SAMARASEKRA
-- Engineer: THISARA SAMARASEKARA
-- 
-- Create Date: 06/28/2026 12:16:58 PM
-- Design Name: UART DESIGN
-- Module Name: System_TX - System_TX_Behav
-- Project Name: UART SYSTEM
-- Target Devices: Zybo Z7
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

entity System_TX is
    Port ( CLK_IN : in STD_LOGIC;
           SEND_DATA : in STD_LOGIC;
           LD_DATA : in STD_LOGIC;
           RST_DATA : in STD_LOGIC;
           DATA_IN : in STD_LOGIC_VECTOR (3 downto 0);
           OUT_STREAM : out STD_LOGIC := '1';
           OUT_DISPLAY : out STD_LOGIC_VECTOR (0 to 7));
end System_TX;

architecture System_TX_Behav of System_TX is

-- variables
    constant clk_freq_var      : integer := 125_000_000;
    constant debounce_Freq_var : integer := 4; --31_250_000

-- SIGNAL DEFINITION
    signal tx_rst           : STD_LOGIC := '0';
    signal tx_en            : STD_LOGIC := '0';
    signal data             : STD_LOGIC_VECTOR (0 to 7);                            -- Least significant bit leads
    signal tx_done          : STD_LOGIC := '0';
    signal ld_data_debounce : STD_LOGIC := '0';
    signal sd_data_debounce : STD_LOGIC := '0';
    signal rst_data_debounce: STD_LOGIC := '0';
    signal data_in_reg      : STD_LOGIC_VECTOR (3 downto 0);

begin

    TX_UART : entity work.TX_UART
        generic map (
            CLK_FREQ   => clk_freq_var,
            BAUD_RATE  => 9600                -- 31_250_000
        )
        port map (
            CLK => CLK_IN,
            TX_RST => tx_rst,
            TX_EN => tx_en,
            DATA => data,
            TX_DONE => tx_done,
            STREAM => OUT_STREAM
        );
        
    DATA_DISPLAY : entity work.Bit4_to_7Segment
        port map (
            DATA_IN => data_in_reg,
            DECODE_OUT => OUT_DISPLAY,
            RST => rst_data_debounce
        );

    DEBOUNCE_LD_DATA : entity work.Debounce
        generic map (
            COUNT_MAX   => (clk_freq_var/debounce_Freq_var)
        )
        port map (
            CLK => CLK_IN,
            IN_SIGNAL => LD_DATA,
            OUT_SIGNAL => ld_data_debounce
        );
        
    DEBOUNCE_RST_DATA : entity work.Debounce
        generic map (
            COUNT_MAX   => (clk_freq_var/debounce_Freq_var)
        )
        port map (
            CLK => CLK_IN,
            IN_SIGNAL => RST_DATA,
            OUT_SIGNAL => rst_data_debounce
        );        

    DEBOUNCE_SEND : entity work.Debounce
        generic map (
            COUNT_MAX   => (clk_freq_var/debounce_Freq_var)
        )
        port map (
            CLK => CLK_IN,
            IN_SIGNAL => SEND_DATA,
            OUT_SIGNAL => sd_data_debounce
        );
        
    -- Press and hold buttons
    process(CLK_IN)
    begin
        if rising_edge(CLK_IN) then
            if sd_data_debounce = '1' then
                tx_en <= sd_data_debounce;
                data <= "0000" & DATA_IN;
            end if;
            if ld_data_debounce = '1' then
                data_in_reg <= DATA_IN;
            end if;
        end if;
    end process; 
    
    
    

end System_TX_Behav;
