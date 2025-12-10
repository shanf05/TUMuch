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
    --signal  to FSM: ctrl (cmd_stop, cmd_jmp, cmd_auipc, cmd_reg, cmd_load, cmd_const, cmd_calc, cmd_store)
    --signal to MUX_2: const_reg (only used for load commands)
    --signal to MUX_6: imm

entity ctrl_instr_dec is
    Port(
        instr     : in  BusDataType;
        pc_in     : in  bit_vector (AddrSize-1 downto 0); 
        data_in   : in  BusDataType;                      -- Only for LOAD: get Byte/Halfword/Word through wire skipping ctrl_instr

        sel_in    : out bit_vector(4 downto 0);           -- rd
        sel_out_a : out bit_vector(4 downto 0);           -- rs1
        sel_out_b : out bit_vector(4 downto 0);           -- rs2
          
        ctrl      : out CtrlType;
        op        : out bit_vector(3 downto 0);           -- Operation signal to ALU
        const_1   : out BusDataType;                      -- Signal to MUX_1
        const_2   : out BusDataType;                      -- Signal to MUX_2
        const_reg : out BusDataType;                      -- Signal to Register (LOAD: Address of memory) 
        imm       : out BusDataType;                      -- Hardwired Signal Imm to MUX_5 and MUX_6
        acc_size  : out bit_vector(1 downto 0)            -- for store instructions
        );
end ctrl_instr_dec;

architecture RTL of ctrl_instr_dec is 
signal op_code : bit_vector(6 downto 0) := (others => '0');         --prevent Latch
signal func3 : bit_vector(2 downto 0) := (others => '0');           --prevent Latch
signal func7 : bit_vector(6 downto 0) := (others => '0');           --prevent Latch
signal cmd_store, cmd_calc, cmd_const, cmd_load, cmd_reg, cmd_auipc, cmd_jmp, cmd_stop : bit;
begin
    op_code <= instr(6 downto 0);
    
    process
    begin
    -- default assignment of ctrl signals
    cmd_store <='0'; cmd_calc <='0'; cmd_const <='0'; cmd_load <='0';
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
            acc_size  <= acc_size_word;
            --ctrl table
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE,
            -- '0', '0',   '0', '0',  '0',   '0',  '1',   '0',
            cmd_calc <= '1';
            const_1    <= (others => '0');              --prevent latches
            const_2    <= (others => '0');              --prevent latches
            const_reg  <= data_in;                      --prevent latches
            imm        <= (others => '0');              --prevent latches
            
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
                    cmd_reg <='1';
                    op <= ALU_SLT;         
                when F3_SLTU =>
                    cmd_reg <='1';
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
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store;  --assign ctrl signal as last step 
                                                                                                             --(SLTI and SLTIU -> cmd_reg)
        -- end R-Type        
        ---------------------------------------------------------------------------------------------    
        -- I-Type Instructions
        when OP_IMM =>
            func3 <= instr(14 downto 12);
            sel_in <= instr(11 downto 7);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= (others => '0');
            acc_size  <= acc_size_word;
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE,
            -- '0', '0',   '0', '0',  '0',   '1',  '1',   '0',
            cmd_const <= '1'; cmd_calc <= '1';
            const_1(11 downto 0)  <= instr(31 downto 20);           -- I-Type: imm to MUX_1
            const_1(31 downto 12) <= (others => instr(31));         -- I-Type: imm to MUX_1
            const_2(31 downto 0)  <= (others => '0');               -- I-Type: const_2 unused
            const_reg(11 downto 0)  <= instr(31 downto 20);         -- Hardwired Imm to MUX_2
            const_reg(31 downto 12) <= (others => instr(31));       -- Hardwired Imm to MUX_2
            imm(11 downto 0)      <= instr(31 downto 20);           -- Hardwired imm to MUX_5 and MUX_6
            imm(31 downto 12)     <= (others => instr(31));         -- Hardwired imm to MUX_5 and MUX_6
            
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
                    cmd_reg <= '1';         --SLTI: Set cmd_reg for FSM
                    op      <= ALU_SLT;     
                when F3_SLTU   =>
                    cmd_reg <= '1';         --SLTIU: Set cmd_reg for FSM
                    op      <= ALU_SLTU;
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
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store;     --assign ctrl at last step
                                                                                                                --(SLTI and SLTIU -> cmd_reg)
        -- end I-Type
        ---------------------------------------------------------------------------------------------
        -- Load Instructions
        when OP_Load =>
            func3 <= instr(14 downto 12);
            sel_in <= instr(11 downto 7);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= (others => '0');
            acc_size  <= acc_size_word;
            op <= (others => '0');      --no ALU Operation needed
            --STOP, JMP, AUIPC, REG, LOAD, IMM, CALC, STORE,
            -- '0', '0',   '0', '0',  '1', '0',  '0',   '0',
            cmd_load <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store;
            
            const_1(31 downto 0)    <= (others => '0');           --LOAD: const_1 unused
            const_2(31 downto 0)    <= (others => '0');           --LOAD: const_2 unused
            const_reg               <= data_in;
            imm(11 downto 0)        <= instr(31 downto 20);       --LOAD: imm to MUX_6
            imm(31 downto 12)       <= (others => instr(31));     --Sign extension of imm
            
            case func3 is
                when F3_LW =>
                    const_reg <= data_in;
                when F3_LH => 
                    const_reg(15 downto 0)  <= data_in(15 downto 0);
                    const_reg(31 downto 16) <= (others => data_in(15));
                when F3_LHU =>
                    const_reg(15 downto 0)  <= data_in(15 downto 0);
                    const_reg(31 downto 16) <= (others => '0');
                when F3_LB =>
                    const_reg(7 downto 0)   <= data_in(7 downto 0);
                    const_reg(31 downto 8)  <= (others => data_in(7));
                when F3_LBU =>
                    const_reg(7 downto 0)   <= data_in(7 downto 0);
                    const_reg(31 downto 8)  <= (others => '0');
                when others =>
            end case;
        
        --end I-Type
        ---------------------------------------------------------------------------------------------
        --Store instructions (S-Type)
        when OP_STORE =>
            func3 <= instr(14 downto 12);
            sel_in <= (others => '0');
            sel_out_a <= instr(19 downto 15);       
            sel_out_b <= instr(24 downto 20);      
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE,
            -- '0', '0',   '0', '0',  '0',   '0',  '0',   '1',
            cmd_store <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store;
            
            op <= (others => '0');                            --no ALU Operation needed
            const_1(31 downto 0)  <= (others => '0');         --STORE: const_1 unused
            const_2(31 downto 0)  <= (others => '0');         --STORE: const_2 unused
            const_reg             <= data_in;                 --STORE: const_reg unused
            imm(4 downto 0)       <= instr(11 downto 7);      --STORE: Imm to MUX_6
            imm(11 downto 5)      <= instr(31 downto 25);     --STORE: Imm to MUX_6
            imm(31 downto 12)     <= (others => instr(31));   --Sign extend immediate
            
            case func3 is
                when F3_SB  =>
                    acc_size <= acc_size_byte;
                when F3_SH  =>  
                    acc_size <= acc_size_half_word;
                when F3_SW  => 
                    acc_size <= acc_size_word;
                when others =>
                    acc_size <= acc_size_word;  --prevent latch
             end case;
            
        -- end S-Type
        ---------------------------------------------------------------------------------------------
        --branch-type instructions (B-Type)
        when OP_BRANCH =>  
            func3 <= instr(14 downto 12);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= instr(24 downto 20);
            acc_size  <= acc_size_word;
            sel_in <= (others => '0');
            op <= (others => '0');                         --no ALU Operation needed
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE,
            -- '0', '1',   '0', '0',  '0',   '0',  '1',   '0',
             cmd_calc <= '1';                              --BRANCH: cmd_jmp only ticked if condition is true
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store;
            const_1(31 downto 0) <= (others => '0');                --BRANCH: const_1 unused
            const_2(31 downto 0) <= (others => '0');                --BRANCH: const_2 unused
            const_reg            <= data_in;
            imm(0)               <= '0';
            imm(4 downto 1)      <= instr(11 downto 8);             --BRANCH: imm to MUX_5       
            imm(10 downto 5)     <= instr(30 downto 25);
            imm(11)              <= instr(7);
            imm(31 downto 11)    <= (others => instr(31));           

            
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
            acc_size  <= acc_size_word;
            op <= (others => '0');                                  --no ALU Operation needed
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE,
            -- '0', '0',   '0', '1',  '0',   '0',  '0',   '0',   
            cmd_reg <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store;

            const_1(31 downto 12) <= instr(31 downto 12);           --LUI: Immediate to MUX_1 (ALU)
            const_1(11 downto 0)  <= (others => '0');               --LUI: immediate of U-Format => imm & X"000"
            const_2(31 downto 0)  <= (others => '0');               --LUI: const_2 is zero -> Only Upperimmediate stored in Register
            const_reg             <= data_in;                       --Hardwired instr to const_reg
            imm(31 downto 12) <= instr(31 downto 12);               --NOT USED in this case
            imm(11 downto 0)  <= (others => '0');                   --NOT USED in this case

            --AUIPC instruction
        when OP_AUIPC =>
            sel_in <= instr(11 downto 7);
            sel_out_a <= (others => '0');
            sel_out_b <= (others => '0');
            acc_size  <= acc_size_word;
            op <= (others => '0');                                   --no ALU Operation needed
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE,
            -- '0', '0',   '1', '0',  '0',   '0',  '0',   '0',
            cmd_auipc <= '1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store;

            const_1(31 downto 12) <= instr(31 downto 12);       --AUIPC: immediate to MUX_1 (ALU)
            const_1(11 downto 0)  <= (others => '0');           --AUIPC: immediate of U-Format => imm & X"000"
            const_2(13 downto 0)  <= pc_in (13 downto 0);       --AUIPC: PC to MUX_4 (ALU)
            const_2(31 downto 14) <= (others => '0');           --AUIPC: extend pc with 0
            const_reg             <= data_in;
            imm(31 downto 12)     <= instr(31 downto 12);           
            imm(11 downto 0)      <= (others => '0');
        
        --jump-type instructions (J-Type)
            --JAL instruction
        when OP_JAL =>
            sel_in <= instr(11 downto 7);
            sel_out_a <= (others => '0');
            sel_out_b <= (others => '0');
            acc_size  <= acc_size_word;
            op <= (others => '0');                                        --no ALU Operation needed            
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE,
            -- '0', '1',   '0', '0',  '0',   '0',  '0',   '0',
            cmd_jmp <='1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store;
            
            const_1               <= X"00000004";               --JAL: const_1 hardwired to 4                        
            const_2(13 downto 0)  <= pc_in(13 downto 0);        --JAL: const_2 contains pc
            const_2(31 downto 14) <= (others => '0');           --extend pc with zeroes
            const_reg             <= data_in;
            imm(0)                <= '0';                       --JAL: imm to MUX_6
            imm(10 downto 1)      <= Instr(30 downto 21);       --JAL: imm to MUX_6
            imm(11)               <= Instr(20);                 --JAL: imm to MUX_6
            imm(19 downto 12)     <= Instr(19 downto 12);       --JAL: imm to MUX_6
            imm(31 downto 20)     <= (others => Instr(31));     --JAL: imm to MUX_6
            
            --JALR instruction
        when OP_JALR =>
            sel_in <= instr(11 downto 7);
            sel_out_a <= instr(19 downto 15);
            sel_out_b <= (others => '0');     
            acc_size  <= acc_size_word;       
            op <= (others => '0');
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE,
            -- '0', '1',   '0', '1',  '0',   '0',  '0',   '0',
            cmd_jmp <='1'; cmd_reg <='1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store;
            
            const_1               <= X"00000004";               --JALR: const_1 hardwired to 4                        
            const_2(13 downto 0)  <= pc_in(13 downto 0);        --JALR: const_2 contains pc
            const_2(31 downto 14) <= (others => '0');           --extend pc with zeroes
            const_reg             <= data_in;
            imm (11 downto 0)     <= instr(31 downto 20);
            imm (31 downto 12)    <= (others => instr(31));

         -- end J-Type
         ---------------------------------------------------------------------------------------------
          -- Stop instruction
        when OP_STOP =>
            sel_in    <= (others => '0');
            sel_out_a <= (others => '0');
            sel_out_b <= (others => '0');
            acc_size  <= acc_size_word;
            --STOP, JMP, AUIPC, REG, LOAD, CONST, CALC, STORE,
            -- '1', '0',   '0', '0',  '0',   '0',  '0',   '0',
            cmd_stop <='1';
            ctrl <= cmd_stop & cmd_jmp & cmd_auipc & cmd_reg & cmd_load & cmd_const & cmd_calc & cmd_store;
            const_1     <= (others => '0');         --prevent latch
            const_2     <= (others => '0');         --prevent latch
            const_reg   <= data_in;
            imm         <= (others => '0');         --prevent latch
        -- end Stop instruction
        ---------------------------------------------------------------------------------------------
        -- case: invalid instr   
        when others =>
            sel_in                <= (others => '0');
            sel_out_a             <= (others => '0');
            sel_out_b             <= (others => '0');
            acc_size  <= acc_size_word;
            ctrl                  <= (others => '0');
            const_1(13 downto 0)  <= pc_in (13 downto 0);      
            const_1(31 downto 14) <= (others => '0');
            const_2               <= (others => '0');
            const_reg             <= data_in;
            imm                   <= (others => '0');
         -- end invalid instr
        ---------------------------------------------------------------------------------------------
    end case;
    wait;
end process;

end RTL;
