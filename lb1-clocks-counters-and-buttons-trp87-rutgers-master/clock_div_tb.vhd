----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2/20/2020 06:13:32 PM
-- Design Name:
-- Module Name: clock_div_tb - Behavioral
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

entity clock_div_tb is
--  Port ( );
end clock_div_tb;

architecture Behavioral of clock_div_tb is

    signal tb_clk : std_logic := '0';
    signal output : std_logic;

    component clock_div is
        port(
            clock : in std_logic;
            clk_div : out std_logic);
    end component;

begin

--------------------------------------------------------------------------------
-- procs
--------------------------------------------------------------------------------

    -- simulate a 125 Mhz clock
    clk_gen_proc: process
    begin

        wait for 4 ns;
        tb_clk <= '1';

        wait for 4 ns;
        tb_clk <= '0';

    end process clk_gen_proc;

--------------------------------------------------------------------------------
-- port mapping
--------------------------------------------------------------------------------
    dut : clock_div
    port map (
        clock  => tb_clk,
        clk_div => output
    );

end Behavioral;
