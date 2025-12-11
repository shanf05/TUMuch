-- created by severin hanf
library work; 
use work.defs_pack.all;
use work.instr_dec_pack.all;
use work.ctrl_fsm_pack.all;

entity ctrl_fsm is
    Port(        
        clk       : in  bit;                        -- clk
        rst       : in  bit;                        -- asynchronus rese
        
        ctrl      : in  CtrlType;                   -- from instruction decoder
        
        reg_en    : out bit;                        -- enables register    
        inc_en    : out bit;                        -- enables inc latch
        instr_en  : out bit;                        -- enables forwarding instruction in instruction decoder
        w_en      : out bit;                        -- enables write in memory        
        pc_en     : out bit;                        -- enables forwarding pc as address        
        
        bra_cond  : in  bit;                        -- from alu cmp unit -> 1 if condition is true
        sel_mux_1 : out bit;                        -- to datapath 
        sel_mux_2 : out bit;                        -- to datapath        
        sel_mux_4 : out bit;                        -- to datapath
        sel_mux_5 : out bit_vector (1 downto 0);    -- to mux_5
        sel_mux_6 : out bit;                        -- to mux_6
        sel_mux_7 : out bit;                        -- to mux_7
        
        active    : out bit                         -- system status
    );    
end ctrl_fsm;

architecture mealy of ctrl_fsm is
    --signal mapping from ctrl:
    signal cmd_stop     : bit := ctrl(0);  -- stop all execution -> needs reset
    signal cmd_jmp      : bit := ctrl(1);  -- fump instructions
    signal cmd_auipc    : bit := ctrl(2);  -- only used for AUPIC (pc needs to go to data_in)
    signal cmd_reg      : bit := ctrl(3);  -- only used for LUI
    signal cmd_load     : bit := ctrl(4);  -- every load instruction
    signal cmd_const    : bit := ctrl(5);  -- every instruction with immediate, that has to go to alu
    signal cmd_calc     : bit := ctrl(6);  -- every instruction that goes into alu
    signal cmd_store    : bit := ctrl(7);  -- store instructions
        
    --states:
    signal state, next_state : StateType := s_if;     
begin    
    
    state_changes : process(clk, rst)
    begin 
        if rst = '1' then
            state <= s_IF;          -- always start with instruction fetch after reset
        elsif clk = '1' and clk'event then
            state <= next_state;    -- otherwise update state   
        end if;    
    end process;    
    
    mixed_changes : process (state, cmd_calc, cmd_const, cmd_load, cmd_reg, cmd_auipc, cmd_jmp, cmd_stop, cmd_store)
    begin 
        -- set default values:        
        instr_en  <= '0';               -- default: not enabled
        pc_en     <= '0';               -- default: not enabled      
        inc_en    <= '0';               -- default: not enabled  
        reg_en    <= '0';               -- default: not enabled
        w_en      <= '0';               -- default: not enabled
        active    <= '1';               -- default: active
        sel_mux_1 <= sel_mux_1_rs_2;    -- default: use rs_2 as second input for alu     
        sel_mux_2 <= sel_mux_2_alu_res; -- default: use ralu res as register data input                
        sel_mux_4 <= sel_mux_4_rs_1;    -- default: use rs_1 as second operand    
        sel_mux_5 <= sel_mux_5_imm_4;   -- default: use + 4 as for pc incrementation    
        sel_mux_6 <= sel_mux_6_pc;      -- default: use pc as base for pc incrementation              
        sel_mux_7 <= sel_mux_7_pc;      -- default: use pc as address for mem     
        
        -- only change values that differ from the default: 
        case state is 
        when s_if =>
            next_state <= s_pfex;                                               -- always next state
            inc_en    <= '0';                                                   -- DO NOT update inc, because it holds the jump address calculated in the last cycle (either special or pc + 4)
            pc_en     <= '1';                                                   -- update pc from inc  
            sel_mux_7 <= sel_mux_7_pc;                                          -- when jumping, use updated pc as address for mem          
            instr_en <= '1';                                                    -- fetch instruction            
        when s_pfex =>            
            if cmd_stop = '1' then         
                next_state <= s_stop;                                           -- only checkable when fetching instruction
            elsif cmd_load = '1' then                                           
                next_state <= s_mem;                                            -- load instructions need one more cycle to write registers                
                sel_mux_5  <= sel_mux_5_addr_in;                                -- use reg(rs1) as first summand
                sel_mux_6  <= sel_mux_6_imm;                                    -- use the immediate as second summand
                sel_mux_7  <= sel_mux_7_inc_out;                                -- use the addition as memory address -> data has to be written to regs in the next cylce                                                                                
            elsif cmd_store = '1' then                
                next_state <= s_mem;                                            -- store instructions needs another cycle to update           
                w_en   <= '1';                                                  -- enable write for memory
                sel_mux_5  <= sel_mux_5_addr_in;                                -- use reg(rs1) as first summand
                sel_mux_6  <= sel_mux_6_imm;                                    -- use the immediate as second summand
                sel_mux_7  <= sel_mux_7_inc_out;                                -- use the addition as memory address -> data is being written next cycle   
            elsif cmd_auipc = '1' then 
                next_state <= s_if;                                             -- auipc can be done in one cycle 
                reg_en    <= '1';                                               -- enable writing the pc to registers
                sel_mux_1 <= sel_mux_1_const_1;                                 -- use imm as first summand
                sel_mux_4 <= sel_mux_4_const_2;                                 -- use pc as second summand
                sel_mux_2 <= sel_mux_2_alu_res;                                 -- use the alu result (addition) as write data for registers   
                -- update inc:
                inc_en     <= '1';           
                sel_mux_5  <= sel_mux_5_imm_4;
                sel_mux_6  <= sel_mux_6_pc;     
            elsif cmd_calc = '1' then                                           -- calculation instructions                                                                                         
                if cmd_jmp = '1' then                                           -- branch instructions                                
                    next_state <= s_cmp;                                        -- contitional branches need another cycle to check condition 
                    sel_mux_6 <= sel_mux_6_pc;                                  -- use pc as first summand
                    sel_mux_5 <= sel_mux_5_imm;                                 -- use imm as second summand  
                    inc_en    <= '1';                                           -- store the jump address in inc buffer -> when condition is true, inc value is used, otherwise normal pc + 4 
                elsif cmd_reg = '1' then                                        -- set instructions
                    next_state <= s_if;                                         -- return to instr fetch -> only need one cycle
                    reg_en <= bra_cond;                                         -- enable register writing only if condition is valid
                    sel_mux_4 <= sel_mux_4_rs_1;                                -- use rs1 as operand 1
                    -- update inc:
                    inc_en     <= '1';           
                    sel_mux_5  <= sel_mux_5_imm_4;
                    sel_mux_6  <= sel_mux_6_pc;
                else                                                            -- "normal" arithmetric instruction 
                    next_state <= s_if;                                         -- return after this cycle
                    reg_en <= '1';                                              -- enable writing the result to registers   
                    -- update inc:
                    inc_en     <= '1';           
                    sel_mux_5  <= sel_mux_5_imm_4;
                    sel_mux_6  <= sel_mux_6_pc;                 
                end if; 
                if cmd_const = '1' then sel_mux_1 <= sel_mux_1_const_1; end if; -- use immediate as second operand: the same for all instructions above                                                                                  
            elsif cmd_reg = '1' and cmd_jmp = '0' and cmd_calc = '0' then       -- this is only the LUI instruction
                next_state <= s_if;                                             -- lui can be done in one cycle 
                reg_en <= '1';                                                  -- enable writing the immediate to registers
                sel_mux_2 <= sel_mux_2_const_reg;                               -- use the immediate as write data for registers     
                --update inc:
                inc_en     <= '1';           
                sel_mux_5  <= sel_mux_5_imm_4;
                sel_mux_6  <= sel_mux_6_pc;  
            elsif cmd_jmp = '1' and cmd_calc = '0' then                         -- unconditional jumps        
                next_state <= s_if;                                             -- jumps can be done in one cycle (address is getting used in next one)  
                inc_en     <= '1';                                              -- enable buffering the jump address in inc -> pc is getting updated in instr_fetch                
                --calculate jump address:
                if cmd_reg = '0' then                                           -- JAL instruction
                    sel_mux_5 <= sel_mux_5_imm;                                 -- use imm as second summand
                    sel_mux_6 <= sel_mux_6_pc;                                  -- use pc as first summand
                else                                                            -- JALR instruction 
                    sel_mux_5 <= sel_mux_5_addr_in;                             -- use rs1 as second summand     
                    sel_mux_6 <= sel_mux_6_imm;                                 -- use imm as first summand                                                 
                end if;
                --calculate return address:             
                sel_mux_1 <= sel_mux_1_const_1;                                 -- use const_1 = 4 as second operand
                sel_mux_4 <= sel_mux_4_const_2;                                 -- use pc as first operadn
                sel_mux_2 <= sel_mux_2_alu_res;                                 -- use alu result (pc + 4) as write data for regs
                reg_en    <= '1';                                               -- enable registers to be written                 
            elsif cmd_stop = '1' then 
                next_state <= s_stop;                
            else 
                next_state <= s_if;                                             -- always restart with instr fetch when faulty input;
                assert false; 
            end if;  
        when s_mem =>    
            next_state <= s_if;                                                 -- finished, return to instruction fetching
            if cmd_load = '1' then 
                sel_mux_2 <= sel_mux_2_const_reg;                               -- use constant input from id as register write data
                reg_en    <= '1';                                               -- enable writing the register
            end if;                
            -- update inc:
            inc_en     <= '1';           
            sel_mux_5  <= sel_mux_5_imm_4;
            sel_mux_6  <= sel_mux_6_pc;
        when s_cmp =>                                                           -- this state is only after pfex of branch instructions
            next_state <= s_if;                                                 -- always return to instr fetch
            sel_mux_4 <= sel_mux_4_rs_1;                                        -- set first cmp reg to rs1
            sel_mux_1 <= sel_mux_1_rs_2;                                        -- set second cmp reg to rs2
            
            sel_mux_5 <= sel_mux_5_imm_4;                                       -- use +4 as first summand
            sel_mux_6 <= sel_mux_6_pc;                                          -- use pc as second summand
            inc_en    <= not bra_cond;                                          -- if condition is false, update inc with pc + 4 (else use jump address calculated in pfex)                         
            
        when s_stop =>
            next_state <= s_stop;                                               -- fallback to itsself
            active <= '0';                                                      -- not active anymore -> needs reset
        when others =>
            next_state <= s_if;                                                 -- always restart with instr fetch if in phantom state 
            -- update inc:
            inc_en     <= '1';           
            sel_mux_5  <= sel_mux_5_imm_4;
            sel_mux_6  <= sel_mux_6_pc;
            assert false; 
        end case;
    end process;
end mealy;