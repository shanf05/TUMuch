--created by Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.defs_pack.all;
use work.inst_layout_pack.all;
use work.instr_dec_pack.all;

--decoder
    --signals to ALU: OP
    --signals to RegFile: sel_in, sel_out_a, sel_out_b
    --signal  to FSM: ctrl (cmd_stop, cmd_jmp, cmd_auipc, cmd_reg, cmd_load, cmd_const, cmd_calc, cmd_store, cmd_take_jmp)

entity ctrl_instr_dec is
    Port (instr : in bit_vector(BusDataSize-1 downto 0);
          sel_in, sel_out_a, sel_out_b : out bit_vector(4 downto 0); --sel_out_a = rd, sel_out_b = rs1, sel_out_c = rs2
          pc_in : in bit_vector (AddrSize-1 downto 0);
          ctrl : out CtrlType;
          op : out bit_vector(3 downto 0);
          const_1 : out Immtype;
          const_2 : out Immtype                                             
          );
end ctrl_instr_dec;

architecture RTL of ctrl_instr_dec is 
signal op_code : bit_vector(6 downto 0) := (others => '0');         --prevent Latch
signal func3 : bit_vector(2 downto 0) := (others => '0');           --prevent Latch
signal func7 : bit_vector(6 downto 0) := (others => '0');           --prevent Latch
signal cmd_take_jmp, cmd_store, cmd_calc, cmd_const, cmd_load, cmd_reg, cmd_auipc, cmd_jmp, cmd_stop : bit;
begin
    op_code <= instr(6 downto 0);
    
    process
    begin
    -- default assignment of ctrl signals
    cmd_take_jmp <='0'; cmd_store <='0'; cmd_calc <='0'; cmd_const <='0'; cmd_load <='0';
    cmd_reg <= '0'; cmd_auipc <='0'; cmd_jmp <='0'; cmd_stop <= '0';
    func3 <= (others => '0'); func7 <= (others => '0'); op <= (others => '0');
    case op_code is
        -- R-Type Instructions
        when OP_OP =>
            func3 <= instr(14 downto 12);
            func7 <= instr(31 downto 25);
            sel_in <= instr(11 downto 7);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= instr(24 downto 20);
            --ctrl table
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE, TAKE_JMP
            -- '0', '0',   '0', '0',  '0',   '0',  '1',   '0',   '0'
            cmd_calc <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store & cmd_take_jmp;
            const_2 <= (others => '0');
            const_1(13 downto 0) <= pc_in (13 downto 0);
            const_1(31 downto 14) <= (others => '0');
            
            case func3 is
                when F3_ADD  => 
                        case func7 is
                            when F7_ADD =>
                                op <= ALU_ADD;
                            when F7_SUB =>
                                op <= ALU_SUB;
                            when others =>
                        end case; 
                when F3_SLL  =>    --this is also F3_SRA
                    case func7 is 
                        when F7_SLL =>
                            op <= ALU_SLL;
                        when F7_SRA =>
                            op <= ALU_SRA;
                        when others =>
                    end case;                
                when F3_XOR  =>
                    op <= ALU_XOR;
                when F3_OR   =>
                    op <= ALU_OR; 
                when F3_AND  =>
                    op <= ALU_AND;
                when F3_SLT  =>
                    op <= ALU_SLT;         
                when F3_SLTU =>
                    op <= ALU_SLTU;
                when F3_SRL =>
                    func7 <= instr(31 downto 25);
                    case func7 is
                        when F7_SRL =>
                            op <= ALU_SRL;
                        when F7_SRA =>
                            op <= ALU_SRA;
                        when others =>
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
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE, TAKE_JMP
            -- '0', '0',   '0', '0',  '0',   '1',  '1',   '0',   '0'
            cmd_const <= '1'; cmd_calc <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store & cmd_take_jmp;
            const_2(11 downto 0) <= instr(31 downto 20);        --imm to ALU
            const_2(31 downto 12) <= (others => instr(31));     --imm to ALU
            const_1(13 downto 0) <= pc_in (13 downto 0);        --pc in const_1
            const_1(31 downto 14) <= (others => '0');           --pc in const_1
            
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
                    op <= ALU_SLT;
                when F3_SLTU   =>
                    op <= ALU_SLTU;
                when F3_SLL  =>
                    op <= ALU_SLL;
                when F3_SRL =>
                    func7 <= instr(31 downto 25);
                    case func7 is
                        when F7_SRL =>
                            op <= ALU_SRL;
                        when F7_SRA =>
                            op <= ALU_SRA;
                        when others =>
                    end case;
        
            end case;
        -- end I-Type
 
        -- Load Instructions
        when OP_Load =>
            func3 <= instr(14 downto 12);
            sel_in <= instr(11 downto 7);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= (others => '0');
            op <= (others => '0');      --no ALU Operation needed
            --STOP, JMP, AUIPC, REG, LOAD, IMM, CALC, STORE, TAKE_JMP
            -- '0', '0',   '0', '0',  '1', '0',  '0',   '0',   '0'
            cmd_load <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store & cmd_take_jmp;
            const_2(11 downto 0) <= instr(31 downto 20);
            const_2(31 downto 0) <= (others => instr(31));
            const_1(13 downto 0) <= pc_in (13 downto 0);
            const_1(31 downto 14) <= (others => '0');
            
            case func3 is
                when F3_LB => 
                when F3_LH =>
                when F3_LW =>
                when F3_LBU =>
                when F3_LHU =>
                when others =>
            end case;
        
        --end I-Type
        ---------------------------------------------------------------------------------------------
        --Store instructions (S-Type)
        when OP_STORE =>
            func3 <= instr(14 downto 12);
            sel_in <= (others => '0');
            sel_out_a <= instr(24 downto 20);       --rs1 and rs2 swtiched for store commands
            sel_out_b <= instr(19 downto 15);       --rs1 and rs2 swtiched for store commands
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE, TAKE_JMP
            -- '0', '0',   '0', '0',  '0',   '0',  '0',   '1',   '0'
            cmd_store <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store & cmd_take_jmp;
            op <= (others => '0');                         --no ALU Operation needed
            const_1(4 downto 0) <= instr(11 downto 7);      --Only in Store instr: Immediate in const_1
            const_1(11 downto 5) <= instr(31 downto 25);    --Only in Store instr: Immediate in const_1
            const_1(31 downto 12) <= (others => '0');       --Only in Store instr: Immediate in const_1
            const_2(13 downto 0) <= pc_in (13 downto 0);    --Only in Store instr: PC in const_2
            const_2(31 downto 14) <= (others => '0');       --Only in Store instr: PC in const_2
            
            case func3 is
                when F3_SB  =>
                when F3_SH  => 
                when F3_SW  => 
                when others =>
             end case;
            
        -- end S-Type
        ---------------------------------------------------------------------------------------------
        --branch-type instructions (B-Type)
        when OP_BRANCH =>
            func3 <= instr(14 downto 12);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= instr(24 downto 20);
            sel_in <= (others => '0');
            op <= (others => '0');                         --no ALU Operation needed
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE, TAKE_JMP
            -- '0', '1',   '0', '0',  '0',   '0',  '1',   '0',   '1'
            cmd_jmp <= '1'; cmd_calc <= '1'; cmd_take_jmp <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store & cmd_take_jmp;
            const_2(3 downto 0) <= instr(11 downto 8);
            const_2(9 downto 4) <= instr(30 downto 25);
            const_2(10) <= instr(7);
            const_2(31 downto 11) <= (others => instr(31));
            const_1(13 downto 0) <= pc_in (13 downto 0);
            const_1(31 downto 14) <= (others => '0');
            
            case func3 is
                when F3_BEQ  => 
                when F3_BNE  => 
                when F3_BLT  => 
                when F3_BGE  => 
                when F3_BLTU => 
                when F3_BGEU =>
                when others =>
            end case;
            
        -- end B-Type
        ---------------------------------------------------------------------------------------------    
        --upper-immediate-type instructions (U-Type)
            --LUI instruction
        when OP_LUI =>
            sel_in <= instr(11 downto 7);
            sel_out_a <= (others => '0');
            sel_out_b <= (others => '0');
            op <= (others => '0');                                          --no ALU Operation needed
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE, TAKE_JMP
            -- '0', '0',   '0', '1',  '0',   '0',  '0',   '0',   '0'   
            cmd_reg <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store & cmd_take_jmp;
            const_2(31 downto 12) <= instr(31 downto 12);
            const_2(11 downto 0) <= (others => '0');
            const_1(13 downto 0) <= pc_in (13 downto 0);
            const_1(31 downto 14) <= (others => '0');
            --AUIPC instruction
        when OP_AUIPC =>
            sel_in <= instr(11 downto 7);
            sel_out_a <= (others => '0');
            sel_out_b <= (others => '0');
            op <= (others => '0');                                          --no ALU Operation needed
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE, TAKE_JMP
            -- '0', '0',   '1', '0',  '0',   '0',  '0',   '0',   '0'  
            cmd_auipc <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store & cmd_take_jmp;
            const_2(31 downto 12) <= instr(31 downto 12);       --immediate to ALU
            const_2(11 downto 0) <= (others => '0');            --immediate to ALU
            const_1(13 downto 0) <= pc_in (13 downto 0);        --pc to ALU
            const_1(31 downto 14) <= (others => '0');           --pc to ALU
        
        --jump-type instructions (J-Type)
            --JAL instruction
        when OP_JAL =>
            sel_in <= instr(11 downto 7);
            sel_out_a <= (others => '0');
            sel_out_b <= (others => '0');
            op <= (others => '0');                                        --no ALU Operation needed            
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE, TAKE_JMP
            -- '0', '1',   '0', '0',  '0',   '0',  '0',   '0',   '1'
            cmd_jmp <='1'; cmd_take_jmp<='1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store & cmd_take_jmp;
            const_2(0) <= '0';                                      --immediate to ALU
            const_2(10 downto 1)    <= instr(30 downto 21);         --immediate to ALU
            const_2(11)             <= instr(20);                   --immediate to ALU
            const_2(19 downto 12)   <= instr(19 downto 12);         --immediate to ALU
            const_2(31 downto 20)   <= (others => instr(31));       --immediate to ALU
            const_1(13 downto 0) <= pc_in (13 downto 0);      
            const_1(31 downto 14) <= (others => '0');
            
            --JALR instruction
        when OP_JALR =>
            sel_in <= instr(11 downto 7);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= (others => '0');            
            op <= (others => '0');
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE, TAKE_JMP
            -- '0', '1',   '0', '1',  '0',   '0',  '0',   '0',   '1'  
            cmd_jmp <='1'; cmd_take_jmp <='1'; cmd_reg <='1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store & cmd_take_jmp;
            const_2(11 downto 0) <= instr(31 downto 20);            --immediate to ALU
            const_2(31 downto 12) <= (others => instr(31));         --immediate to ALU
            const_1(13 downto 0) <= pc_in (13 downto 0);      
            const_1(31 downto 14) <= (others => '0');           
         
         -- end J-Type
         ---------------------------------------------------------------------------------------------
          -- Stop instruction
        when OP_STOP =>
            sel_in <= (others => '0');
            sel_out_a <= (others => '0');
            sel_out_b <= (others => '0');
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE, TAKE_JMP
            -- '1', '0',   '0', '0',  '0', '0',  '0',   '0',   '0'
            cmd_stop <='1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store & cmd_take_jmp;
            const_2 <= (others => '0');         --immediate to ALU
            
        when others =>
            sel_in <= (others => '0');
            sel_out_a <= (others => '0');
            sel_out_b <= (others => '0');
            ctrl <= (others => '0');
            const_2 <= (others => '0');
            const_1(13 downto 0) <= pc_in (13 downto 0);      
            const_1(31 downto 14) <= (others => '0');
    end case;
    wait;
end process;

end RTL;
