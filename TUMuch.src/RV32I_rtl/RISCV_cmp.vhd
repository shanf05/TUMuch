-- created by Josip Pepic
library IEEE;
use IEEE.numeric_bit.all;
library work;
use work.defs_pack.all;


-- < and = comparison should be sufficient

entity cmp is
    port (
        a           : in BusDataType;
        b           : in BusDataType;
        is_signed   : in bit;
        lt_out      : out BusDataType;  -- result for: a < b ?
        equal_out   : out bit           -- result for: a = b ?      -- result is only one bit since it is not written to a register 
         );
end cmp;

architecture RTL of cmp is    
begin
    process(a, b, is_signed)
    begin
        equal_out   <= '0';
        lt_out      <= (others=>'0');
        
        if a = b then 
            equal_out   <= '1';
        end if;
        
        if is_signed = '1' and (signed(a) < signed(b)) then 
            lt_out(0)   <= '1';
        elsif is_signed = '0' and (unsigned(a) < unsigned(b)) then
            lt_out(0)   <= '1'; 
        end if;
    end process;
end RTL;
