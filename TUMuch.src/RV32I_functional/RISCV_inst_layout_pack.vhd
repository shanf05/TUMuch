--erstellt von Severin Hanf

package inst_layout_pack is
    constant OpCodeSize : integer := 7; 
    
    subtype OpCode is bit_vector (OpCodeSize-1 downto 0);
    subtype Funct3 is bit_vector (2 downto 0);
    subtype Funct7 is bit_vector (6 downto 0);
    
    constant OP_IMM    : OpCode := "0010011";   
    constant OP_AUIPC  : OpCOde := "0010111";
    constant OP_OP     : OpCOde := "0110011";   
    constant OP_LUI    : OpCOde := "0110111";
    constant OP_JAL    : OpCOde := "1101111";
    constant OP_JALR   : OpCOde := "1100111";
    constant OP_BRANCH : OpCOde := "1100011";
    constant OP_LOAD   : OpCOde := "0000011";
    constant OP_STORE  : OpCOde := "0100011";
    constant OP_STOP   : OPCOde := "1010101";
    
    constant F3_SLLI : Funct3 := "001";
    constant F3_SRLI : Funct3 := "101";
    constant F3_SRAI : Funct3 := "101";
    constant F3_ADD  : Funct3 := "000";
    constant F3_SLT  : Funct3 := "010";
    constant F3_SLTU : Funct3 := "011";
    constant F3_AND  : Funct3 := "111";
    constant F3_OR   : Funct3 := "110";
    constant F3_XOR  : Funct3 := "100";
    constant F3_SLL  : Funct3 := "001";
    constant F3_SRL  : Funct3 := "101";
    constant F3_SUB  : Funct3 := "000";
    constant F3_SRA  : Funct3 := "101";
    constant F3_ADDI : Funct3 := "000";
    constant F3_BEQ  : Funct3 := "000";
    constant F3_BNE  : Funct3 := "001";
    constant F3_BLT  : Funct3 := "100";
    constant F3_BLTU : Funct3 := "110";
    constant F3_BGE  : Funct3 := "101";
    constant F3_BGEU : Funct3 := "111";
    constant F3_LB   : Funct3 := "000";
    constant F3_LH   : Funct3 := "001";
    constant F3_LW   : Funct3 := "010";
    constant F3_LBU  : Funct3 := "100";
    constant F3_LHU  : Funct3 := "101";
    constant F3_SB   : Funct3 := "000";
    constant F3_SH   : Funct3 := "001";
    constant F3_SW   : Funct3 := "010";
    constant F3_JALR : Funct3 := "000";
    
    constant F7_ADD : Funct7 := "0000000";
    constant F7_AND : Funct7 := "0000000";
    constant F7_SUB : Funct7 := "0100000";
    constant F7_SRL : Funct7 := "0000000";    
    constant F7_SRA : Funct7 := "0100000";
    constant F7_SLT : Funct7 := "0000000";
    constant F7_OR  : Funct7 := "0000000";
    constant F7_XOR : Funct7 := "0000000";
    constant F7_SLL : Funct7 := "0000000";
    
    constant NOP_Instr : bit_vector (31 downto 0):=  "00000000000000000" & F3_ADD & "00000" & OP_IMM;

end package inst_layout_pack; 