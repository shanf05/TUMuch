--created by Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;
library work;
use work.inst_layout_pack.all;

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
    
    --LUT indices for instruction (divided into classes)
    constant ctrl_LOAD   : integer := 0;    --load instructions : LB, LBU, LH, LHU, LW
    constant ctrl_STORE  : integer := 1;    --store instructions: SB, SH, SW
    constant ctrl_ARTH   : integer := 2;    --arithm. instr.: ADD, SUB, AND, XOR, OR, AND, SLL, SRL, SRA, SLT, SLTU
    constant ctrl_ARTHI  : integer := 3;    --arithm. instr. + imm : ADDI, ANDI, XORI, ORI, SLLI, SRLI, SRAI, SLTI, SLTIU
    constant ctrl_JUMP   : integer := 4;    --JAL JALR
    constant ctrl_BRANCH : integer := 5;    --BEQ, BNE, BLT, BGE, BLTU, BGEU
    constant ctrl_LUI    : integer := 6;    
    constant ctrl_AUIPC  : integer := 7;
    constant ctrl_NOP    : integer := 8;   
    constant ctrl_STOP   : integer := 9;
    
    --Implementation using a record datatype -> Problem Slidesheets 11: Records might not be synthesizable??? -> Might delete after lecture tomorrow
    --LUT implementation for generating control signals to FSM 
    type ctrl_record_type is record
        cmd_stop, cmd_jmp, cmd_pc, cmd_io, cmd_reg, cmd_dir, cmd_const, cmd_calc, store, take_jmp : bit;
    end record;

    type decode_table_type is array (integer range 10 downto 0) of ctrl_record_type;
    
    constant decode_table : decode_table_type (0 to 10) := (
    --            STOP, JMP,  PC,  IO, REG, DIR, CONST, CALC, STORE, TAKE_JMP
    ctrl_LOAD   =>('0', '0', '1', '0', '1', '0',   '1',  '1',   '0', '0'),
    ctrl_STORE  =>('0', '0', '1', '0', '0', '0',   '1',  '1',   '1', '0'),
    ctrl_ARTH   =>('0', '0', '1', '0', '1', '0',   '0',  '1',   '0', '0'), 
    ctrl_ARTHI  =>('0', '0', '1', '0', '1', '0',   '1',  '1',   '0', '0'),
    ctrl_JUMP   =>('0', '1', '1', '0', '1', '0',   '1',  '1',   '0', '1'),
    ctrl_BRANCH =>('0', '1', '1', '0', '0', '0',   '1',  '1',   '0', '0'),
    ctrl_LUI    =>('0', '0', '1', '0', '1', '0',   '1',  '0',   '0', '0'),
    ctrl_AUIPC  =>('0', '0', '1', '0', '1', '0',   '1',  '1',   '0', '0'),
    ctrl_NOP    =>('0', '0', '0', '0', '0', '0',   '0',  '0',   '0', '0'),
    ctrl_STOP   =>('1', '0', '0', '0', '0', '0',   '0',  '0',   '0', '0'),
    others      =>('0', '0', '0', '0', '0', '0',   '0',  '0',   '0', '0')
    );
    
    --Implementation using a bit_vector
    subtype ctrl_bv_type is bit_vector(9 downto 0);
    
    type decode_table_type_bv is array(integer range 10 downto 0) of ctrl_bv_type;
    
    constant decode_table_bv : decode_table_type_bv (0 to 10) := (
    --            STOP,  JMP   PC    IO    REG   DIR    CONST  CALC   STORE  TAKE_JMP
    ctrl_LOAD   =>('0' & '0' & '1' & '0' & '1' & '0' &   '1' &  '1' &  '0' &  '0'),
    ctrl_STORE  =>('0' & '0' & '1' & '0' & '0' & '0' &   '1' &  '1' &  '1' &  '0'),
    ctrl_ARTH   =>('0' & '0' & '1' & '0' & '1' & '0' &   '0' &  '1' &  '0' &  '0'),    
    ctrl_ARTHI  =>('0' & '0' & '1' & '0' & '1' & '0' &   '1' &  '1' &  '0' &  '0'),
    ctrl_JUMP   =>('0' & '1' & '1' & '0' & '1' & '0' &   '1' &  '1' &  '0' &  '1'),
    ctrl_BRANCH =>('0' & '1' & '1' & '0' & '0' & '0' &   '1' &  '1' &  '0' &  '0'),
    ctrl_LUI    =>('0' & '0' & '1' & '0' & '1' & '0' &   '1' &  '0' &  '0' &  '0'),
    ctrl_AUIPC  =>('0' & '0' & '1' & '0' & '1' & '0' &   '1' &  '1' &  '0' &  '0'),
    ctrl_NOP    =>('0' & '0' & '0' & '0' & '0' & '0' &   '0' &  '0' &  '0' &  '0'),
    ctrl_STOP   =>('1' & '0' & '0' & '0' & '0' & '0' &   '0' &  '0' &  '0' &  '0'),
    others      =>('0' & '0' & '0' & '0' & '0' & '0' &   '0' &  '0' &  '0' &  '0')
    );
    
    
end package;