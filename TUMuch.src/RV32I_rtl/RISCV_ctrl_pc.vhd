library work; 
use work.defs_pack.all;

entity ctrl_pc is
    Port(
        pc    : out PcType;
        pc_in : in  PcType; 
        pc_en : in  bit
    );
end ctrl_pc;

architecture rtl of ctrl_pc is

begin


end rtl;