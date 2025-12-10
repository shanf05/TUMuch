--created by Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;
library work;
use work.inst_layout_pack.all;
use work.defs_pack.all; 

package instr_dec_pack is
    
    --ALU Operation encoding
    subtype ALUOp is bit_vector(3 downto 0); 
    
    constant ALU_XOR  : ALUOp := "0000";          --also valid for XORI
    constant ALU_OR   : ALUOp := "0001";          --also valid for ORI
    constant ALU_AND  : ALUOp := "0010";          --also valid for ANDI
    constant ALU_ADD  : ALUOp := "0011";          --also valid for ADDI
    constant ALU_SUB  : ALUOp := "0100";
    constant ALU_SLL  : ALUOp := "0101";          --also valid for SLLI
    constant ALU_SRL  : ALUOp := "0110";          --also valid for SRLI
    constant ALU_SRA  : ALUOp := "0111";          --also valid for SRAI
    constant ALU_SLT  : ALUOp := "1000";          --also valid for SLTI
    constant ALU_SLTU : ALUOp := "1001";          --also valid for SLTIU
    constant ALU_BEQ  : ALUOp := "1010";
    constant ALU_BNE  : ALUOp := "1011";
    constant ALU_BLT  : ALUOp := "1100";
    constant ALU_BGE  : ALUOp := "1101";
    constant ALU_BLTU : ALUOp := "1110";
    constant ALU_BGEU : ALUOp := "1111";          
    
end package;