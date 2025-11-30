--created by Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.all;


--FlipFlop with synchronous reset and enable
entity D_FFRE is
    Port (D : in bit;
          RST : in bit;
          EN : in bit;
          CLK : in bit;
          Q: out bit);
end D_FFRE;

architecture RTL of D_FFRE is
begin
    process
    begin
        wait until clk = '1';
        if RST = '1' then
            Q <= '0';
        else
            if EN = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end RTL;

