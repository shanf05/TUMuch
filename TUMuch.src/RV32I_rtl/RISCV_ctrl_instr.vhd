-- erstellt von severin hanf
library work; 
use work.defs_pack.all;

entity ctrl_instr is
    Port(
        data_in  : in  BusDataType;         
        data_out : out BusDataType;
        enable   : in  bit
    );
end ctrl_instr;

architecture rtl of ctrl_instr is
begin
    process(data_in, enable)
    begin
        if enable = '1' then 
            data_out <= data_in;        
        end if; 
    end process;
end rtl;