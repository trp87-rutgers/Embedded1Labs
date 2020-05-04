----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2/20/2020 6:08:43 AM
-- Design Name:
-- Module Name: fancy_counter - Behavioral
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

entity fancy_counter is
    port (
        clk, clk_en : in std_logic;
        dir, en, ld, rst : in std_logic;
        updn : in std_logic;
        val : in std_logic_vector (3 downto 0);
        cnt : out std_logic_vector (3 downto 0)
    );
end fancy_counter;


architecture Behavioral of fancy_counter is

    signal count : std_logic_vector (3 downto 0) := (others => '0');
    signal value : std_logic_vector (3 downto 0) := "1111";
    signal direction : std_logic := '1';

begin

    cnt <= count;

    process(clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                if clk_en = '1' then
                    if updn = '1' then
                        direction <= dir;
                    end if;
                    if direction = '1' then
                        if count = value then
                            count <= (others => '0');
                        else
                            count <= std_logic_vector(unsigned(count) + 1);
                        end if;
                    else
                        if unsigned(count) = 0 then
                            count <= value;
                        else
                            count <= std_logic_vector(unsigned(count) - 1);
                        end if;
                    end if;
                    if ld = '1' then
                        value <= val;
                    end if;
                end if;
                if rst ='1' then
                    count <= (others => '0');
                end if;
            end if;
        end if;
    end process;


end Behavioral;
