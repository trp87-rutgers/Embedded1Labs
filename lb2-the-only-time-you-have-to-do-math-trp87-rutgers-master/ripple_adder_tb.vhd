----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2020 05:39:30 PM
-- Design Name: 
-- Module Name: ripple_adder_tb - Behavioral
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

entity ripple_adder_tb is
--  Port ( );
end ripple_adder_tb;

architecture Behavioral of ripple_adder_tb is

    signal tb_clk : std_logic := '0';
    signal S_out : std_logic_vector (3 downto 0);
    signal C_out : std_logic;
    signal A_in, B_in : std_logic_vector (3 downto 0) := "0101";
    signal C_in : std_logic := '1';
    
    component ripple_adder is
        port(  
            A, B : in std_logic_vector (3 downto 0);
            Cin : in std_logic;
            S : out std_logic_vector (3 downto 0);
            Cout : out std_logic);
    end component;
    
begin

--------------------------------------------------------------------------------
-- procs
--------------------------------------------------------------------------------

    clk_gen_proc: process
    begin
        
        -- Initially S and Cout should be:
        -- 0101 + 0101 + 0001 =  S =>1011   Cout => 0
        wait for 4 ns;
        
        tb_clk <= '1';
        A_in <= "0111";
        B_in <= "0001";
        C_in <= '0';
        
        -- S and Cout Should now be:
        -- 0111 + 0001 + 0000 =  S => 1000  Cout => 0
        wait for 4 ns;
        
        tb_clk <= '0';
        A_in <= "1111";
        B_in <= "0001";
        C_in <= '0';
        
        -- S and Cout Should now be:
        -- 1111 + 0001 + 0000 =  S => 0000  Cout => 1
        wait for 4 ns;
        
        tb_clk <= '1';
        A_in <= "1111";
        B_in <= "1111";
        C_in <= '1';
        
        -- S and Cout Should now be:
        -- 1111 + 1111 + 0001 =  S => 1111  Cout => 1
        wait for 4 ns;
        
    end process clk_gen_proc;

--------------------------------------------------------------------------------
-- port mapping
--------------------------------------------------------------------------------
    ripple :ripple_adder
    port map (
        A  => A_in,
        B => B_in,
        Cin => C_in,
        S => S_out,
        Cout => C_out);
    

end Behavioral;
