----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2020 07:53:43 PM
-- Design Name: 
-- Module Name: my_alu - Behavioral
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

entity my_alu is
  Port ( A, B : in std_logic_vector( 15 downto 0);
         opcode : in std_logic_vector( 3 downto 0);
         clk, en : in std_logic;
         S : out std_logic_vector( 15 downto 0) := (others => '0') );
end my_alu;

architecture Behavioral of my_alu is

begin

    process(clk, en)
    begin
        if rising_edge(clk) AND en = '1' then
            case (opcode) is
                when "0000" => S <= std_logic_vector((unsigned(A) + unsigned(B))); -- A + B
                when "0001" => S <= std_logic_vector((unsigned(A) - unsigned(B))); -- A - B
                when "0010" => S <= std_logic_vector(unsigned(A) + "0001");        -- A + 1
                when "0011" => S <= std_logic_vector(unsigned(A) - "0001");        -- A - 1
                when "0100" => S <= std_logic_vector(0 - unsigned(A));        -- 0 - A
                when "0101" => S <= std_logic_vector(shift_left(unsigned(A),1));   -- shift left logical
                when "0110" => S <= std_logic_vector(shift_right(unsigned(A),1));  -- shift right logical
                when "0111" => S <= std_logic_vector(shift_right(signed(A), 1));   -- shift right arithmatic
                when "1000" => S <= A AND B;
                when "1001" => S <= A OR B;
                when "1010" => S <= A XOR B;
                when "1011" => 
                               S <= (others => '0');
                               if signed(A) < signed(B) then                                       -- A < B
                                   S(0) <= '1';
                               else
                                   S(0) <= '0';
                               end if;
                when "1100" => 
                               S <= (others => '0');
                               if signed(A) > signed(B) then                                       -- A > B
                                   S(0) <= '1';
                               else
                                   S(0) <= '0';
                               end if;
                when "1101" =>
                               S <= (others => '0');
                               if unsigned(A) = unsigned(B) then                                   -- A = B
                                   S(0) <= '1';
                               else
                                   S(0) <= '0';
                               end if;
                when "1110" => 
                               S <= (others => '0');
                               if unsigned(A) < unsigned(B) then                                   -- A < B
                                   S(0) <= '1';
                               else
                                   S(0) <= '0';
                               end if;
                when "1111" => 
                               S <= (others => '0');
                               if unsigned(A) > unsigned(B) then                                   -- A > B
                                   S(0) <= '1';
                               else
                                   S(0) <= '0';
                               end if;
                when others => S <= (others => '0');
            end case;
        end if;
    end process;

end Behavioral;
