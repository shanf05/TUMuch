library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_BIT.ALL;
library work;
use work.defs_pack.all;
use work.inst_encoding_pack.all;
use work.inst_layout_pack.all;



entity RISCV is
end RISCV;

architecture functional of RISCV is
begin
    process
        variable PC : AddrType := X"0000";
        variable Instr : InstrType := (others=>'0');
        variable Reg : RegType := (others=>(others=>'0'));
        variable Mem: MemType := (others=>(others=>'0'));
        
        variable op_code : OpCode:= "0000000";
        variable func3: Funct3;
        variable rd, rs1, rs2: AddrType;
        variable funct7: Funct7;
        variable shamt : bit_vector(4 downto 0);                   -- only used for modified I-Type Instruction
        variable imm: ImmType := (others => '0');
        
        
    begin
        -- to be implemented: loop, execute instructions,
        
        
        -- fetch instruction
        Instr := Mem(to_integer(unsigned(PC(AddrSize-1 downto ByteAddrSize))));
        op_code := Instr(6 downto 0);
        
        if PC = X"FFFF" then PC := X"0000";
        else PC := bit_vector(unsigned(PC) + 4);
        end if;
        
        
        
        -- decode and execute instruction
        case op_code is
            -----------------------------------------------------------------------
            -- R-Type Instructions
            when OP =>            
                -- assign needed values 
                func3 := Instr(14 downto 12);
                rd := Instr(11 downto 7);
                rs1 := Instr(19 downto 15);
                rs2 := Instr(24 downto 20);
                funct7 := Instr(31 downto 25);
                
                case func3 is
                    when F3_ADD =>      -- F3_ADD and F3_SUB have the same value "000"
                        if funct7 = F7_ADD then      null;  -- ADD to be implemented
                        elsif funct7 = F7_SUB then   null;  -- SUB to be implemented
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
            -- end R-Type Instructions
            -----------------------------------------------------------------------
            -- I-Type  Instructions
            when Op_IMM =>
                func3 := Instr(14 downto 12);
                rd := Instr(11 downto 7);
                rs1 := Instr(19 downto 15);
                imm(10 downto 0) := Instr(30 downto 20);
                imm(31 downto 11) := (others => Instr(20));
                
                case func3 is
                    -- basic I-Type
                    when F3_ADDI    => null;                -- ADDI to be implemented
                    when F3_XOR    => null;                 -- XORI to be implemented
                    when F3_OR     => null;                 -- ORI to be implemented
                    when F3_AND    => null;                 -- ANDI to be implemented
                    when F3_SLT    => null;                 -- SLTI to be implemented
                    when F3_SLTU   => null;                 -- SLTIU to be implemented
                    -- I-Type Instructions modified
                    when F3_SLL | F3_SRL => -- F3_SRL and F3_SRA have the same value "101"
                        funct7 := Instr(31 downto 25);
                        shamt := Instr(24 downto 20);
                        if func3 = F3_SLL and funct7 = F7_SRL then null;        -- SLLI to be implemented 
                        elsif func3 = F3_SRL and funct7 = F7_SRL then null;     -- SRLI to be implemented
                        elsif func3 = F3_SRA and funct7 = F7_SRA then null;     -- SRAI to be implemented
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
                 
            when OP_LOAD =>
                func3 := Instr(14 downto 12);
                rd := Instr(11 downto 7);
                rs1 := Instr(19 downto 15);
                imm(10 downto 0) := Instr(30 downto 20);
                imm(31 downto 11) := (others => Instr(20));
                
                case func3 is
                    when F3_LB      => null;                -- LB to be implemented
                    when F3_LH      => null;                -- LH to be implemented
                    when F3_LW      => null;                -- LW to be implemented
                    when F3_LBU     => null;                -- LBU to be implemented
                    when F3_LHU     => null;                -- LHU to be implemented
                    when others =>                          -- cover invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP-LOAD"
                            severity error;
                end case;
            -- end I-Type Instructions
            -----------------------------------------------------------------------
            -- S-Type Instructions
            when OP_STORE =>
                func3 := Instr(14 downto 12);
                rd := Instr(11 downto 7);
                rs1 := Instr(19 downto 15);
                rs2 := Instr(24 downto 20);
                imm(0) := Instr(7);
                imm(4 downto 1) := Instr(11 downto 8);
                imm(10 downto 5) := Instr(30 downto 25);
                imm(31 downto 11) := (others => Instr(20));
                
                case func3 is
                    when F3_SB  => null;                    -- SB to be implemented
                    when F3_SH  => null;                    -- SH to be implemented
                    when F3_SW  => null;                    -- SW to be implemented
                    when others =>                          -- covers invalid cases
                            assert FALSE
                            report "Illegal Operation -- OP-STORE"
                            severity error;
                end case;
            -- end S-Type Instructions
            -----------------------------------------------------------------------
            -- U-Type Instructions
            when OP_LUI => 
                rd := Instr(11 downto 7);
                imm(31 downto 12) := Instr(31 downto 12);
                imm(11 downto 0) := (others => '0');
                null;                                       -- LUI to be implemented
            when OP_AUIPC   => 
                rd := Instr(11 downto 7);
                imm(31 downto 12) := Instr(31 downto 12);
                imm(11 downto 0) := (others => '0');
                null;                                       -- AUIPC to be implemented
            -- end U-Type Instructions
            -----------------------------------------------------------------------
            -- J-Type Instructions
            when OP_JAL => 
                rd := Instr(11 downto 7);
                imm(0) := '0';
                imm(4 downto 1) := Instr(24 downto 21);
                imm(10 downto 5) := Instr(30 downto 25);
                imm(11) := Instr(20);
                imm(19 downto 12) := Instr(19 downto 12);
                imm(31 downto 20) := (others => Instr(31));
                null;                                       -- JAL to be implemented
            -- end J-Type Instructions
            -----------------------------------------------------------------------
            -- B-Type Instructions
            when OP_Branch =>
                func3 := Instr(14 downto 12);
                rs1 := Instr(19 downto 15);
                rs2 := Instr(24 downto 20);
                imm(0) := '0';
                imm(4 downto 1) := Instr(11 downto 8);
                imm(10 downto 5) := Instr(30 downto 25);
                imm(11) := Instr(7);
                imm(31 downto 12) := (others => Instr(31));
                
                case func3 is
                    when F3_BEQ =>  null;               -- BEQ to be implemented
                    when F3_BNE =>  null;               -- BNE to be implemented
                    when F3_BLT =>  null;               -- BLT to be implemented
                    when F3_BGE =>  null;               -- BGE to be implemented
                    when F3_BLTU =>  null;              -- BLTU to be implemented
                    when F3_BGEU =>  null;              -- BGEU to be implemented
                    when others =>                      -- covers invalid cases
                        assert FALSE 
                        report "Illegal Operation -- OP_BRANCH" 
                        severity error;
                end case;
            -- end B-Type Instructions
            -----------------------------------------------------------------------

            when others =>          -- covers invalid cases
                assert FALSE
                report "Illegal Operation"
                severity error;
        end case;
                        
                        
        wait;
    end process;
end functional;
