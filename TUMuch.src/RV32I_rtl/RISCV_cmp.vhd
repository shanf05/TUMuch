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
    signal res_sub : BusDataType;
    signal a_sig, b_sig : BusDataType := (others=>'0');
    
begin
    sub32  : entity work.addsub    port map(o_mode=>'1', a=>a_sig, b=>b_sig, d_out=>res_sub); -- res_sub = a - b
    

    process(a, b, is_signed)
    begin
        equal_out   <= '0';
        lt_out      <= (others=>'0');
        
        if a = b then 
            equal_out   <= '1';
        end if;
        
        if is_signed = '1' then 
            a_sig <= bit_vector(signed(a)); 
            b_sig <= bit_vector(signed(b)); 
            
        else
            a_sig <= bit_vector(unsigned(a)); 
            b_sig <= bit_vector(unsigned(b));            
        end if;
        
        if res_sub(31) = '1' then 
            lt_out(0) <= '1';       -- a is smaller than b, because a - b is negative        
        end if;
        
    end process;
end RTL;
