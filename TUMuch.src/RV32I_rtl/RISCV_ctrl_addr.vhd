library work; 
use work.defs_pack.all;

entity ctrl_addr is
    Port(
        data_in : in  BusDataType; 
        addr_en : in  bit;
        addr    : out MemAddrType  
     );
end ctrl_addr;

architecture rtl of ctrl_addr is

begin


end rtl;