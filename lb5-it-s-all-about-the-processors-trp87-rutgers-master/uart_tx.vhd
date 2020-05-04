----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2020 03:50:53 PM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
port (
        clk , en , send , rst : in std_logic ;
        char : in std_logic_vector (7 downto 0) ;
        ready , tx : out std_logic
) ;
end uart_tx ;


architecture FSM of uart_tx is

    type state is (idle, start, data);
    signal N : state := idle;
    signal count : std_logic_vector(3 downto 0) := "0000";
    signal shift : std_logic_vector(7 downto 0);
    
begin

    process(clk, rst)
    begin
        if rst = '1' then
            ready <= '1';
            tx <= '1';
        elsif (rising_edge(clk) and en='1') then
            case N is
                when idle => 
                    ready <= '1';
                    tx <= '1';
                    count <= (others => '0');
                    if send = '1' then
                        shift <= char;
                        N <= data;
                        ready <= '0';
                        tx <= '0';
                    end if;
                when data =>
                    if unsigned(count) < 8 then
                        tx <= shift(0);
                        shift <= std_logic_vector(shift_right(signed(shift), 1));
                        count <= std_logic_vector(unsigned(count) + 1);
                        N <= data;
                    else
                        N <= idle;
                        tx <= '1';
                    end if;
                when others =>
                    N <= idle;
            end case;
        end if;
    end process;

end FSM;
