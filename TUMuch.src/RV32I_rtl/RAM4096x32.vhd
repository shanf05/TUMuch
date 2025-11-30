-- ERSTELLT VON severin hanf

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;

library work; 
use work.defs_pack.all; 

entity RAM4096x32 is 
port(
    clk     : in  bit; 
    w_en    : in  bit;
    addr    : in  MemAddrType;
    data_in : in  MemDataType;
    data_out: out MemDataType
);
end RAM4096x32;

architecture Behavioral_Integer of RAM4096x32 is
begin
    process(clk)        
        variable Mem : MemType;     --put flipflops right here
    begin        
        if clk'event and clk = '1' then
            if w_en = '1' then 
                Mem(addr) := data_in;
            end if; 
            data_out<=Mem(addr);
        end if;        
    end process;
end Behavioral_Integer;