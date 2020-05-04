----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 2/20/2020 06:04:29 AM
-- Design Name:
-- Module Name: counter_top - Behavioral
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

entity counter_top is
    port(
        clk  : in std_logic;        -- 125 Mhz clock

        btn0 : in std_logic;        -- btn, '1' = down
        btn1 : in std_logic;        -- btn, '1' = down
        btn2 : in std_logic;        -- btn, '1' = down
        btn3 : in std_logic;         -- btn, '1' = down

        sw0 : in std_logic;        -- sw, '1' = up
        sw1 : in std_logic;        -- sw, '1' = up
        sw2 : in std_logic;        -- sw, '1' = up
        sw3 : in std_logic;         -- sw, '1' = up

        led0 : out std_logic;        -- led, '1' = on
        led1 : out std_logic;        -- led, '1' = on
        led2 : out std_logic;        -- led, '1' = on
        led3 : out std_logic         -- led, '1' = on
    );
end counter_top;

architecture Behavioral of counter_top is

    component clock_div is
        port(
            clock : in std_logic;
            clk_div : out std_logic);
    end component;

    component fancy_counter is
        port (
            clk, clk_en : in std_logic;
            dir, en, ld, rst : in std_logic;
            updn : in std_logic;
            val : in std_logic_vector (3 downto 0);
            cnt : out std_logic_vector (3 downto 0));
    end component;

    component debounce is
        port(
            clk: in std_logic;
            btn: in std_logic;
            dbnc: out std_logic);
    end component;

    signal div_to_en : std_logic;
    signal dbtn0_to_rst, dbtn1_to_en, dbtn2_to_updn, dbtn3_to_ld : std_logic;
    signal value, count : std_logic_vector( 3 downto 0) := (others => '0');

begin
    --- set the value input of the fancy_counter
    value <= sw3 & sw2 & sw1 & sw0;
    led0 <= count(0);
    led1 <= count(1);
    led2 <= count(2);
    led3 <= count(3);

    G0 : clock_div
    port map (
        clock  => clk,
        clk_div => div_to_en
    );


    G1 : fancy_counter
    port map (
        clk  => clk,
        clk_en => div_to_en,
        dir => sw0,
        en => dbtn1_to_en,
        ld => dbtn3_to_ld,
        rst => dbtn0_to_rst,
        updn => dbtn2_to_updn,
        val => value,
        cnt => count
    );

    G2 : debounce
    port map (
        clk => clk,
        btn => btn0,
        dbnc => dbtn0_to_rst
    );

    G3 : debounce
    port map (
        clk => clk,
        btn => btn1,
        dbnc => dbtn1_to_en
    );

    G4 : debounce
    port map (
       clk => clk,
        btn => btn2,
        dbnc => dbtn2_to_updn
    );

    G5 : debounce
    port map (
        clk => clk,
        btn => btn3,
        dbnc => dbtn3_to_ld
    );

end Behavioral;
