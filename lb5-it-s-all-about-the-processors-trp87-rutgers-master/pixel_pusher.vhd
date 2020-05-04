library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pixel_pusher is
  Port ( 
        clk , en, vs , vid : in std_logic;
        hcount             : in std_logic_vector (9 downto 0);
        pixel              : in std_logic_vector (15 downto 0);
        R, B               : out std_logic_vector(4 downto 0):= (others => '0');
        G                  : out std_logic_vector (5 downto 0):= (others => '0');
        addr               : out std_logic_vector (11 downto 0) := (others => '0')
  );
end pixel_pusher;

architecture Behavioral of pixel_pusher is

    signal address : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');

begin

    addr <= address;

    process(clk, en, vs, vid)
    begin

        if rising_edge(clk) then
    
            if en = '1' AND vid = '1' AND (to_integer(unsigned(hcount)) < 480) then
                address <= std_logic_vector(unsigned(address) + 1);
                R <= pixel(15 downto 11);
                G <= pixel(10 downto 5);
                B <= pixel(4 downto 0);
            else 
                R <= (others => '0');
                G <= (others => '0');
                B <= (others => '0');           
            end if;
        
            if vs = '0' then
                address <= (others => '0');
            end if;
        
        end if;
    
    end process;
end Behavioral;
