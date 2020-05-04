----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2/20/2020 06:04:18 PM
-- Design Name:
-- Module Name: debounce - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
    port(
        clk: in STD_LOGIC;
        btn: in STD_LOGIC;
        dbnc: out STD_LOGIC := '0');
end debounce;

architecture Behavioral of debounce is

    signal previous : std_logic := '0';  -- previous value
    signal count : std_logic_vector(21 downto 0)  := (others => '0');
    signal dbnc_out : std_logic := '0';

    begin
    
    dbnc <= dbnc_out;

    process (clk) begin
        if rising_edge(clk) then
            if btn='1' then
                if unsigned(count) < 2500000 then
                    count <= std_logic_vector(unsigned(count) + 1);
                else
                    dbnc_out <= '1';
                end if;
            else
                previous <= btn;
                count <= (others => '0');
                dbnc_out <= '0';
            end if;
        end if;
    end process;
    
 end Behavioral;