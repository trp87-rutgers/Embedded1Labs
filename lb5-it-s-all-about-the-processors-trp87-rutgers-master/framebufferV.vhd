library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity framebuffer is port (
    clk1, en1, en2, rst, ld: in std_logic;
    addr1, addr2 : in std_logic_vector(11 downto 0);
    wr_en1: in std_logic;
    din1: in std_logic_vector(15 downto 0);
    dout1, dout2 : out std_logic_vector(15 downto 0));

end framebuffer;
architecture rtl of framebuffer is
    type reg is array (4095 downto 0) of std_logic_vector(15 downto 0);
    shared variable rgstr: reg;
    signal dout1Sig, dout2Sig : std_logic_vector(15 downto 0) :=(others => '0');

    begin

    dout1 <= dout1Sig;
    dout2 <= dout2Sig;

--CPU port Write/Read
    process(clk1)
    begin
        if(rising_edge(clk1)) then
            if (rst='1') then
                rgstr := (others=>(others=>'0'));
            end if;
            if (en1='1') then
                if (wr_en1 = '1') then
                    rgstr(to_integer( unsigned(addr1))) := din1;
                end if;
                dout1Sig <= rgstr(to_integer( unsigned(addr1)));
            end if;
        end if;
    end process;

 --VGA Port Read only
    process(clk1)
    begin
        if(rising_edge(clk1) and en2='1') then
            dout2Sig <= rgstr(to_integer( unsigned(addr2)));
        end if;
    end process;

 end rtl;
