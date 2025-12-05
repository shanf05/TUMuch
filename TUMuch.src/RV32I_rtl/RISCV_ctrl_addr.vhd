-- erstellt von severin hanf
library work; 
use work.defs_pack.all;
library ieee; 
use ieee.numeric_bit.all; 

entity ctrl_addr is
    Port(
        data_in : in  BusDataType; 
        addr_en : in  bit;
        addr    : out bit_vector(AddrSize-1 downto 0)
     );
end ctrl_addr;

architecture rtl of ctrl_addr is
begin
    process(data_in, addr_en)
    begin
        --addr <= to_integer(unsigned(data_in)) when addr_en = '1' else 0;
        if addr_en = '1' then 
            addr <= data_in(AddrSize-1 downto 0); 
        end if; -- otherwise it should hold its value -> does this generate latches?         
    end process;
end rtl;