library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_BIT.ALL;
library work;
use work.defs_pack.all;
use work.inst_encoding_pack.all;
use work.inst_layout_pack.all;
use work.exec_procedures_pack.all; 
use work.trace_pack.all; 
use work.mem_pack.all;
use std.textio.all; 
use work.helper_func.all;

entity RISCV is
end RISCV;

architecture functional of RISCV is
    file TraceFile : Text open write_mode is "../../../../TUMuch.rsc/trace.txt"; 
    file AsmFile : Text open read_mode is "../../../../TUMuch.rsc/asm_input_memory_overflow.txt";
    file DataDumpFile : Text open write_mode is "../../../../TUMuch.rsc/data_dump.txt"; 
    file BinFile : Text open read_mode is "../../../../TUMuch.rsc/bin_input.txt";
begin       
    process
        variable PC    : PCType     := 0;
        variable Instr : InstrType  := (others=>'0');
        variable Reg   : RegType    := (others=>(others=>'0'));
        variable Mem   : MemType    := (others=>(others=>'0'));        
        variable op_code : OpCode   := "0000000";
        variable func3   : Funct3;
        variable rd      : RegAddrType;
        variable rs1     : RegAddrType;
        variable rs2     : RegAddrType;
        variable funct7  : Funct7;
        variable imm     : ImmType := (others => '0');     
        variable l       : line;
    begin 
        print_header(TraceFile);
        print_tail(TraceFile); 
        mem := init_memory_asm(AsmFile);
        --mem := init_memory_bin(BinFile); --alternative
        loop
        -- fetch instruction
        Instr := Mem(pc/4);
        op_code := Instr(6 downto 0);
        -- decode and execute instruction
        case op_code is
            -----------------------------------------------------------------------
            -- R-Type Instructions
            when OP_OP =>            
                -- assign needed values 
                func3 := Instr(14 downto 12);
                rd := to_integer(unsigned(Instr(11 downto 7)));
                rs1 := to_integer(unsigned(Instr(19 downto 15)));
                rs2 := to_integer(unsigned(Instr(24 downto 20)));
                funct7 := Instr(31 downto 25);           
                imm := (others=>'0');   
                write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => true, hasRs1 => true, hasRs2 => true);
                write_registers(l => l, reg => reg, op=>op_code, imm => imm , hasImm => false);
                
                case func3 is
                    when F3_ADD =>      -- F3_ADD and F3_SUB have the same value "000"                        
                        if funct7 = F7_ADD then      ADD_exec(rd=>rd, rs1=>rs1, rs2=>rs2, reg=>reg, pc=>pc);
                        elsif funct7 = F7_SUB then   SUB_exec(rd=>rd, rs1=>rs1, rs2=>rs2, reg=>reg, pc=>pc);
                        else                                -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP_OP -> ADD | SUB"
                            severity failure;                            
                        end if;
                        
                    when F3_SLL     =>  SLL_exec(rd => rd, rs1 => rs1, rs2 => rs2, reg => reg, pc => pc);   
                    
                    when F3_SRL =>      -- F3_SRL and F3_SRA have the same value "101"
                        if funct7 = F7_SRL      then      SRL_exec(rd => rd, rs1 => rs1, rs2 => rs2, reg => reg, pc => pc);   
                        elsif funct7 = F7_SRA   then      SRA_exec(rd => rd, rs1 => rs1, rs2 => rs2, reg => reg, pc => pc);   
                        else                                -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP_OP -> SRL | SRA"
                            severity failure;
                        end if;                        
                    when F3_XOR     =>  XOR_exec(rd => rd, rs1 => rs1, rs2 => rs2, reg => reg, pc => pc);
                    when F3_OR      =>  OR_exec(rd => rd, rs1 => rs1, rs2 => rs2, reg => reg, pc => pc); 
                    when F3_AND     =>  AND_exec(rd => rd, rs1 => rs1, rs2 => rs2, reg => reg, pc => pc);
                    when F3_SLT     =>  SLT_exec(rd => rd, rs1 => rs1, rs2 => rs2, reg => reg, pc => pc);
                    when F3_SLTU    =>  SLTU_exec(rd => rd, rs1 => rs1, rs2 => rs2, reg => reg, pc => pc);
                    when others =>                          -- cover invalid cases
                        assert FALSE
                        report "Illegal Operation -- OP_OP"
                        severity failure;
                end case;
                
            -- end R-Type Instructions
            -----------------------------------------------------------------------
            -- I-Type  Instructions
            when Op_IMM =>
                func3 := Instr(14 downto 12);
                rd := to_integer(unsigned(Instr(11 downto 7)));
                rs1 := to_integer(unsigned(Instr(19 downto 15)));
                rs2 := 0;   --not best solution right now -> make it similar to no_param!
                imm(11 downto 0) := Instr(31 downto 20);
                imm(31 downto 12) := (others => Instr(31));
                if(Instr = NOP_instr) then                
                    write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => false, hasRs1 => false, hasRs2 => false);
                    write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => false);
                else 
                    write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => true, hasRs1 => true, hasRs2 => false);
                    write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => true);
                end if;  
                              
                case func3 is
                    -- basic I-Type
                    when F3_ADDI   => ADDI_exec(rs1 => rs1, rd => rd, imm => imm, reg => reg, pc => pc);                
                    when F3_XOR    => XORI_exec(rs1 => rs1, rd => rd, imm => imm, reg => reg, pc => pc);
                    when F3_OR     => ORI_exec (rs1 => rs1, rd => rd, imm => imm, reg => reg, pc => pc);
                    when F3_AND    => ANDI_exec(rs1 => rs1, rd => rd, imm => imm, reg => reg, pc => pc);
                    when F3_SLT    => SLTI_exec(rs1 => rs1, rd => rd, imm => imm, reg => reg, pc => pc);
                    when F3_SLTU   => SLTIU_exec(rs1 => rs1, rd => rd, imm => imm, reg => reg, pc => pc);
                    -- I-Type Instructions modified
                    when F3_SLL | F3_SRL => -- F3_SRL and F3_SRA have the same value "101"
                        funct7 := Instr(31 downto 25);
                        if func3 = F3_SLL and funct7 = F7_SRL then SLLI_exec(rs1 => rs1, rd => rd, imm => imm, reg => reg, pc => pc);
                        elsif func3 = F3_SRL and funct7 = F7_SRL then SRLI_exec(rs1 => rs1, rd => rd, imm => imm, reg => reg, pc => pc);
                        elsif func3 = F3_SRA and funct7 = F7_SRA then SRAI_exec(rs1 => rs1, rd => rd, imm => imm, reg => reg, pc => pc);
                        else                                                    -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP_IMM -> SRL | SRA"
                            severity failure;
                        end if;
                    -- end I-Type Instructions modified
                    when others =>                                  -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP_IMM"
                            severity failure;
                end case;                
                 
            when OP_LOAD =>
                func3 := Instr(14 downto 12);
                rd := to_integer(unsigned(Instr(11 downto 7)));
                rs1 := to_integer(unsigned(Instr(19 downto 15)));
                rs2 := 0;               -- find better way of doing this
                imm(11 downto 0) := Instr(31 downto 20);
                imm(31 downto 12) := (others => imm(11));
                write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => true, hasRs1 => true, hasRs2 => false);
                write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => true);                 
                case func3 is
                    when F3_LB      => LB_exec(rd => rd, rs1 => rs1, imm => imm, reg => reg, mem => mem, pc => pc);
                    when F3_LH      => LH_exec(rd => rd, rs1 => rs1, imm => imm, reg => reg, mem => mem, pc => pc);
                    when F3_LW      => LW_exec(rd => rd, rs1 => rs1, imm => imm, reg => reg, mem => mem, pc => pc);
                    when F3_LBU     => LBU_exec(rd => rd, rs1 => rs1, imm => imm, reg => reg, mem => mem, pc => pc);
                    when F3_LHU     => LHU_exec(rd => rd, rs1 => rs1, imm => imm, reg => reg, mem => mem, pc => pc);
                    when others =>                          -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP_LOAD"
                            severity failure;
                end case;
                
            when OP_JALR =>                 
                rd := to_integer(unsigned(Instr(11 downto 7)));     --return address
                rs1 := to_integer(unsigned(Instr(19 downto 15)));   --base address
                rs2 := 0;                
                imm(10 downto 1) := Instr(30 downto 21);
                imm(31 downto 11) := (others => Instr(31));
                write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => true, hasRs1 => true, hasRs2 => false);
                write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => true); 
                JALR_exec(rs1=>rs1, rd=>rd, imm=>imm, reg=>reg, pc=>pc);
                -- end I-Type Instructions
            -----------------------------------------------------------------------
            -- S-Type Instructions
            when OP_STORE =>
                func3 := Instr(14 downto 12);                
                rs1 := to_integer(unsigned(Instr(19 downto 15)));
                rs2 := to_integer(unsigned(Instr(24 downto 20)));
                imm(4 downto 0) := Instr(11 downto 7);
                imm(11 downto 5) := Instr(31 downto 25);
                imm(31 downto 12) := (others => imm(11));   
                write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => false, hasRs1 => true, hasRs2 => true);
                write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => true);              
                case func3 is
                    when F3_SB  => SB_exec(rs1 => rs1, rs2 => rs2, imm => imm, reg => reg, mem => mem, pc => pc);
                    when F3_SH  => SH_exec(rs1 => rs1, rs2 => rs2, imm => imm, reg => reg, mem => mem, pc => pc);
                    when F3_SW  => SW_exec(rs1 => rs1, rs2 => rs2, imm => imm, reg => reg, mem => mem, pc => pc);
                    when others =>                          -- covers invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP_STORE"
                            severity failure;
                end case;                
            -- end S-Type Instructions
            -----------------------------------------------------------------------
            -- U-Type Instructions
            when OP_LUI => 
                rd := to_integer(unsigned(Instr(11 downto 7)));
                rs1 := 0; 
                rs2 := 0; 
                imm(31 downto 12) := Instr(31 downto 12);
                imm(11 downto 0) := (others => '0');               
                write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => true, hasRs1 => false, hasRs2 => false);
                write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => true); 
                LUI_exec(rd => rd, imm => imm, reg => reg, pc => pc);
            when OP_AUIPC   => 
                rd := to_integer(unsigned(Instr(11 downto 7)));
                rs1 := 0; 
                rs2 := 0;
                imm(31 downto 12) := Instr(31 downto 12);
                imm(11 downto 0) := (others => '0');        
                write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => true, hasRs1 => false, hasRs2 => false);
                write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => true);         
                AUIPC_exec(rd => rd, imm => imm, reg => reg, pc => pc);
            -- end U-Type Instructions
            -----------------------------------------------------------------------
            -- J-Type Instructions
            when OP_JAL => 
                rd := to_integer(unsigned(Instr(11 downto 7)));
                rs1 := 0; 
                rs2 := 0; 
                imm(0) := '0';
                imm(10 downto 1)    := Instr(30 downto 21);
                imm(11)             := Instr(20);
                imm(19 downto 12)   := Instr(19 downto 12);
                imm(31 downto 20)   := (others => Instr(31));    
                write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => true, hasRs1 => false, hasRs2 => false);
                write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => true);             
                JAL_exec(rd=>rd, imm=>imm, reg=>reg, pc=>pc);
            -- end J-Type Instructions
            -----------------------------------------------------------------------
            -- B-Type Instructions
            when OP_Branch =>
                func3 := Instr(14 downto 12);                
                rs1 := to_integer(unsigned(Instr(19 downto 15)));
                rs2 := to_integer(unsigned(Instr(24 downto 20)));
                rd := 0; 
                imm(0) := '0';
                imm(4 downto 1) := Instr(11 downto 8);
                imm(10 downto 5) := Instr(30 downto 25);
                imm(11) := Instr(7);
                imm(31 downto 12) := (others => Instr(31));                 
                write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => false, hasRs1 => true, hasRs2 => true);
                write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => true);        
                case func3 is
                    when F3_BEQ  => BEQ_exec (rs1=>rs1, rs2=>rs2, imm=>imm, reg=>reg, pc=>pc);               
                    when F3_BNE  => BNE_exec (rs1=>rs1, rs2=>rs2, imm=>imm, reg=>reg, pc=>pc);               
                    when F3_BLT  => BLT_exec (rs1=>rs1, rs2=>rs2, imm=>imm, reg=>reg, pc=>pc);
                    when F3_BGE  => BGE_exec (rs1=>rs1, rs2=>rs2, imm=>imm, reg=>reg, pc=>pc);
                    when F3_BLTU => BLTU_exec (rs1=>rs1, rs2=>rs2, imm=>imm, reg=>reg, pc=>pc);
                    when F3_BGEU => BGEU_exec (rs1=>rs1, rs2=>rs2, imm=>imm, reg=>reg, pc=>pc);
                    when others =>                      -- covers invalid cases
                        assert FALSE 
                        report "Illegal Operation -- OP_BRANCH" 
                        severity failure;
                end case;                
            -- end B-Type Instructions
            -----------------------------------------------------------------------
            
            --STOP Instruction
            when OP_STOP =>
                if Instr = STOP_code then 
                    rs1 := 0; 
                    rs2 := 0; 
                    rd := 0;
                    imm := (others =>'0');
                    write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => false, hasRs1 => false, hasRs2 => false);
                    write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => false); 
                    writeline(TraceFile, l);    --has to be done, because loop is exited right after
                    STOP_exec;
                    exit; 
                else
                    assert False
                    report "Illegal Operation -- STOP command"
                    severity failure;
                end if;

            when others =>          -- covers invalid cases       
                rs1 := 0; 
                rs2 := 0; 
                rd := 0; 
                imm := (others =>'0');
                write_instr_info(l => l, instr => instr, pc => pc, rs1 => rs1, rs2 => rs2, rd => rd, hasRd => false, hasRs1 => false, hasRs2 => false);
                write_registers(l => l, reg => reg, op=>op_code, imm => imm, hasImm => false);                           
                assert FALSE
                report "Illegal Operation -- no OP_CODE"
                severity failure;                
        end case;
        writeline(TraceFile, l);
        end loop;
        print_tail(Tracefile);
        memory_data_dump(mem, DataDumpFile);          
        wait;
    end process;    
end functional;
