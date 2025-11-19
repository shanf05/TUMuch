--erstellt von Severin Hanf
library work;
use work.defs_pack.all;


package inst_encoding_pack is
          
    --register-immediate instructions:
    function ADDI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function SLTI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function SLTIU_code (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function ANDI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function ORI_code   (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function XORI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function SLLI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:5] imm[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function SRLI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:5] imm[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function SRAI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:5] imm[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function LUI_code   (rd : RegAddrType; imm : RegDataType) return InstrType; --imm[31:12] rd[4:0] opcode[6:0]
    function AUIPC_code (rd : RegAddrType; imm : RegDataType) return InstrType; --imm[31:12] rd[4:0] opcode[6:0]
    
    --register-register instructions:
    function ADD_code  (rs1, rs2, rd : RegAddrType) return InstrType; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]      
    function SLT_code  (rs1, rs2, rd : RegAddrType) return InstrType; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]    
    function SLTU_code (rs1, rs2, rd : RegAddrType) return InstrType; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function AND_code  (rs1, rs2, rd : RegAddrType) return InstrType; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function OR_code   (rs1, rs2, rd : RegAddrType) return InstrType; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function XOR_code  (rs1, rs2, rd : RegAddrType) return InstrType; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function SLL_code  (rs1, rs2, rd : RegAddrType) return InstrType; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function SRL_code  (rs1, rs2, rd : RegAddrType) return InstrType; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function SUB_code  (rs1, rs2, rd : RegAddrType) return InstrType; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function SRA_code  (rs1, rs2, rd : RegAddrType) return InstrType; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    --nop instruction:
    function NOP_code return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    --stop instruction:
    function STOP_code return InstrType;
    
    --uncondidional jumps:
    function JAL_code  (rd : RegAddrType; imm : RegDataType)      return InstrType; --imm[20] imm[10:1] imm[11] imm[19:12] rs1[4:0] opcode[6:0]
    function JALR_code (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    --conditional branches:
    function BEQ_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]
    function BNE_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]
    function BLT_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]
    function BLTU_code (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]
    function BGE_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]   
    function BGEU_code (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]
        
    --load instructions: 
    function LW_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function LH_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function LHU_code (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function LB_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    function LBU_code (rs1, rd : RegAddrType; imm : RegDataType) return InstrType; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    --store instructions:
    function SW_code (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType; --imm[11:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:0] opcode[6:0]
    function SH_code (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType; --imm[11:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:0] opcode[6:0]
    function SB_code (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType; --imm[11:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:0] opcode[6:0]   
   
end package inst_encoding_pack;

 
