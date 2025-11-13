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

entity RISCV is
end RISCV;

architecture functional of RISCV is
    file TraceFile : Text is out "trace.txt"; 
begin
    print_header(TraceFile);
    print_tail(TraceFile);    
    process
        variable PC    : MemAddrType := 0;
        variable Instr : InstrType := (others=>'0');
        variable Reg   : RegType := (others=>(others=>'0'));
        variable Mem   : MemType := init_memory("asm_input.txt");
        
        variable op_code : OpCode:= "0000000";
        variable func3   : Funct3;
        variable rd      : RegAddrType;
        variable rs1     : RegAddrType;
        variable rs2     : RegAddrType;
        variable funct7  : Funct7;
        variable shamt   : bit_vector(4 downto 0);                   -- only used for modified I-Type Instruction
        variable imm     : ImmType := (others => '0');     
        variable l       : line;
    begin 
        -- fetch instruction
        Instr := Mem(PC);
        op_code := Instr(6 downto 0);
            
        if (PC >= 2**MemAddrSize-1) then PC := 0;
        --else PC := PC + 4;   note severin: ich würde das bei den einzelnen executions machen, weil nicht immer +4 (z.b. jumps etc)
        end if;
        
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
                
                case func3 is
                    when F3_ADD =>      -- F3_ADD and F3_SUB have the same value "000"
                        if funct7 = F7_ADD then      ADD_exec(rd, rs1, rs2, reg, mem);  -- ADD to be implemented
                        elsif funct7 = F7_SUB then   SUB_exec(rd, rs1, rs2, reg, mem);  -- SUB to be implemented
                        else                                -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- ADD | SUB"
                            severity error;
                        end if;
                        
                    when F3_SLL =>  null;   -- SLL to be implemented
                    
                    when F3_SRL =>      -- F3_SRL and F3_SRA have the same value "101"
                        if funct7 = F7_SRL then     null;   -- SRL to be implemented
                        elsif funct7 = F7_SRA then  null;   -- SRA to be implemented
                        else                                -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP -> SRL | SRA"
                            severity error;
                        end if;
                        
                    when F3_XOR =>  null;                   -- XOR to be implemented
                    when F3_OR =>   null;                   -- OR to be implemented
                    when F3_AND =>  null;                   -- AND to be implemented
                    when F3_SLT =>  null;                   -- SLT to be implemented
                    when F3_SLTU => null;                   -- SLTU to be implemented
                    when others =>                          -- cover invalid cases
                        assert FALSE
                        report "Illegal Operation -- OP"
                        severity error;
                end case;
                write_instruction_trace(l=>l, reg=>reg, instr=>instr, pc=>pc);
            -- end R-Type Instructions
            -----------------------------------------------------------------------
            -- I-Type  Instructions
            when Op_IMM =>
                func3 := Instr(14 downto 12);
                rd := to_integer(unsigned(Instr(11 downto 7)));
                rs1 := to_integer(unsigned(Instr(19 downto 15)));
                imm(10 downto 0) := Instr(30 downto 20);
                imm(31 downto 11) := (others => Instr(31));
                
                case func3 is
                    -- basic I-Type
                    when F3_ADDI   => ADDI_exec(rs1 => rs1, rd => rd, imm => imm, mem => mem, reg => reg);                
                    when F3_XOR    => XORI_exec(rs1 => rs1, rd => rd, imm => imm, mem => mem, reg => reg, pc => pc);
                    when F3_OR     => ORI_exec (rs1 => rs1, rd => rd, imm => imm, mem => mem, reg => reg, pc => pc);
                    when F3_AND    => ANDI_exec(rs1 => rs1, rd => rd, imm => imm, mem => mem, reg => reg, pc => pc);
                    when F3_SLT    => SLTI_exec(rs1 => rs1, rd => rd, imm => imm, mem => mem, reg => reg, pc => pc);
                    when F3_SLTU   => SLTIU_exec(rs1 => rs1, rd => rd, imm => imm, mem => mem, reg => reg, pc => pc);
                    -- I-Type Instructions modified
                    when F3_SLL | F3_SRL => -- F3_SRL and F3_SRA have the same value "101"
                        funct7 := Instr(31 downto 25);
                        shamt := Instr(24 downto 20);
                        if func3 = F3_SLL and funct7 = F7_SRL then SLLI_exec(rs1 => rs1, rd => rd, imm => imm, mem => mem, reg => reg, pc => pc);
                        elsif func3 = F3_SRL and funct7 = F7_SRL then SRLI_exec(rs1 => rs1, rd => rd, imm => imm, mem => mem, reg => reg, pc => pc);
                        elsif func3 = F3_SRA and funct7 = F7_SRA then SRAI_exec(rs1 => rs1, rd => rd, imm => imm, mem => mem, reg => reg, pc => pc);
                        else                                                    -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP-IMM -> SRL | SRA"
                            severity error;
                        end if;
                    -- end I-Type Instructions modified
                    when others =>                                  -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP-IMM"
                            severity error;
                end case;
                write_instruction_trace(l=>l, reg=>reg, instr=>instr, pc=>pc);
                 
            when OP_LOAD =>
                func3 := Instr(14 downto 12);
                rd := to_integer(unsigned(Instr(11 downto 7)));
                rs1 := to_integer(unsigned(Instr(19 downto 15)));
                imm(10 downto 0) := Instr(30 downto 20);
                imm(31 downto 11) := (others => Instr(20));
                
                case func3 is
                    when F3_LB      => LB_exec(rs1, rs2, imm, reg, mem);                -- LB to be implemented
                    when F3_LH      => LH_exec(rs1, rs2, imm, reg, mem);                -- LH to be implemented
                    when F3_LW      => LW_exec(rs1, rs2, imm, reg, mem);                -- LW to be implemented
                    when F3_LBU     => LBU_exec(rs1, rs2, imm, reg, mem);                -- LBU to be implemented
                    when F3_LHU     => LHU_exec(rs1, rs2, imm, reg, mem);                -- LHU to be implemented
                    when others =>                          -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP-LOAD"
                            severity error;
                end case;
                write_instruction_trace(l=>l, reg=>reg, instr=>instr, pc=>pc);
            when OP_JALR => 
                rd := to_integer(unsigned(Instr(11 downto 7)));
                rs1 := to_integer(unsigned(Instr(19 downto 15)));
                imm(10 downto 1) := Instr(30 downto 21);
                imm(31 downto 11) := (others => Instr(31));      
                write_instruction_trace(l=>l, reg=>reg, instr=>instr, pc=>pc);          
                JALR_exec(rs1, rd, imm, mem, reg, pc);               
                
            -- end I-Type Instructions
            -----------------------------------------------------------------------
            -- S-Type Instructions
            when OP_STORE =>
                func3 := Instr(14 downto 12);
                rd := to_integer(unsigned(Instr(11 downto 7)));
                rs1 := to_integer(unsigned(Instr(19 downto 15)));
                rs2 := to_integer(unsigned(Instr(24 downto 20)));
                imm(4 downto 0) := Instr(11 downto 7);
                imm(10 downto 5) := Instr(30 downto 25);
                imm(31 downto 11) := (others => Instr(31));
                
                case func3 is
                    when F3_SB  => SB_exec(rs1, rs2, imm, reg, mem);                    -- SB to be implemented
                    when F3_SH  => SH_exec(rs1, rs2, imm, reg, mem);                    -- SH to be implemented
                    when F3_SW  => SW_exec(rs1, rs2, imm, reg, mem);                    -- SW to be implemented
                    when others =>                          -- covers invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP-STORE"
                            severity error;
                end case;
                write_instruction_trace(l=>l, reg=>reg, instr=>instr, pc=>pc);
            -- end S-Type Instructions
            -----------------------------------------------------------------------
            -- U-Type Instructions
            when OP_LUI => 
                rd := to_integer(unsigned(Instr(11 downto 7)));
                imm(31 downto 12) := Instr(31 downto 12);
                imm(11 downto 0) := (others => '0');
                write_instruction_trace(l=>l, reg=>reg, instr=>instr, pc=>pc);
                LUI_exec(rd => rd, imm => imm, mem => mem, reg => reg, pc => pc);
            when OP_AUIPC   => 
                rd := to_integer(unsigned(Instr(11 downto 7)));
                imm(31 downto 12) := Instr(31 downto 12);
                imm(11 downto 0) := (others => '0');
                write_instruction_trace(l=>l, reg=>reg, instr=>instr, pc=>pc);
                AUIPC_exec(rd => rd, imm => imm, mem => mem, reg => reg, pc => pc);
            -- end U-Type Instructions
            -----------------------------------------------------------------------
            -- J-Type Instructions
            when OP_JAL => 
                rd := to_integer(unsigned(Instr(11 downto 7)));
                imm(0) := '0';
                imm(4 downto 1) := Instr(24 downto 21);
                imm(10 downto 5) := Instr(30 downto 25);
                imm(11) := Instr(20);
                imm(19 downto 12) := Instr(19 downto 12);
                imm(31 downto 20) := (others => Instr(31));
                write_instruction_trace(l=>l, reg=>reg, instr=>instr, pc=>pc);
                JAL_exec(rd, imm, mem, reg, pc);
            -- end J-Type Instructions
            -----------------------------------------------------------------------
            -- B-Type Instructions
            when OP_Branch =>
                func3 := Instr(14 downto 12);
                rs1 := to_integer(unsigned(Instr(19 downto 15)));
                rs2 := to_integer(unsigned(Instr(24 downto 20)));
                imm(0) := '0';
                imm(4 downto 1) := Instr(11 downto 8);
                imm(10 downto 5) := Instr(30 downto 25);
                imm(11) := Instr(7);
                imm(31 downto 12) := (others => Instr(31));
                
                case func3 is
                    when F3_BEQ  => BEQ_exec (rs1, rs2, imm, mem, reg, pc);               
                    when F3_BNE  => BNE_exec (rs1, rs2, imm, mem, reg, pc);               
                    when F3_BLT  => BLT_exec (rs1, rs2, imm, mem, reg, pc);
                    when F3_BGE  => BGE_exec (rs1, rs2, imm, mem, reg, pc);
                    when F3_BLTU => BLTU_exec (rs1, rs2, imm, mem, reg, pc);
                    when F3_BGEU => BGEU_exec (rs1, rs2, imm, mem, reg, pc);
                    when others =>                      -- covers invalid cases
                        assert FALSE 
                        report "Illegal Operation -- OP_BRANCH" 
                        severity error;
                end case;
                write_instruction_trace(l=>l, reg=>reg, instr=>instr, pc=>pc);
            -- end B-Type Instructions
            -----------------------------------------------------------------------

            when others =>          -- covers invalid cases
                assert FALSE
                report "Illegal Operation"
                severity error;
        end case;      
        wait;
    end process;
    print_tail(TraceFile);
end functional;
