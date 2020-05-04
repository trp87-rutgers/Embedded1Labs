----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2020 04:16:49 PM
-- Design Name: 
-- Module Name: controls - Behavioral
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

entity controls is
  Port (
        -- Timing Signals
        clk, en, rst : in std_logic;
        
        -- Register File IO
        rID1, rID2       : out std_logic_vector( 4 downto 0 );
        wr_enR1, wr_enR2 : out std_logic;
        regrD1, regrD2   : in  std_logic_vector( 15 downto 0 );
        regwD1, regwD2   : out std_logic_vector( 15 downto 0 );
        
        -- Framebuffer IO
        fbRST, fbld, fb_wr_en   : out std_logic := '0';
        fbAddr1                 : out std_logic_vector( 11 downto 0 );
        fbDin1                  : in  std_logic_vector( 15 downto 0 );
        fbDout1                 : out std_logic_vector( 15 downto 0 );
        
        -- Instruction Memory IO
        irAddr : out std_logic_vector( 13 downto 0 );
        irWord : in std_logic_vector( 31 downto 0 );
        
        -- Data Memory IO
        dAddr   : out std_logic_vector( 14 downto 0 );
        d_wr_en : out std_logic;
        dOut    : out std_logic_vector( 15 downto 0 );
        dIn     : in  std_logic_vector( 15 downto 0 );
        
        -- ALU IO
        aluA, aluB : out std_logic_vector( 15 downto 0 );
        aluOp      : out std_logic_vector( 3 downto 0 );
        aluResult  : in std_logic_vector( 15 downto 0 );
        
        -- UART IO
        ready, newChar : in std_logic;
        sendUART       : out std_logic;
        charRec        : in  std_logic_vector( 7 downto 0 );
        charSend       : out std_logic_vector( 7 downto 0 )
         );
end controls;

architecture Behavioral of controls is

type state is (fetch, fetch2, decode, waitDecode, decodedecode, Rops, Rops2, Iops, Iops2, Jops, calc,
               calc2, store, storeWait, jr, jr2, recv, rpix, rpix2, rpix3, wpix, wpix2, wpix3, send,
               send2, send3, equals, nequal, ori, lw, lw2, sw, sw2, jmp, jmp2, jal, jal2, jal3,
               jal4, clrscr, finish);

signal NS : state := fetch;
-- Intermideate
signal PC : std_logic_vector(15 downto 0) := (others => '0'); -- Program Counter
signal instruction : std_logic_vector(31 downto 0); -- instruction from addr
signal opcode : std_logic_vector(4 downto 0);
signal reg1a, reg2a, reg3a : std_logic_vector(4 downto 0) := (others => '0'); -- registers addr
signal reg1, reg2, reg3 : std_logic_vector(15 downto 0) := (others => '0'); -- register contents
signal imm : std_logic_vector(15 downto 0); -- immediate
signal result : std_logic_vector(15 downto 0); -- ALU/jr Result

begin
    process(clk, rst, en)
    begin
        
        if rst = '1' then
            -- Intermediate Signals
            PC <= (others => '0');
            instruction <= (others => '0');
            opcode <= (others => '0');
            reg1a <= (others => '0');
            reg2a <= (others => '0');
            reg3a <= (others => '0');
            reg1 <= (others => '0');
            reg2 <= (others => '0');
            reg3 <= (others => '0');
            imm <= (others => '0');
            result <= (others => '0');
            
            -- State
            NS <= fetch;
            
            -- Register File
            rID1 <= (others => '0');
            rID2 <= (others => '0');
            wr_enR1 <= '0';
            wr_enR2 <= '0';
            regwD1 <= (others => '0');
            regwD2 <= (others => '0');
            
            -- Frame Buffer
            fbRST <= '1';
            fbld <= '0';
            fb_wr_en <= '0';
            fbAddr1 <= (others => '0');
            fbDout1 <= (others => '0');
            
            -- Instruction Memory
            irAddr <= (others => '0');
            
            -- Data Memory
            dAddr <= (others => '0');
            d_wr_en <= '0';
            dOut <= (others => '0');
            
            -- ALU
            aluA <= (others => '0');
            aluB <= (others => '0');
            aluOp <= (others => '0');
            
            -- UART
            sendUART <= '0';
            charSend <= (others => '0');
            
        elsif rising_edge(clk) AND en = '1' then
            case NS is
                when fetch =>
                    rID1 <= "00001"; -- PC Register
                    NS <= fetch2;
                when fetch2 =>
                    PC <= regrD1;
                    NS <= decode;
                when decode =>
                    irAddr <= PC(13 downto 0);
                    wr_enR1 <= '1'; -- cannot update PC into regwD1 unless enabled
                    rID1 <= "00001"; -- store in register ID 1
                    NS <= waitDecode;
                when waitDecode =>
                    NS <= decodedecode; -- 1 clock cycle latency
                when decodedecode =>
                    -- increment PC
                    regwD1 <= std_logic_vector(unsigned(PC) + 1); -- wr_enR1 enabled in decode
                    wr_enR1 <= '0'; -- reset wr_enR1 back to 0
                    rID1 <= (others => '0'); -- reset rID1
                    -- go to next state
                    if irWord(31 downto 30) = "00" OR irWord(31 downto 30) = "01" then
                        NS <= Rops;
                    elsif irWord(31 downto 30) = "10" then
                        NS <= Iops;
                    else
                        NS <= Jops;
                    end if;
                    instruction <= irWord;
                when Rops =>
                    opcode <= instruction(31 downto 27); -- 5 bits
                    reg1a <= instruction(26 downto 22); -- 5 bit ID
                    reg2a <= instruction(21 downto 17); -- 5 bit ID
                    rID1 <= instruction(21 downto 17); -- same as reg2a for now
                    reg3a <= instruction(16 downto 12); -- 5 bit ID
                    rID2 <= instruction(16 downto 12); -- same as reg3a for now
                    -- Rest of bits are unused for the purpose of this lab
                    NS <= Rops2; -- must wait for regs to be loaded
                when Rops2 =>
                    reg2 <= regrD1;
                    reg3 <= regrD2;
                    rID1 <= (others => '0'); -- reset control signal
                    rID2 <= (others => '0'); -- reset control signal
                    if opcode = "01101" then
                        NS <= jr;
                    elsif opcode = "01100" then
                        NS <= recv;
                    elsif opcode = "01111" then
                        NS <= rpix;
                    elsif opcode = "01110" then
                        NS <= wpix;
                    elsif opcode = "01011" then
                        NS <= send;
                    else
                        NS <= calc;
                    end if;
                when Iops =>
                    opcode <= instruction(31 downto 27); -- 5 bits
                    reg1a <= instruction(26 downto 22);  -- 5 bits
                    rID1 <= instruction(26 downto 22); -- same as reg1a
                    reg2a <= instruction(21 downto 17);  -- 5 bits
                    rID2 <= instruction(21 downto 17);   -- same as reg2a
                    imm <= instruction(16 downto 1);     -- 16 bits
                    NS <= Iops2;
                when Iops2 =>
                    reg1 <= regrD1;
                    reg2 <= regrD2;
                    if opcode(2 downto 0) = "000" then
                        NS <= equals;
                    elsif opcode(2 downto 0) = "001" then
                        NS <= nequal;
                    elsif opcode(2 downto 0) = "010" then
                        NS <= ori;
                    elsif opcode(2 downto 0) = "011" then
                        NS <= lw;
                    else
                        NS <= sw;
                    end if;
                when Jops =>
                    opcode <= instruction(31 downto 27); -- 5 bits
                    imm <= instruction(26 downto 11);    -- 16 bits
                    if instruction(31 downto 27) = "11000" then
                        NS <= jmp;
                    elsif instruction(31 downto 27) = "11001" then
                        NS <= jal;
                    else
                        NS <= clrscr;
                    end if;
                when calc =>
                   aluA <= reg2;
                   aluB <= reg3;
                   aluOp <= opcode(3 downto 0);
                   NS <= calc2; 
                when calc2 =>
                    result <= aluResult;
                    NS <= store;
                when store =>
                    rID1 <= reg1a;
                    wr_enR1 <= '1';
                    NS <= storeWait;
                when storeWait =>
                    regwD1 <= result;
                    NS <= finish;
                when jr =>
                    rID1 <= reg1a;
                    NS <= jr2;
                when jr2 =>
                    result <= regrD1;
                    NS <= store;
                when recv =>
                    result <= "00000000" & CharRec;
                    if newChar = '0' then
                        NS <= recv;
                    else
                        NS <= store;
                    end if;
                when rpix =>
                    fbld <= '1';
                    fbAddr1 <= reg2(11 downto 0); -- lower 12 bits of reg2
                    NS <= rpix2;
                when rpix2 =>
                    NS <= rpix3; -- 1 cycle latency
                when rpix3 =>
                    result <= fbDin1;
                    fbld <= '0';
                    NS <= store;
                when wpix =>
                    fb_wr_en <= '1';
                    fbAddr1 <= reg1(11 downto 0); -- lower 12 bits of reg2
                    NS <= wpix2;
                when wpix2 =>
                    NS <= wpix3; -- 1 cycle latency
                when wpix3 =>
                    fbDout1 <= reg2;
                    NS <= finish;
                when send =>
                    rID1 <= reg1a;
                    NS <= send2;
                when send2 =>
                    reg1 <= regrD1;
                    NS <= send3;
                when send3 =>
                    sendUART <= '1';
                    charSend <= reg1(7 downto 0);
                    if ready = '1' then
                        NS <= finish;
                    else
                        NS <= send3;
                    end if;               
                when equals => -- Iops
                    if reg1 = reg2 then
                        result <= imm;
                        reg1a <= "00001";
                    end if;
                    NS <= store;
                when nequal => -- Iops
                    if reg1 /= reg2 then
                        result <= imm;
                        reg1a <= "00001";
                    end if;
                    NS <= store;
                when ori => -- Iops
                    result <= imm OR reg2;
                    NS <= store;
                when lw => -- Iops
                    dAddr <= std_logic_vector(unsigned(imm(14 downto 0)) + unsigned(reg2(14 downto 0)));
                    NS <= lw2;
                when lw2 =>
                      result <= dIn;
                      NS <= store;
                when sw => -- Iops
                    d_wr_en <= '1';
                    dAddr <= std_logic_vector(unsigned(imm(14 downto 0)) + unsigned(reg2(14 downto 0)));
                    dOut <= reg1;
                    NS <= finish;
                when sw2 =>
                    dOut <= reg1;
                    NS <= finish;
                when jmp => -- Jops
                    rID1 <= "00001";
                    wr_enR1 <= '1';
                    NS <= jmp2;
                when jmp2 =>
                    regwD1 <= imm;
                    NS <= finish;
                when jal => -- Jops
                    rID1 <= "00001"; -- PC
                    rID2 <= "00010"; -- ra
                    regwD1 <= imm; -- enable is off
                    NS <= jal2;
                when jal2 =>
                    reg2 <= regrD1; -- read PC
                    wr_enR2 <= '1';
                    NS <= jal3;
                when jal3 =>
                    regwD2 <= reg2; -- write to ra
                    wr_enR1 <= '1'; -- writes to pc
                    NS <= jal4;
                when jal4 =>
                    NS <= finish;
                when clrscr => -- Jops
                    fbRST <= '1';
                    NS <= finish;
                when finish =>
                    rID1 <= (others => '0');    -- storeWait and send and jmp
                    wr_enR1 <= '0';             -- storeWait -> jmp
                    fbld <= '0';                -- rpix
                    fbAddr1 <= (others => '0'); -- wpix
                    fbDout1 <= (others => '0'); -- wpix2
                    fb_wr_en <= '0';            -- wpix
                    sendUART <= '0';            -- send3
                    dAddr <= (others => '0');   -- lw -> store
                    d_wr_en <= '0';             -- lw
                    dAddr <= (others => '0');   -- lw
                    dOut <= (others => '0');    -- lw2
                    regwD1 <= (others => '0');  -- jmp
                    reg1a <= (others => '0');
                    reg2a <= (others => '0');
                    reg3a <= (others => '0');
                    reg1 <= (others => '0');
                    reg2 <= (others => '0');
                    reg3 <= (others => '0');
                    fbRST <= '0'; -- clrscr
                    NS <= fetch;
                when others =>
                    NS <= finish;
            end case;
        end if;
    end process;

end Behavioral;
