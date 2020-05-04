----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2020 04:58:28 PM
-- Design Name: 
-- Module Name: pixel_pusher - Behavioral
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

entity pixel_pusher is
  Port (
        clk, en, vs, vid : in std_logic;
        pixel : in std_logic_vector( 7 downto 0 );
        hcount : in std_logic_vector( 9 downto 0 );
        R, B : out std_logic_vector( 4 downto 0 );
        G : out std_logic_vector( 5 downto 0 );
        addr : out std_logic_vector( 17 downto 0 )
   );
end pixel_pusher;

architecture Behavioral of pixel_pusher is

    signal counter : std_logic_vector( 17 downto 0 ) := (others => '0');

begin
    addr <= counter;
    process(clk)
    begin
    if rising_edge(clk) AND en = '1' then
        if unsigned(hcount) < 480 AND vid = '1' then
            counter <= std_logic_vector(unsigned(counter) + 1);
        end if;
        
        if vs = '0' then
            counter <= (others => '0');
        end if;
        
        if vid = '1' AND unsigned(hcount) < 480then
            R <= pixel( 7 downto 5 ) & "00";
            G <= pixel( 4 downto 2 ) & "000";
            B <= pixel( 1 downto 0 ) & "000";
        else
            R <= (others => '0');
            G <= (others => '0');
            B <= (others => '0');
        end if;
    end if;
    end process;

end Behavioral;
