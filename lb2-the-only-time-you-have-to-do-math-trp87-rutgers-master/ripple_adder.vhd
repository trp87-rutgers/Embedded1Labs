----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2020 04:39:38 PM
-- Design Name: 
-- Module Name: ripple_adder - Behavioral
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

entity ripple_adder is
  Port ( A, B : in std_logic_vector( 3 downto 0);
         Cin : in std_logic;
         S : out std_logic_vector( 3 downto 0);
         Cout : out std_logic );
end ripple_adder;

architecture Behavioral of ripple_adder is
    signal carry : std_logic_vector( 2 downto 0);
    
    component adder is
        port(
            A, B, Cin : in std_logic;
            S, Cout : out std_logic);
    end component;
begin
    adder0 : adder
    port map (
        A => A(0),
        B => B(0),
        Cin => Cin,
        S => S(0),
        Cout => carry(0));
        
    adder1 : adder
    port map (
        A => A(1),
        B => B(1),
        Cin => carry(0),
        S => S(1),
        Cout => carry(1));
        
    adder2 : adder
    port map (
        A => A(2),
        B => B(2),
        Cin => carry(1),
        S => S(2),
        Cout => carry(2));
        
    adder3 : adder
    port map (
        A => A(3),
        B => B(3),
        Cin => carry(2),
        S => S(3),
        Cout => Cout);

end Behavioral;
