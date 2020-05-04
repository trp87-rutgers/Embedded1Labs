----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2020 06:16:05 PM
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is

    signal tb_clk : std_logic := '0';
    signal tb_btn : std_logic_vector(1 downto 0) := (others => '0');
    signal tb_txd, tb_cts, tb_rts : std_logic := '0';
    signal output : std_logic;
    
    component top_uart is
        Port (
            btn : in std_logic_vector(1 downto 0) := (others => '0');
            clk, TXD : in std_logic;
            RXD, CTS, RTS : out std_logic);
    end component;

begin
    clk_gen_proc : process
    begin
        wait for 4 ns;
        tb_clk <= '1';
        wait for 4 ns;
        tb_clk <= '0';
    end process clk_gen_proc;

    btn_proc : process
    begin
        wait for 5 us;
        tb_btn(1) <= '1';
        wait for 25 us;
        tb_btn(1) <= '0';
    end process btn_proc;
    
    btn_reset_proc : process
    begin
        wait for 250 us;
        tb_btn(0) <= '1';
        wait for 30 us;
        tb_btn(0) <= '0';
    end process btn_reset_proc;

    dut : top_uart
        port map (
            btn => tb_btn,
            clk => tb_clk,
            TXD => tb_txd,
            RXD => output,
            CTS => tb_cts,
            RTS => tb_rts
        );
end Behavioral;
