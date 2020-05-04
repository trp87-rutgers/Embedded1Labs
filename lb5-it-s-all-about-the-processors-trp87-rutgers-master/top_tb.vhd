----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2020 12:15:13 PM
-- Design Name: 
-- Module Name: top_tb - Behavioral
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

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is

    component top_wrapper
        port (
            CTS : out STD_LOGIC;
            RTS : out STD_LOGIC;
            RXD : out STD_LOGIC;
            TXD : in STD_LOGIC;
            btn0 : in STD_LOGIC;
            clk : in STD_LOGIC;
            vga_b : out STD_LOGIC_VECTOR ( 4 downto 0 );
            vga_g : out STD_LOGIC_VECTOR ( 5 downto 0 );
            vga_hs : out STD_LOGIC;
            vga_r : out STD_LOGIC_VECTOR ( 4 downto 0 );
            vga_vs : out STD_LOGIC
    );
    end component;

    signal clk_tb, btn_tb             : std_logic;
    signal CTStb, RTStb, RXDtb, TXDtb : std_logic;
    signal vgaBtb, vgaRtb             : std_logic_vector( 4 downto 0 );
    signal vgaGtb                     : std_logic_vector( 5 downto 0 ); 
    signal vgaHStb, vgaVStb           : std_logic;

begin
    toppy_top : top_wrapper
        port map(
            CTS => CTStb,
            RTS => RTStb,
            RXD => RXDtb,
            TXD => TXDtb,
            btn0 => btn_tb,
            clk => clk_tb,
            vga_b => vgaBtb,
            vga_g => vgaGtb,
            vga_hs => vgaHStb,
            vga_r => vgaRtb,
            vga_vs => vgaVStb
        );

    clock : process -- 125 MHz
    begin
        clk_tb <= '0';
        wait for 4 ns;
        clk_tb <= '1';
        wait for 4 ns;
    end process clock;

end Behavioral;
