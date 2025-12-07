-- created by Josip Pepic

library IEEE;
use IEEE.numeric_bit.ALL;
library work;
use work.defs_pack.all;


entity reg_decoder is
    port ( 
        we      : in bit;
        w_addr  : in bit_vector(4 downto 0);
        en      : out ENType
    );
end reg_decoder;

architecture RTL of reg_decoder is

begin
    process(we,w_addr)
        variable w_addr_int : integer range 0 to 31;
    begin
        w_addr_int := to_integer(unsigned(w_addr));
        en <= (others=>'0');
        if we = '1' then
            en(w_addr_int) <= '1';
        end if;
    end process;
end RTL;
