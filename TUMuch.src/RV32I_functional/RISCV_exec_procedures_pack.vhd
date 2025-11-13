library work;
use work.defs_pack.all;

package exec_procedures_pack is
-- ERSTELLT VON JEONGJOO LIM; Teil Orange; LB LBU LH LHU LW SB SH SW ADD SUB ADDI
    procedure LB_exec   (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);
    procedure LBU_exec  (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);
    procedure LH_exec   (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);
    procedure LHU_exec  (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);
    procedure LW_exec   (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);
    procedure SB_exec   (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);
    procedure SH_exec   (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);
    procedure SW_exec   (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);
    procedure ADD_exec  (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);
    procedure SUB_exec  (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);
    procedure ADDI_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType);

    procedure JAL_exec  (rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType);              --Severin Hanf
    procedure JALR_exec (rs1, rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType);         --Severin Hanf
    procedure BEQ_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType);        --Severin Hanf
    procedure BNE_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType);        --Severin Hanf
    procedure BLT_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType);        --Severin Hanf
    procedure BGE_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType);        --Severin Hanf
    procedure BLTU_exec (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType);        --Severin Hanf
    procedure BGEU_exec (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType);        --Severin Hanf

    --erstellt von Max Biricz; Teil Lila; LUI AUIPC XORI ORI ANDI SLLI SRLI SRAI SLTI SLTIU
    procedure LUI_exec   (rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType);
    procedure AUIPC_exec (rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType);
    procedure XORI_exec  (rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType);
    procedure ORI_exec   (rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType);
    procedure ANDI_exec  (rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType);
    procedure SLLI_exec  (rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType);
    procedure SRLI_exec  (rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType);
    procedure SRAI_exec  (rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType);
    procedure SLTI_exec  (rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType);
    procedure SLTIU_exec (rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType);

    -- ERSTELLT VON JOSIP PEPIC; Teil Pink; XOR OR AND SLL SRL SRA SLT EXEC
    procedure XOR_exec  (rd, rs1, rs2   : RegAddrType; reg : inout RegType; pc : inout PCType);
    procedure OR_exec   (rd, rs1, rs2   : RegAddrType; reg : inout RegType; pc : inout PCType);
    procedure AND_exec  (rd, rs1, rs2   : RegAddrType; reg : inout RegType; pc : inout PCType);
    procedure SLL_exec  (rd, rs1, rs2   : RegAddrType; reg : inout RegType; pc : inout PCType);
    procedure SRL_exec  (rd, rs1, rs2   : RegAddrType; reg : inout RegType; pc : inout PCType);
    procedure SRA_exec  (rd, rs1, rs2   : RegAddrType; reg : inout RegType; pc : inout PCType);
    procedure SLT_exec  (rd, rs1, rs2   : RegAddrType; reg : inout RegType; pc : inout PCType);
    procedure SLTU_exec (rd, rs1, rs2   : RegAddrType; reg : inout RegType; pc : inout PCType);
    

end package exec_procedures_pack;
    
