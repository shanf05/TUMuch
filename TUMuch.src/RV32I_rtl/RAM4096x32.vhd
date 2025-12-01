-- ERSTELLT VON severin hanf

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;

library work; 
use work.defs_pack.all; 

entity RAM4096x32 is 
    generic(  -- look if this is necessary
        tc : time := 0 ns; --delay to react on input change
        th : time := 0 ns --time to hold signals stable
    );  
    port(
        clk      : in bit; 
        w_en     : in bit;
        addr     : in MemAddrType; 
        data_in  : in  MemDataType;
        data_out : out MemDataType        
    );
end RAM4096x32;

architecture behavioral of RAM4096x32 is
    signal Mem : MemType;     --put flipflops right here
begin
    synchronus_write : process
    begin        
        wait until clk = '1'; 
        if w_en = '1' then 
            Mem(addr) <= data_in after tc;      -- is the delay even necessary? 
        end if;                    
    end process;
    
    asynchronus_read : process(Mem, addr)
    begin
        data_out <= Mem(addr) after th;         -- is the delay even necessary? 
    end process;
    
end behavioral;