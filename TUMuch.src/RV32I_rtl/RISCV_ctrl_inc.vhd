-- erstellt von severin hanf
library work; 
use work.defs_pack.all;

entity ctrl_inc is
    Port(
        inc_out : out MemAddrType; 
        addr_in : in  MemAddrType 
    );
end ctrl_inc;

architecture rtl of ctrl_inc is
begin
    process(addr_in)
    begin
        inc_out <= addr_in + 4;
    end process;
end rtl;