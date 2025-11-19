--ERSTELLT von JOSIP PEPIC
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.defs_pack.all;

package helper_func is
    procedure write_val_to_reg(reg: inout RegType; rd: in RegAddrType; val: in RegDataType);
    procedure IncrementPC(pc : inout PcType);
end package;

package body helper_func is 
    procedure write_val_to_reg(reg: inout RegType; rd: in RegAddrType; val: in RegDataType) is 
    begin
        if rd /= 0 then reg(rd) := val;
        end if;
    end procedure;
    
    procedure IncrementPC(pc : inout PcType) is
    begin
        pc := pc + 4;    
    end procedure;
        
end package body; 

