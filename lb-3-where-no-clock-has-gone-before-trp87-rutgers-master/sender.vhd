----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2020 04:28:26 PM
-- Design Name: 
-- Module Name: sender - Behavioral
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

entity sender is
  Port ( 
         button, ready, rst, clk, en : in std_logic;
         send : out std_logic;
         char : out std_logic_vector( 7 downto 0 ));
end sender;

architecture Behavioral of sender is

    type str is array(0 to 4) of std_logic_vector(7 downto 0); -- 5 digits for my netID
    signal NETID : str := (x"74", x"72", x"70", x"38", x"37"); -- "trp87" in ASCII
    signal i : std_logic_vector(2 downto 0) := (others=>'0'); -- need 3 digits to count to 5
    constant n : std_logic_vector(2 downto 0) := "101"; -- initiliazed to 5

    type state is (idle, busyA, busyB, busyC);
    signal curr : state := idle;
    
begin

    process(clk, rst)
    begin
        if rst = '1' then
            send <= '0';
            i <= (others => '0');
            char <= (others => '0');
            curr <= idle;
        elsif rising_edge(clk) and en = '1' then
            case curr is
                when idle =>
                    if ready = '1' AND button = '1' AND unsigned(i) < unsigned(n) then
                        send <= '1';
                        char <= NETID(to_integer(unsigned(i)));
                        i <= std_logic_vector(unsigned(i) + 1);
                        curr <= busyA;
                    elsif ready = '1' AND button = '1' AND i=n then
                        i <= (others => '0');
                        curr <= idle;                        
                    end if;
                when busyA =>
                    curr <= busyB;
                when busyB =>
                    send <= '0';
                    curr <= busyC;
                when busyC =>
                    if ready = '1' AND button = '0' then
                        curr <= idle;
                    else
                        curr <= busyC;  -- reduncancy built in
                    end if;
                when others =>
                    curr <= idle;
                    char <= (others => '0');
                    i <= (others => '0');
                    send <= '0';            
            end case;
        end if;
        
    end process;

end Behavioral;
