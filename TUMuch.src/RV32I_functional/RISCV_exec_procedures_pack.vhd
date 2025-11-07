library work;
use work.defs_pack.all;

package exec_procedures_pack is

    procedure JAL_exec  (rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout AddrType);              --Severin Hanf
    procedure JALR_exec (rs1, rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout AddrType);         --Severin Hanf
    
end package exec_procedures_pack;