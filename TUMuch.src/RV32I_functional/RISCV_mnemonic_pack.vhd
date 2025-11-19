--erstellt von Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package mnemonic_pack is

subtype MnemonicType is string(1 to 5); 

    --register-immediate instructions
    constant ADDI_mnemonic  : MnemonicType := "ADDI ";
    constant SLTI_mnemonic  : MnemonicType := "SLTI ";
    constant SLTIU_mnemonic : MnemonicType := "SLTIU";
    constant ANDI_mnemonic  : MnemonicType := "ANDI ";
    constant ORI_mnemonic   : MnemonicType := "ORI  ";
    constant XORI_mnemonic  : MnemonicType := "XORI ";
    
    constant SLLI_mnemonic  : MnemonicType := "SLLI ";
    constant SRLI_mnemonic  : MnemonicType := "SRLI ";
    constant SRAI_mnemonic  : MnemonicType := "SRAI ";
    
    constant LUI_mnemonic   : MnemonicType := "LUI  ";
    constant AUIPC_mnemonic : MnemonicType := "AUIPC";
    
    --register-register instructions:
    constant ADD_mnemonic   : MnemonicType := "ADD  ";
    constant SLT_mnemonic   : MnemonicType := "SLT  ";
    constant SLTU_mnemonic  : MnemonicType := "SLTU ";
    constant AND_mnemonic   : MnemonicType := "AND  ";
    constant OR_mnemonic    : MnemonicType := "OR   ";
    constant XOR_mnemonic   : MnemonicType := "XOR  ";
    constant SLL_mnemonic   : MnemonicType := "SLL  ";
    constant SRL_mnemonic   : MnemonicType := "SRL  ";
    constant SUB_mnemonic   : MnemonicType := "SUB  ";
    constant SRA_mnemonic   : MnemonicType := "SRA  ";
    
    --nop instruction:
    constant NOP_mnemonic   : MnemonicType := "NOP  ";
    
    --stop instruction:
    constant STOP_mnemonic  : MnemonicType := "STOP ";
    
    --unconditional jumps:
    constant JAL_mnemonic   : MnemonicType := "JAL  ";
    constant JALR_mnemonic  : MnemonicType := "JALR ";
    
    --conditional branches:
    constant BEQ_mnemonic   : MnemonicType := "BEQ  ";
    constant BNE_mnemonic   : MnemonicType := "BNE  ";
    constant BLT_mnemonic   : MnemonicType := "BLT  ";
    constant BLTU_mnemonic  : MnemonicType := "BLTU ";
    constant BGE_mnemonic   : MnemonicType := "BGE  ";
    constant BGEU_mnemonic  : MnemonicType := "BGEU ";
    
    --load instructions:
    constant LW_mnemonic    : MnemonicType := "LW   ";
    constant LH_mnemonic    : MnemonicType := "LH   ";
    constant LHU_mnemonic   : MnemonicType := "LHU  ";
    constant LB_mnemonic    : MnemonicType := "LB   ";
    constant LBU_mnemonic   : MnemonicType := "LBU  ";
    
    --store instructions:
    constant SW_mnemonic    : MnemonicType := "SW   ";
    constant SH_mnemonic    : MnemonicType := "SH   ";
    constant SB_mnemonic    : MnemonicType := "SB   ";
    
    --store constant instruction:
    constant INDEX_mnemonic : MnemonicType := "INDEX";
    constant VAL_mnemonic   : MnemonicType := "VAL  ";
    
end package mnemonic_pack;
