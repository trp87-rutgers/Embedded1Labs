----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/26/2020 02:51:06 PM
-- Design Name:
-- Module Name: framebuffer - Behavioral
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

entity framebuffer is
  Port (
        clk1, en1, en2, ld : in std_logic;
        rst                : in std_logic := '0';  -- rst was not in provided entity, but assumed
        addr1, addr2       : in  std_logic_vector( 11 downto 0 );
        wr_en1             : in std_logic;
        din1               : in  std_logic_vector( 15 downto 0 ) := (others => '0');
        dout1, dout2       : out std_logic_vector( 15 downto 0 ) := (others => '0')
   );
end framebuffer;

architecture Behavioral of framebuffer is
    type mem is array (4095 downto 0) of std_logic_vector(15 downto 0);
    signal memSignal : mem := (others => (others => '0'));

begin

    process(clk1, rst, en1, en2, wr_en1, ld)
    begin
        if rst = '1' then
            dout1 <= (others => '0');
            dout2 <= (others => '0');
            memSignal <= (others => (others => '0'));

        else
            if rising_edge(clk1) then
                if en1 = '1' then -- CPU
                    if wr_en1 = '1' then
                        memSignal(to_integer(unsigned(addr1))) <= din1;
                    end if;
                    if ld = '1' then
                        dout1 <= memSignal(to_integer(unsigned(addr1)));
                    else
                        dout1 <= (others => '0');
                    end if;
                end if;
                if en2 = '1' then -- VGA
                    dout2 <= memSignal(to_integer(unsigned(addr2)));
                else
                    dout2 <= (others => '0');
                end if;
            end if;
        end if;

    end process;

end Behavioral;
