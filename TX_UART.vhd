----------------------------------------------------------------------------------
-- Company: Thisara Samarasekara
-- Engineer: Thisara Samarasekara 
-- 
-- Create Date: 11/04/2025 05:34:25 PM
-- Design Name: UART Transmitter  
-- Module Name: TX_UART - TX_UART_BEHAV
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

entity TX_UART is
    generic (
    CLK_FREQ    : integer := 125_000_000;
    BAUD_RATE   : integer := 31_250_000 --9600
    );
    Port (  CLK     : in STD_LOGIC;
            TX_RST  : in STD_LOGIC := '0';
            TX_EN   : in STD_LOGIC := '0';
            DATA    : in STD_LOGIC_VECTOR (0 to 7);                            -- Least significant bit leads
            TX_DONE : out STD_LOGIC := '0';
            STREAM  : out STD_LOGIC := '1');
end TX_UART;

architecture TX_UART_BEHAV of TX_UART is
    type state_type is (Idle, Start, Byte, Stop, Cleanup);
    signal current_state : state_type := Idle;
    signal clk_index  : integer := 0;                                          -- valid to use variable inside the process, but not using in the same clock cycle, so this works too
    signal data_index : integer range 0 to DATA'length-1 := DATA'length-1;     -- LSB leads (8-bit data)
    constant clk_cycles : integer := (CLK_FREQ + BAUD_RATE/2) / BAUD_RATE;     -- clk = 20 ns, bit length = 80 ns (FPGA clock: 33.33MHz / 30ns)

begin
    State_Process: process(CLK)
    begin
        if (rising_edge(CLK)) then
            case current_state is
                when Idle =>
                --Idle state logic 
                    if (TX_EN = '1' and TX_RST = '0') then
                        current_state <= Start;
                    else
                        current_state <= Idle;
                    end if;
                    
                when Start =>
                --Start state logic 
                    if (TX_RST = '1') then
                        current_state <= Cleanup;
                    elsif (clk_index < (clk_cycles - 1)) then
                        clk_index <= clk_index + 1;
                        current_state <= Start;
                    else
                        current_state <= Byte;
                        clk_index <= 0;
                    end if;
                
                when Byte =>
                --Byte state logic
                    if (TX_RST = '1') then
                        current_state <= Cleanup;
                    elsif (clk_index < (clk_cycles - 1)) then
                        clk_index <= clk_index + 1;
                        current_state <= Byte;
                    elsif (data_index > 0) then
                        data_index <= data_index - 1;
                        clk_index <= 0;
                        current_state <= Byte;
                    else
                        current_state <= Stop;
                        clk_index <= 0;
                    end if;
                
                when Stop =>
                --Stop state logic
                    if(TX_RST = '1') then
                        current_state <= Cleanup;
                    elsif (clk_index < (clk_cycles - 1)) then
                        clk_index <= clk_index + 1;
                        current_state <= Stop;
                    else
                        current_state <= Cleanup;
                        clk_index <= 0;
                    end if;
                when Cleanup =>
                --Cleanup state logic
                    data_index <= DATA'length-1;
                    if (clk_index < (clk_cycles - 1)) then
                        clk_index <= clk_index + 1;
                        current_state <= Cleanup;
                    else
                        current_state <= Idle;
                        clk_index <= 0;
                    end if;
            end case;
        end if;
    
    end process State_Process; 
    
    DataTransmission_Process: process(CLK)
    begin
        if (rising_edge(CLK)) then
            case current_state is
                when Idle =>
                --Idle state logic
                    STREAM <= '1';
                    TX_DONE <= '0'; 
                    
                when Start =>
                --Start state logic
                    STREAM <= '0';
                    TX_DONE <= '0';
                
                when Byte =>
                --Byte state logic
                    STREAM <= DATA(data_index);
                    TX_DONE <= '0';
                
                when Stop =>
                --Stop state logic
                    STREAM <= '1';
                    TX_DONE <= '1';
                when Cleanup =>
                --Cleanupop state logic
                    STREAM <= '1';
                    TX_DONE <= '0';
            end case;
        end if;
    end process DataTransmission_Process;


end TX_UART_BEHAV;




