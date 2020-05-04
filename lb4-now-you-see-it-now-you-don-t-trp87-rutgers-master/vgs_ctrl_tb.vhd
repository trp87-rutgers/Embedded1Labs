----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2020 02:27:39 PM
-- Design Name: 
-- Module Name: vgs_ctrl_tb - Behavioral
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

entity vgs_ctrl_tb is
--  Port ( );
end vgs_ctrl_tb;

architecture Behavioral of vgs_ctrl_tb is

    signal tb_clk : std_logic := '0';
    signal tb_en : std_logic := '1';
    signal tb_hcount, tb_vcount : std_logic_vector( 9 downto 0 );
    signal tb_vid, tb_hs, tb_vs : std_logic;
    
    component vga_ctrl is
        Port (
            clk, en : in std_logic;
            hcount, vcount : out std_logic_vector( 9 downto 0 );
            vid, hs, vs : out std_logic
        );
    end component;
    
begin

    clk_gen_proc : process -- 125 MHz clock
    begin
        wait for 4 ns;
        tb_clk <= '1';
        
        wait for 4 ns;
        tb_clk <= '0';
        
    end process clk_gen_proc;

    U1 : vga_ctrl
    port map(
        clk => tb_clk,
        en => tb_en,
        hcount => tb_hcount,
        vcount => tb_vcount,
        vid => tb_vid,
        hs => tb_hs,
        vs => tb_vs
    );
end Behavioral;
