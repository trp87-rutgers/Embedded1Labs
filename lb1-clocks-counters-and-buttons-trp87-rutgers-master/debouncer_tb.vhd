library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity debouncer_tb is

end debouncer_tb;

architecture testbench of debouncer_tb is

    signal tb_clk   :   std_logic := '0';
    signal tb_btn   :   std_logic := '0';
    signal tb_dbnc  :   std_logic := '0';
    
    component debounce is
        port(
            clk :   in std_logic;
            btn :   in std_logic;
            dbnc:   out std_logic
        );
    end component;
    
begin   
    clk_gen_proc: process
    begin
        wait for 4 ns;
        tb_clk <= '1';
        
        wait for 4ns;
        tb_clk <= '0';
    end process;
    
    btn_proc: process
    begin
        wait for 5 ms;
        tb_btn <= '1';
    
        wait for 25 ms;
        tb_btn <= '0';
        
    end process;
    
    dut : debounce
    port map(
        clk => tb_clk,
        btn => tb_btn,
        dbnc => tb_dbnc
    );
    
end testbench;