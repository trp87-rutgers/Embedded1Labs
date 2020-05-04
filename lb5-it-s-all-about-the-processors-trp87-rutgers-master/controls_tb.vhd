----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2020 03:58:08 PM
-- Design Name: 
-- Module Name: controls_tb - Behavioral
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

entity controls_tb is
--  Port ( );
end controls_tb;

architecture Behavioral of controls_tb is

    component controls
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
    end component;
    
    -- external
    signal clk, en : std_logic;
    signal rst     : std_logic := '0';
    -- regs
    signal rID1, rID2       : std_logic_vector( 4 downto 0 );
    signal wr_enR1, wr_enR2 : std_logic;
    signal regrD1, regrD2   : std_logic_vector( 15 downto 0 );
    signal regwD1, regwD2   : std_logic_vector( 15 downto 0 );
    -- framebuffer
    signal fbRST, fbld, fb_wr_en : std_logic;
    signal fbAddr1               : std_logic_vector( 11 downto 0 );
    signal fbDin1, fbDout1       : std_logic_vector( 15 downto 0 );
    -- irMem
    signal irAddr : std_logic_vector( 13 downto 0 );
    signal irWord : std_logic_vector( 31 downto 0 );
    -- dMem
    signal dAddr     : std_logic_vector( 14 downto 0 );
    signal d_wr_en   : std_logic;
    signal dOut, dIn : std_logic_vector( 15 downto 0 );
    -- ALU
    signal aluA, aluB : std_logic_vector( 15 downto 0 );
    signal aluOp      : std_logic_vector( 3 downto 0 );
    signal aluResult  : std_logic_vector( 15 downto 0 );
    -- UART
    signal ready, newChar, SendUART : std_logic;
    signal charRec, charSend        : std_logic_vector( 7 downto 0 );
    
begin
    contr : controls
        port map(
            clk       => clk,     -- external
            en        => en,
            rst       => rst,
            rID1      => rID1,    -- regs
            rID2      => rID2,
            wr_enR1   => wr_enR1,
            wr_enR2   => wr_enR2,
            regrD1    => regrD1,
            regrD2    => regrD2,
            regwD1    => regwD1,
            regwD2    => regwD2,
            fbRST     => fbRST,   -- framebuffer
            fbld      => fbld,
            fb_wr_en  => fb_wr_en,
            fbAddr1   => fbAddr1,
            fbDin1    => fbDin1,
            fbDout1   => fbDout1,
            irAddr    => irAddr,  -- irMem
            irWord    => irWord,
            dAddr     => dAddr,   -- dMem
            d_wr_en   => d_wr_en,
            dOut      => dOut,
            dIn       => dIn,
            aluA      => aluA,    -- ALU
            aluB      => aluB,
            aluOp     => aluOp,
            aluResult => aluResult,
            ready     => ready,   -- UART
            newChar   => newChar,
            sendUART  => sendUART,
            charRec   => charRec,
            charSend  => charSend
    );

    clock : process -- 125 MHz
    begin
        clk <= '0';
        wait for 4 ns;
        clk <= '1';
        wait for 4 ns;
    end process clock;

    enable : process -- 115200 Hz
    begin
        en <= '0';
        wait for 8680 ns;
        en <= '1';
        wait for 8ns;
    end process enable;
    
    instr : process -- give instruction
    begin
        irWord <= X"00C85000"; -- 0b 1100 1000 0101 0000 0000 0000
        wait for 500ns;  --op[ 1100 1 ] imm[ 0000 1010 0000 0000 ]
        -- go to state : jal with imm = 2560 or X"0A00"
    end process instr;
    
end Behavioral;
