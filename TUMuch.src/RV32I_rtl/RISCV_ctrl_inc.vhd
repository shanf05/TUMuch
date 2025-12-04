-- erstellt von severin hanf
library work; 
use work.defs_pack.all;

library IEEE;
use IEEE.numeric_bit.all;

entity ctrl_inc is
    Port(
        inc_out : out bit_vector(AddrSize-1 downto 0); 
        addr_in : in  bit_vector(AddrSize-1 downto 0) 
    );
end ctrl_inc;

architecture rtl of ctrl_inc is
begin
    process(addr_in)
        variable inc_out_int : integer := 0;
    begin
        inc_out_int := to_integer(unsigned(addr_in)) + 4;
        inc_out <= bit_vector(to_unsigned(inc_out_int, 16));
    end process;
end rtl;