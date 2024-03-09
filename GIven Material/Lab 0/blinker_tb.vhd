--
-- filename:    blinker_tb.vhd
-- written by:  steve dinicolantonio
-- description: testbench for blinker.vhd
-- notes:       
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

entity blinker_tb is
end blinker_tb;

architecture testbench of blinker_tb is

    signal tb_clk : std_logic := '0';
    signal tb_sw0 : std_logic := '0';
    signal tb_led0 : std_logic;
    
    component blinker is
        port(
        
            clk  : in std_logic;        -- 125 Mhz clock
            sw0  : in std_logic;        -- switch, '1' = on
            
            led0 : out std_logic        -- led, '1' = on
        
        );
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
    
    -- flip the switch high after 1ms
    switch_proc: process
    begin
    
        wait for 1 ms;
        tb_sw0 <= '1';
    
    end process switch_proc;
    
--------------------------------------------------------------------------------
-- port mapping
--------------------------------------------------------------------------------

    dut : blinker
    port map (
    
        clk  => tb_clk,
        sw0  => tb_sw0,
        led0 => tb_led0
    
    );

    
end testbench; 
