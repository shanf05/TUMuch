library work;
use work.defs_pack.all;

package exec_procedures_pack is

-- ERSTELLT VON JEONGJOO LIM; Teil Orange; LB LBU LH LHU LW SB SH SW ADD SUB ADDI
    procedure LB_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType);
    procedure LBU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType);
    procedure LH_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType);
    procedure LHU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType);
    procedure LW_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType);
    procedure SB_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType);
    procedure SH_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType);
    procedure SW_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType);
    procedure ADD_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType);
    procedure SUB_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType);
    procedure ADDI_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType);
    
end package exec_procedures_pack;