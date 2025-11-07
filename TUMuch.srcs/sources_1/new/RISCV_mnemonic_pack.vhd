--erstellt von Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package mnemonic_pack is

subtype mnemonic_type is string(1 to 5); 

    --register-immediate instructions
    constant ADDI_mnemonic : mnemonic_type := "ADDI ";
    constant SLTI_mnemonic : mnemonic_type := "SLTI ";
    constant SLTIU_mnemonic : mnemonic_type := "SLTIU";
    constant ANDI_mnemonic : mnemonic_type := "ANDI ";
    constant ORI_mnemonic : mnemonic_type := "ORI  ";
    constant XORI_mnemonic : mnemonic_type := "XORI ";
    
    constant SLLI_mnemonic : mnemonic_type := "SLLI ";
    constant SRLI_mnemonic : mnemonic_type := "SRLI ";
    constant SRAI_mnemonic : mnemonic_type := "SRAI ";
    
    constant LUI_mnemonic : mnemonic_type := "LUI  ";
    constant AUIPC_mnemonic : mnemonic_type := "AUIPC";
    
    --register-register instructions:
    constant ADD_mnemonic : mnemonic_type := "ADD  ";
    constant SLT_mnemonic : mnemonic_type := "SLT  ";
    constant SLTU_mnemonic : mnemonic_type := "SLTU ";
    constant AND_mnemonic : mnemonic_type := "AND  ";
    constant OR_mnemonic : mnemonic_type := "OR   ";
    constant XOR_mnemonic : mnemonic_type := "XOR  ";
    constant SLL_mnemonic : mnemonic_type := "SLL  ";
    constant SRL_mnemonic : mnemonic_type := "SRL  ";
    constant SUB_mnemonic : mnemonic_type := "SUB  ";
    constant SRA_mnemonic : mnemonic_type := "SRA  ";
    
    --nop instruction:
    constant NOP_mnemonic : mnemonic_type := "NOP  ";
    
    --unconditional jumps:
    constant JAL_mnemonic : mnemonic_type := "JAL  ";
    constant JALR_mnemonic : mnemonic_type := "JALR ";
    
    --conditional branches:
    constant BEQ_mnemonic : mnemonic_type := "BEQ  ";
    constant BNE_mnemonic : mnemonic_type := "BNE  ";
    constant BLT_mnemonic : mnemonic_type := "BLT  ";
    constant BLTU_mnemonic : mnemonic_type := "BLTU ";
    constant BGE_mnemonic : mnemonic_type := "BGE  ";
    constant BGEU_mnemonic : mnemonic_type := "BGEU ";
    
    --load instructions:
    constant LW_mnemonic : mnemonic_type := "LW   ";
    constant LH_mnemonic : mnemonic_type := "LH   ";
    constant LHU_mnemonic : mnemonic_type := "LHU  ";
    constant LB_mnemonic : mnemonic_type := "LB   ";
    constant LBU_mnemonic : mnemonic_type := "LBU  ";
    
    --store instructions:
    constant SW_mnemonic : mnemonic_type := "SW   ";
    constant SH_mnemonic : mnemonic_type := "SH   ";
    constant SB_mnemonic : mnemonic_type := "SB   ";
    
end package mnemonic_pack;
