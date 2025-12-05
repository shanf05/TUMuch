--created by Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;
library work;
use work.inst_layout_pack.all;
use work.defs_pack.all; 

package instr_dec_pack is
    
    --ALU Operation encoding
    subtype ALUOp is bit_vector(2 downto 0); 
    
    constant ALU_XOR : ALUOp := "000";
    constant ALU_OR  : ALUOp := "001";
    constant ALU_AND : ALUOp := "010";
    constant ALU_ADD : ALUOp := "011";
    constant ALU_SUB : ALUOp := "100";
    constant ALU_SLL : ALUOp := "101";
    constant ALU_SRL : ALUOp := "110";
    constant ALU_SRA : ALUOp := "111";
    
end package;