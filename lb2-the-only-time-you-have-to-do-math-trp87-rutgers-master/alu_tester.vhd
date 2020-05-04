----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2020 08:33:14 PM
-- Design Name: 
-- Module Name: alu_tester - Behavioral
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

entity alu_tester is
  Port ( btn : in std_logic_vector( 3 downto 0);
         clk : in std_logic;
         sw : in std_logic_vector( 3 downto 0);
         led : out std_logic_vector( 3 downto 0));
end alu_tester;

architecture Behavioral of alu_tester is

    signal A_tb, B_tb, op_tb : std_logic_vector( 3 downto 0) := "0000";
    signal dbnc_out : std_logic_vector( 3 downto 0) := "0000";
    signal output : std_logic_vector( 3 downto 0);

    component debounce
    Port ( clk : in std_logic;
           btn : in std_logic;
           dbnc : out std_logic);
    end component;
    
    component my_alu
    Port ( A, B, opcode : in std_logic_vector( 3 downto 0);
           S : out std_logic_vector( 3 downto 0));
    end component;

begin

    process(clk)
    begin
        if( rising_edge(clk) ) then
            led <= output;
            if(dbnc_out(0) = '1') then
                B_tb <= sw;
            elsif( dbnc_out(1) = '1' ) then
                A_tb <= sw; 
            elsif( dbnc_out(2) = '1' ) then
                op_tb <= sw;
            elsif( dbnc_out(3) = '1' ) then
                A_tb <= (others => '0');
                B_tb <= (others => '0');
                op_tb <= (others => '0');
            end if;
        end if;
    end process;

    ALU : my_alu
    port map( A => A_tb,
              B => B_tb,
              opcode => op_tb,
              S => output);
    
    dbnc0 : debounce -- B enable button
    port map( clk => clk,
              btn => btn(0),
              dbnc => dbnc_out(0));
              
    dbnc1 : debounce -- A enable button
    port map( clk => clk,
              btn => btn(1),
              dbnc => dbnc_out(1));
              
    dbnc2 : debounce -- opcode enable button
    port map( clk => clk,
              btn => btn(2),
              dbnc => dbnc_out(2));
              
    dbnc3 : debounce -- clear button
    port map( clk => clk,
              btn => btn(3),
              dbnc => dbnc_out(3));

end Behavioral;
