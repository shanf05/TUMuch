library work;
use work.exec_procedures_pack.all; 
use work.defs_pack.all; 
library ieee;
use ieee.numeric_std.all;

package body exec_procedures_pack is   

    procedure JAL_exec  (rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout AddrType)    is                --Severin Hanf
    begin    
        if(imm(20) = '0') then
            pc := pc + unsigned( imm(10 downto 1) & imm(11) & imm(19 downto 12) & '0' );
        else 
            pc := pc + signed();
        end if;
               
        reg(rd) := pc + 4;        --store the return address in rd
    end procedure;              
    
    procedure JALR_exec (rs1, rd : RegAddrType; imm : RegDataType; mem : MemType; regs : RegType; pc : AddrType) is           --Severin Hanf
    begin
    
    end procedure; 
    
end package body exec_procedures_pack;