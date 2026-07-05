----------------------------------------------------------------------------------
-- Company: Thisara Samarasekara
-- Engineer: Thisara Samarasekara 
-- 
-- Create Date: 02/01/2026 02:06:14 PM
-- Design Name: UART Receiver
-- Module Name: RX_UART_Upgrade - Behavioral
-- Project Name: Project 1
-- Target Devices: TBD
-- Tool Versions: 
-- Description: Double register, combinational and sequential circuits seperated version.
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

entity RX_UART_Upgrade is
    generic (
        CLK_FREQ    : integer := 25_000_000;
        BAUD_RATE   : integer := 6250000 --9600
    );
    Port ( I_STREAM : in    STD_LOGIC;
           CLK      : in    STD_LOGIC;
           RST_DEBU : in    STD_LOGIC := '0';
           O_DATA   : out   STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
           Done_BIT : out   STD_LOGIC := '0');
end RX_UART_Upgrade;

architecture Behavioral of RX_UART_Upgrade is
    type state_type is (Idle, Start, Data, Stop, Cleanup);          -- This section is here because it descripes HW
    signal next_state                  : state_type;
    signal curr_state                  : state_type := Idle;
    signal i_stream_in, i_stream_synch : STD_LOGIC := '1';          -- start on idle
    signal shft_reg                    : STD_LOGIC_VECTOR(7 downto 0);
    constant clk_cycles                : integer := (CLK_FREQ + BAUD_RATE/2) / BAUD_RATE;
    signal clk_index                   : integer range 0 to (clk_cycles - 1) := 0;
    signal data_index                  : integer range 0 to 7 := 0;
--    attribute DONT_TOUCH : string;
--    attribute DONT_TOUCH of clk_index  : signal is "TRUE";
    
begin
    
    synch_process : process(CLK)                                    --synchronizing process
    begin
        if (rising_edge(CLK)) then
            i_stream_in     <= I_STREAM;
            i_stream_synch  <= i_stream_in;
        end if;
    end process synch_process;
    
    counters_process : process(CLK)                                 -- sequential process of counters
    begin
        if (rising_edge(CLK)) then
            
            if rst_debu = '1' then
                curr_state <= Cleanup;                              -- Fix: replace next_state with curr_state
            else
                curr_state <= next_state;                           -- Next state registered process
            end if;
            
            case curr_state is
            when Idle =>
                clk_index  <= 0;                                    -- Fix: Have to take 1 cycle headstart to account for loss bit
                data_index <= 0;
                    
            when Start =>
                if (clk_index >= (clk_cycles - 2)) then         -- Fix: stop 1 clock cycle early
                    clk_index <= 0;                             -- last clock edge is also the first 
                    data_index <= 0;
                else
                    clk_index  <= clk_index + 1;
                end if;
            when Data =>
                if (clk_index >= (clk_cycles - 1) and data_index < 7) then                    
                    data_index  <= data_index + 1;
                    clk_index <= 0;                         -- last clock edge is also the first 
                elsif (clk_index = (clk_cycles - 1)/2) then                  -- mid point of the data bit
                    shft_reg(data_index) <= i_stream_synch;
                    clk_index  <= clk_index + 1;
                elsif(clk_index >= (clk_cycles - 1) and data_index = 7) then
                    clk_index <= 0;
                    data_index <= 0;
                else
                        clk_index  <= clk_index + 1;
                end if;
            when Stop =>
                if (clk_index >= (clk_cycles - 1)) then                        -- This is after 2ed clk edge and before 3rd one 
                    clk_index <= 0;
                    O_DATA <= shft_reg; 
                    Done_BIT <= '1'; 
                else
                    clk_index  <= clk_index + 1;
                end if;
            when Cleanup =>
                if (clk_index >= (clk_cycles - 1)) then                        -- This is after 2ed clk edge and before 3rd one 
                    clk_index <= 0;   
                else
                    clk_index  <= clk_index + 1;
                    Done_BIT <= '0';
                    shft_reg <= (others => '0');
                end if;
            end case;
        end if;
    end process counters_process;
        
    combinational_process : process (i_stream_synch, curr_state, clk_index, data_index)
    begin
        next_state <= curr_state;                       -- default 
        
        case curr_state is
            when Idle =>
                if (i_stream_synch = '0') then                        -- could be the start bit 
                    next_state <= Start;
                else
                    next_state <= Idle;
                end if;
            when Start =>
                if (i_stream_synch /= '0' and clk_index = (clk_cycles - 1)/2) then     -- noise/glitch and not the start bit
                    next_state <= Idle;                 
                elsif (clk_index >= (clk_cycles - 2)) then                      -- Fix: reached next state one clk cycle early
                    next_state <= Data;
                else
                    next_state <= Start;                        -- stay in current state
                end if;    
            when Data =>
                if (data_index >= 7 and (clk_index = (clk_cycles - 1))) then
                    next_state <= Stop;
                else
                    next_state <= Data;
                end if;
            when Stop =>
                if (clk_index >= (clk_cycles - 1)) then
                    next_state <= Cleanup;
                else
                    next_state <= Stop;
                end if;
            when Cleanup =>
                if (clk_index >= (clk_cycles - 1)) then
                    next_state <= Idle;
                else
                    next_state <= Cleanup;
                end if;
        end case;
        
    end process combinational_process;

end Behavioral;





