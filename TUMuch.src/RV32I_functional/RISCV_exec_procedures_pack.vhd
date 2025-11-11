library work;
use work.defs_pack.all;

package exec_procedures_pack is

    procedure JAL_exec  (rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType);              --Severin Hanf
    procedure JALR_exec (rs1, rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType);         --Severin Hanf
    procedure BEQ_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType);        --Severin Hanf
    procedure BNE_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType);        --Severin Hanf
    procedure BLT_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType);        --Severin Hanf
    procedure BGE_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType);        --Severin Hanf
    procedure BLTU_exec (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType);        --Severin Hanf
    procedure BGEU_exec (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType);        --Severin Hanf
end package exec_procedures_pack;