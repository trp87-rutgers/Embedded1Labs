----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2/20/2020 6:11:25 PM
-- Design Name:
-- Module Name: divider_top - Behavioral
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

entity divider_top is
    port(
            clk  : in std_logic;        -- 125 Mhz clock
            led0 : out std_logic        -- led, '1' = on
        );
end divider_top;

architecture Behavioral of divider_top is

    signal div : std_logic;
    signal invert : std_logic;

    component clock_div is
        port(
            clock : in std_logic;
            clk_div : out std_logic);
    end component;

begin

    process(clk)
    begin
        if (rising_edge(clk) and div = '1') then
            invert <= not invert;
        end if;
    end process;

    led0 <= invert;

    dut : clock_div
    port map (
        clock  => clk,
        clk_div => div
    );


end Behavioral;
