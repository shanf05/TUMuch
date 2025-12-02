-- erstellt von severin hanf
library work; 
use work.defs_pack.all;

entity ctrl_instr is
    Port(
        data_in  : in  BusDataType; 
        instr_en : in  bit; 
        data_out : out BusDataType
    );
end ctrl_instr;

architecture rtl of ctrl_instr is
begin
    process(data_in, instr_en)
    begin
        data_out <= data_in when instr_en = '1' else (others=>'0');
    end process;
end rtl;