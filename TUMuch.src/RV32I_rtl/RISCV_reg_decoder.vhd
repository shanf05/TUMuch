-- created by Josip Pepic

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.defs_pack.all;


entity reg_decoder is
    port ( 
        we      : in bit;
        w_addr  : in RegAddrType;
        en      : out ENType
    );
end reg_decoder;

architecture RTL of reg_decoder is

begin
    process(we,w_addr)
        begin
            en <= (others=>'0');
            if we = '1' then
                en(w_addr) <= '1';
            end if;
    end process;
end RTL;
