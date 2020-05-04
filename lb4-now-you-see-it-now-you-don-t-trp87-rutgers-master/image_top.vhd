----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2020 05:53:06 PM
-- Design Name: 
-- Module Name: image_top - Behavioral
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

entity image_top is
  Port (
        clk : in std_logic;
        vga_hs, vga_vs : out std_logic;
        vga_r, vga_b : out std_logic_vector( 4 downto 0 );
        vga_g : out std_logic_vector( 5 downto 0 )
   );
end image_top;

architecture Behavioral of image_top is
    
    component clock_div
        port (
            clk : in std_logic;
            clk_div : out std_logic);
    end component;
    
    component vga_ctrl
        Port (
            clk, en : in std_logic;
            hcount, vcount : out std_logic_vector( 9 downto 0 );
            vid, hs, vs : out std_logic);
    end component;
    
    component pixel_pusher
        Port (
            clk, en, vs, vid : in std_logic;
            pixel : in std_logic_vector( 7 downto 0 );
            hcount : in std_logic_vector( 9 downto 0 );
            R, B : out std_logic_vector( 4 downto 0 );
            G : out std_logic_vector( 5 downto 0 );
            addr : out std_logic_vector( 17 downto 0 ));
    end component;
    
    component picture
        Port (
            clka : in std_logic;
            addra : in std_logic_vector( 17 downto 0 );
            douta : out std_logic_vector( 7 downto 0 )
        );
    end component;
    
    signal clk_en, vid, hs, vs : std_logic;
    signal hcount, vcount : std_logic_vector( 9 downto 0 );
    signal addr : std_logic_vector( 17 downto 0 );
    signal pixel : std_logic_vector( 7 downto 0 );
    
begin

    clk_div : clock_div
        port map (
            clk => clk,
            clk_div => clk_en
        );
        
    vga_control : vga_ctrl
        port map(
            clk => clk,
            en => clk_en,
            hcount => hcount,
            vcount => vcount,
            vid => vid,
            hs => hs,
            vs => vs
        );
        
    pix_push : pixel_pusher
        port map(
            clk => clk,
            en => clk_en,
            vs => vs,
            vid => vid,
            pixel => pixel,
            hcount => hcount
        );
        
        pic : picture
            port map (
                clka => clk,
                addra => addr,
                douta => pixel 
            );
end Behavioral;
