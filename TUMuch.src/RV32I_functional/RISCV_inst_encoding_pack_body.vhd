--erstellt von Severin Hanf
library work; 
--use work.inst_encoding_pack.all;
use work.defs_pack.all;
use work.inst_layout_pack.all;
use work.inst_encoding_pack.all;
library ieee;
use ieee.numeric_bit.all;

package body inst_encoding_pack is
    --register-immediate instructions:
    function ADDI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_ADD & bit_vector(to_unsigned(rd,5)) & OP_IMM;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function SLTI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_SLT & bit_vector(to_unsigned(rd,5)) & OP_IMM;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function SLTIU_code (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_SLTU & bit_vector(to_unsigned(rd,5)) & OP_IMM;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function ANDI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_AND & bit_vector(to_unsigned(rd,5)) & OP_IMM;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function ORI_code   (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_OR(2 downto 0) & bit_vector(to_unsigned(rd,5)) & OP_IMM;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function XORI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_XOR & bit_vector(to_unsigned(rd,5)) & OP_IMM;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    
    function SLLI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_SLL & bit_vector(to_unsigned(rd,5)) & OP_IMM;
    end function; --imm[11:5] imm[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function SRLI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_SRL & bit_vector(to_unsigned(rd,5)) & OP_IMM;
    end function; --imm[11:5] imm[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function SRAI_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_SRA & bit_vector(to_unsigned(rd,5)) & OP_IMM;
    end function; --imm[11:5] imm[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function LUI_code   (rd : RegAddrType; imm : RegDataType)      return InstrType is
    begin
    return imm(19 downto 0) & bit_vector(to_unsigned(rd,5)) & OP_LUI;
    end function; --imm[31:12] rd[4:0] opcode[6:0]
    
    function AUIPC_code (rd : RegAddrType; imm : RegDataType)      return InstrType is
    begin
    return imm(19 downto 0) & bit_vector(to_unsigned(rd,5)) & OP_AUIPC;
    end function; --imm[31:12] rd[4:0] opcode[6:0]
    
    --register-register instructions:
    function ADD_code  (rs1, rs2, rd : RegAddrType) return InstrType is
    begin
    return F7_ADD & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_ADD & bit_vector(to_unsigned(rd,5)) & OP_OP;
    end function; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]      
    
    function SLT_code  (rs1, rs2, rd : RegAddrType) return InstrType is
    begin
    return F7_SLT & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_SLT & bit_vector(to_unsigned(rd,5)) & OP_OP;
    end function; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]   
     
    function SLTU_code (rs1, rs2, rd : RegAddrType) return InstrType is
    begin
    return F7_SLT & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_SLTU & bit_vector(to_unsigned(rd,5)) & OP_OP;
    end function; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function AND_code  (rs1, rs2, rd : RegAddrType) return InstrType is
    begin
    return F7_AND & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_AND & bit_vector(to_unsigned(rd,5)) & OP_OP;
    end function; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function OR_code   (rs1, rs2, rd : RegAddrType) return InstrType is
    begin
    return F7_OR & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_OR & bit_vector(to_unsigned(rd,5)) & OP_OP;
    end function; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function XOR_code  (rs1, rs2, rd : RegAddrType) return InstrType is
    begin
    return F7_XOR & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_XOR & bit_vector(to_unsigned(rd,5)) & OP_OP;
    end function; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function SLL_code  (rs1, rs2, rd : RegAddrType) return InstrType is
    begin
    return F7_SLL & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_SLL & bit_vector(to_unsigned(rd,5)) & OP_OP;
    end function; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function SRL_code  (rs1, rs2, rd : RegAddrType) return InstrType is
    begin
    return F7_SRL & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_SRL & bit_vector(to_unsigned(rd,5)) & OP_OP;
    end function; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function SUB_code  (rs1, rs2, rd : RegAddrType) return InstrType is
    begin
    return F7_SUB & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_SUB & bit_vector(to_unsigned(rd,5)) & OP_OP;
    end function; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function SRA_code  (rs1, rs2, rd : RegAddrType) return InstrType is
    begin
    return F7_SRA & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_SRA & bit_vector(to_unsigned(rd,5)) & OP_OP;
    end function; --funct7[6:0] rs2[4:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    
    --nop instruction:
    function NOP_code return InstrType is
    variable tmp1 : bit_vector(16 downto 0) := (others=>'0');
    variable tmp2 : bit_vector(4 downto 0)  := (others=>'0'); 
    begin    
    return tmp1(16 downto 0) & F3_ADD & tmp2(4 downto 0) & OP_IMM;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    --stop instruction:
    function STOP_code return InstrType is
    variable tmp1 : bit_vector(16 downto 0) := "01010101010101010";
    variable tmp2 : bit_vector(4 downto 0) := "01010";
    begin
    return tmp1(16 downto 0) & F3_LHU & tmp2 (4 downto 0) & OP_STOP;
    end function;
    
    --uncondidional jumps:
    function JAL_code  (rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(20) & imm(10 downto 1) & imm(11) & imm(19 downto 12) & bit_vector(to_unsigned(rd,5)) & OP_JAL;
    end function; --imm[20] imm[10:1] imm[11] imm[19:12] rd[4:0] opcode[6:0]
    
    function JALR_code (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_JALR & bit_vector(to_unsigned(rd,5)) & OP_JALR;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    --conditional branches:
    function BEQ_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(12) & imm(10 downto 5) & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_BEQ & imm(4 downto 1) & imm(11) & OP_BRANCH;
    end function; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]
    
    function BNE_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(12) & imm(10 downto 5) & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_BNE & imm(4 downto 1) & imm(11) & OP_BRANCH;
    end function; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]
    
    function BLT_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(12) & imm(10 downto 5) & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_BLT & imm(4 downto 1) & imm(11) & OP_BRANCH;
    end function; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]
    
    function BLTU_code (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(12) & imm(10 downto 5) & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_BLTU & imm(4 downto 1) & imm(11) & OP_BRANCH;
    end function; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]
    
    function BGE_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(12) & imm(10 downto 5) & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_BGE & imm(4 downto 1) & imm(11) & OP_BRANCH;
    end function; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]   
    
    function BGEU_code (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(12) & imm(10 downto 5) & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_BGEU & imm(4 downto 1) & imm(11) & OP_BRANCH;
    end function; --imm[12] imm[10:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:1] imm[11] opcode[6:0]
    
    --load and store instructions:
    function LW_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_LW & bit_vector(to_unsigned(rd,5)) & OP_LOAD;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function LH_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_LH & bit_vector(to_unsigned(rd,5)) & OP_LOAD;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function LHU_code (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_LHU & bit_vector(to_unsigned(rd,5)) & OP_LOAD;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function LB_code  (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_LB & bit_vector(to_unsigned(rd,5)) & OP_LOAD;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function LBU_code (rs1, rd : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 0) & bit_vector(to_unsigned(rs1,5)) & F3_LBU & bit_vector(to_unsigned(rd,5)) & OP_LOAD;
    end function; --imm[11:0] rs1[4:0] funct3[2:0] rd[4:0] opcode[6:0]
    
    function SW_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 5) & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_SW & imm(4 downto 0) & OP_LOAD;
    end function; --imm[11:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:0] opcode[6:0]
    
    function SH_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 5) & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_SH & imm(4 downto 0) & OP_LOAD;
    end function; --imm[11:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:0] opcode[6:0]
    
    function SB_code  (rs1, rs2 : RegAddrType; imm : RegDataType) return InstrType is
    begin
    return imm(11 downto 5) & bit_vector(to_unsigned(rs2,5)) & bit_vector(to_unsigned(rs1,5)) & F3_SB & imm(4 downto 0) & OP_LOAD;
    end function; --imm[11:5] rs2[4:0] rs1[4:0] funct3[2:0] imm[4:0] opcode[6:0]   
    
end package body inst_encoding_pack;
