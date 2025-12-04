--created by Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.defs_pack.all;
use work.inst_layout_pack.all;
use work.instr_dec_pack.all;

--decoder
    --signals to ALU: OP
    --signals to RegFile: sel_out_a, sel_out_b, sel_out_c, sel_in 
    --signal  to FSM: ctrl (cmd_stop, cmd_jmp, cmd_pc, cmd_io, cmd_reg, cmd_dir, cmd_const, cmd_calc, store, take_jmp)

entity RISCV_ctrl_instr_dec is
    Port (instr : in bit_vector(BusDataSize-1 downto 0);
          sel_in, sel_out_a, sel_out_b : out bit_vector(4 downto 0); --sel_out_a = rd, sel_out_b = rs1, sel_out_c = rs2
          ctrl : out ctrl_bv_type;
          op : out bit_vector(2 downto 0);
          imm : out Immtype                                             
          );

end RISCV_ctrl_instr_dec;


architecture RTL of RISCV_ctrl_instr_dec is 
signal op_code : bit_vector(6 downto 0) := (others => '0');         --prevent Latch
signal func3 : bit_vector(2 downto 0) := (others => '0');           --prevent Latch
signal func7 : bit_vector(6 downto 0) := (others => '0');           --prevent Latch
begin
    op_code <= instr(6 downto 0);
    
    process
    begin
    case op_code is
        -- R-Type Instructions
        when OP_OP =>
            func3 <= instr(14 downto 12);
            func7 <= instr(31 downto 25);
            sel_in <= instr(11 downto 7);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= instr(24 downto 20);
            ctrl <= decode_table_bv(ctrl_ARTH);    --all R-Type Instructions have the same control signal
            imm <= (others => '0');
            
            case func3 is
                when F3_ADD  => 
                        case func7 is
                            when F7_ADD =>
                                op <= ALU_ADD;
                            when F7_SUB =>
                                op <= ALU_SUB;
                        end case; 
                when F3_SLL  =>
                    op <= ALU_SLL;

                when F3_SRL  =>
                    op <= ALU_SRL;
                        case func7 is
                            when F7_SRL =>
                            when F7_SRA =>
                        end case;
                when F3_XOR  =>
                    op <= ALU_XOR;
                when F3_OR   =>
                    op <= ALU_OR; 
                when F3_AND  =>
                    op <= ALU_AND;
                when F3_SLT  =>
                    op <= ALU_SUB;          --for command slt -> Subtract rs1 and rs2 and check if value is greater 0
                when F3_SLTU =>
                    op <= ALU_SUB;
                when F3_SLL  =>
                    op <= ALU_SLL;
                when F3_SRL =>
                    func7 <= instr(31 downto 25);
                    case func7 is
                        when F7_SRL =>
                        when F7_SRA =>
                    end case;  
                  
                                
            end case;
        -- end R-Type        
        ---------------------------------------------------------------------------------------------    
        -- I-Type Instructions
        when OP_IMM =>
            func3 <= instr(14 downto 12);
            sel_in <= instr(11 downto 7);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= (others => '0');
            ctrl <= decode_table_bv(ctrl_ARTHI);
            imm(11 downto 0) <= instr(31 downto 20);
            imm(31 downto 12) <= (others => instr(31));
            
            case func3 is
                when F3_ADDI   =>
                    op <= ALU_ADD;
                when F3_XOR    => 
                    op <= ALU_XOR;
                when F3_OR     => 
                    op <= ALU_OR;
                when F3_AND    => 
                    op <= ALU_AND;
                when F3_SLT    => 
                    op <= ALU_SUB;
                when F3_SLTU   =>
                    op <= ALU_SUB;
                when F3_SLL  =>
                    op <= ALU_SLL;
                when F3_SRL =>
                    func7 <= instr(31 downto 25);
                    case func7 is
                        when F7_SRL =>
                        when F7_SRA =>
                    end case;
        
            end case;
        -- end I-Type
 
        --Load Instructions
        when OP_Load =>
            func3 <= instr(14 downto 12);
            sel_in <= instr(11 downto 7);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= (others => '0');
            imm(11 downto 0) <= instr(31 downto 20);
            imm(31 downto 0) <= (others => instr(31));
            ctrl <= decode_table_bv(ctrl_Load);
            
            case func3 is
                when F3_LB => 
                when F3_LH =>
                when F3_LW =>
                when F3_LBU =>
                when F3_LHU =>
            end case;
        
        --end I-Type
        ---------------------------------------------------------------------------------------------
        --Store instructions (S-Type)
        when OP_STORE =>
            func3 <= instr(14 downto 12);
            sel_in <= (others => '0');
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= instr(24 downto 20);
            ctrl <= decode_table_bv(ctrl_STORE);
            op <= (others => '0');                         --no ALU Operation needed
            imm(4 downto 0) <= instr(11 downto 7);
            imm(11 downto 5) <= instr(31 downto 25);
            imm(31 downto 12) <= (others => '0');
            case func3 is
                when F3_SB  =>
                when F3_SH  => 
                when F3_SW  => 
             end case;
            
        -- end S-Type
        ---------------------------------------------------------------------------------------------
        --branch-type instructions (B-Type)
        when OP_BRANCH =>
            func3 <= instr(14 downto 12);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= instr(24 downto 20);
            sel_in <= (others => '0');
            ctrl <= decode_table_bv(ctrl_branch);
            op <="000";                         --no ALU Operation needed
            imm(3 downto 0) <= instr(11 downto 8);
            imm(9 downto 4) <= instr(30 downto 25);
            imm(10) <= instr(7);
            imm(31 downto 11) <= (others => instr(31));
            
            case func3 is
                when F3_BEQ  => 
                when F3_BNE  => 
                when F3_BLT  => 
                when F3_BGE  => 
                when F3_BLTU => 
                when F3_BGEU =>
            end case;
            
        -- end B-Type
        ---------------------------------------------------------------------------------------------    
        --upper-immediate-type instructions (U-Type)
            --LUI instruction
        when OP_LUI =>
            imm(31 downto 12) <= instr(31 downto 12);
            imm(11 downto 0) <= (others => '0');
            sel_in <= instr(11 downto 7);
            sel_out_a <= (others => '0');
            sel_out_b <= (others => '0');
            ctrl <= decode_table_bv(ctrl_LUI);
            op <= (others => '0');                                         --no ALU Operation needed
            --AUIPC instruction
        when OP_AUIPC =>
            imm(31 downto 12) <= instr(31 downto 12);
            imm(11 downto 0) <= (others => '0');
            sel_in <= instr(11 downto 7);
            op <= (others => '0');                                         --no ALU Operation needed
            ctrl <= decode_table_bv(ctrl_AUIPC);
        
        --jump-type instructions (J-Type)
            --JAL instruction
        when OP_JAL =>
            sel_in <= instr(11 downto 7);            
            ctrl <= decode_table_bv(ctrl_JUMP);
            op <= (others => '0');                                     --no ALU Operation needed
            imm(0) <= '0';
            imm(10 downto 1)    <= instr(30 downto 21);
            imm(11)             <= instr(20);
            imm(19 downto 12)   <= instr(19 downto 12);
            imm(31 downto 20)   <= (others => instr(31));
            
            --JALR instruction
        when OP_JALR =>
            sel_in <= instr(11 downto 7);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= (others => '0'); 
            ctrl <= decode_table_bv(ctrl_JUMP);
            imm(11 downto 0) <= instr(31 downto 20);
            imm(31 downto 12) <= (others => instr(31));            
         
         -- end J-Type
         ---------------------------------------------------------------------------------------------
          -- Stop instruction
        when OP_STOP =>
            sel_in <= (others => '0');
            sel_out_a <= (others => '0');
            sel_out_b <= (others => '0');
            ctrl <= decode_table_bv(ctrl_STOP);
            imm <= (others => '0');
        
    end case;
end process;

end RTL;
