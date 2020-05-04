library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity vga_ctrl is
    Port( 
          clk : in std_logic;
          en : in std_logic;                                    --This is the OUTPUT of the "Clock.Div"
          hcount, vcount : out std_logic_vector(9 downto 0);
          vid, vs, hs :out std_logic) ;
end vga_ctrl;


architecture rtl of vga_ctrl is
    signal hcountSig : unsigned(9 downto 0) := (others => '0'); -- 10 bit counter to count up to 800 pixels. This is a TEMPORARY Signal because it changes
    signal vcountSig : unsigned(9 downto 0) := (others =>'0'); -- 10 bit counter to count up to 525 pixels. This is a TEMPORARY Signal because it changes

 
begin
    
    process(clk, en)  --This is one of the  COUNTER-Processes that Increments the "HORIZONTAL-COUNTER" and "VERTICAL-COUNTER"
    begin
        if rising_edge(clk)  then  
            if en = '1' then           
                if (hcountSig = "1100011111") then                  -- Here the "HORIZONTAL-COUNTER" has counted up to the  Number 799 in Binary
                    hcountSig <= (others => '0');                       --The "HORIZONTAL-COUNTER" will RESET
                    if (vcountSig = "1000001100") then          -- Here the "VERTICAL-COUNTER" has counted up to the  Number 524 in Binary.
                        vcountSig <= (others => '0');                 --The  "VERTICAL-COUNTER" will RESET
                    else                                   -- Here the "VERTICAL-COUNTER" has NOT yet counted up to the  Number 524 in Binary
                        vcountSig <= vcountSig + 1;           --The "VERTICAL-COUNTER" will add "1", when the "VERTICAL-COUNTER" has NOT yet reached 524, and the "HORIZONTAL-COUNTER" has been RESET  to "0",  
                    end if;
                else                                            -- Here the "HORIZONTAL-COUNTER" has NOT yet counted up to the  Number 799 in Binary
                    hcountSig <= hcountSig + 1;                      --The "HORIZONTAL-COUNTER" will add "1"
                end if;
            end if;   
        end if;
    end process;
-------------------------------------------------------------------------------
    process(hcountSig, vcountSig) -- process to control display
    begin
        if hcountSig <= "1001111111" then       -- When the "HORIZONTAL-COUNTER" is in the Number 639 in Binary.  We don't include the "0" condition because it is Not Necesary
            if vcountSig <= "0111011111"  then          --When the "VERTICAL-COUNTER" is in the Number 479 in Binary  
                vid <= '1';                                         --This means the "VIDEO" is ON
            else
                vid <= '0';                        --If the "HORIZONTAL-COUNTER" and the "VERTICAL-COUNTER" are any other Numbers, The "VIDEO" OUTPUT is LOW
            end if;
        end if;    
    end process;
--------------------------------------------------------------------------------                          
    
    process(hcountSig, vcountSig) -- process to control horizontal sync and vertical sync
    begin
        if (hcountSig >= "1010010000" and hcountSig <= "1011101111") then   -- When the the "HORIZONTAL-COUNTER" is Greater-Than, or Equal-To 656 in Binary. and the the "HORIZONTAL-COUNTER" is Less-Than or Equal-To 751 in Binary
            hs <= '0';         --The "Horizontal-Sync-Pulse" is Set to "0"
        else
            hs <= '1';         --If the "HORIZONTAL-COUNTER" is not between the specified Numbers, the "Horizontal-Sync" will be HIGH
        end if;
        ------------------------------------
        if (vcountSig >= "0111101010" and vcountSig <= "0111101011") then       -- When the the "VERTICAL-COUNTER" is Greater-Than, or Equal-To 490 in Binary. and Also Less-Than or Equal-To 491 in Binary
            vs <= '0';                 --the "Vertical-Sync-Pulse" is set to LOW
        else                                    --If the "VERTICAL-COUNTER" is not between any of the Numbers Specified Above
            vs <= '1';                  --the "Vertical-Sync-Pulse" is set to HIGH
        end if;
    end process;
              
    hcount <= std_logic_vector(hcountSig);      --Here the TEMPORARY Signal for the "HORIZONTAL-COUNTER" is connected to the Main OUTPUT of the "HORIZONTAL-COUNTER"
    vcount <= std_logic_vector(vcountSig);      --Here the TEMPORARY Signal for the "VERTICAL-COUNTER" is connected to the Main OUTPUT of the "VERTICAL-COUNTER"
                
end rtl;                        --This ends the ARCHITECTURE     