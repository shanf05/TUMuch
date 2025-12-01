library work; 
use work.defs_pack.all;

entity ctrl_instr is
    Port(
        data_in  : in BusDataType; 
        instr_en : in bit; 
        data_out : out BusDataType
    );
end ctrl_instr;

architecture rtl of ctrl_instr is

begin


end rtl;