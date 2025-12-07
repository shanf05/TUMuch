-- created by severin hanf
library work; 
use work.defs_pack.all;
use work.instr_dec_pack.all;
use work.ctrl_fsm_pack.all;

entity ctrl_fsm is
    Port(        
        clk       : in  bit;                        -- clk
        rst       : in  bit;                        -- asynchronus rese
        
        ctrl      : in  bit_vector(8 downto 0);     -- from instruction decoder
        
        reg_en    : out bit;                        -- enables register    
        instr_en  : out bit;                        -- enables forwarding instruction in instruction decoder
        w_en      : out bit;                        -- enables write in memory        
        pc_en     : out bit;                        -- enables forwarding pc as address        
        
        sel_mux_1 : out bit;                        -- to datapath 
        sel_mux_2 : out bit;                        -- to datapath 
        sel_mux_3 : out bit;                        -- to datapath 
        sel_mux_4 : out bit;                        -- to mux_4
        sel_mux_5 : out bit;                        -- to datapath
        
        active    : out bit                        -- system status
    );    
end ctrl_fsm;

architecture mealy of ctrl_fsm is
    --signal mapping from ctrl:
    signal cmd_take_jmp : bit := ctrl(0);  -- after jump instructions
    signal cmd_store    : bit := ctrl(1);  -- store instructions
    signal cmd_calc     : bit := ctrl(2);  -- every instruction that goes into alu
    signal cmd_const    : bit := ctrl(3);  -- every instruction with immediate, that has to go to alu
    signal cmd_load     : bit := ctrl(4);  -- every load instruction
    signal cmd_reg      : bit := ctrl(5);  -- only used for LUI
    signal cmd_auipc    : bit := ctrl(6);  -- only used for AUPIC (pc needs to go to data_in)
    signal cmd_jmp      : bit := ctrl(7);  -- fump instructions
    signal cmd_stop     : bit := ctrl(8);  -- stop all execution -> needs reset
    
    --states:
    signal state, next_state : StateType := s_stop;     
begin    
    
    state_changes : process(clk, rst)
    begin 
        if rst = '0' then
            state <= s_IF;          -- always start with instruction fetch after reset
        elsif clk = '1' and clk'event then
            state <= next_state;    -- otherwise update state   
        end if;    
    end process;    
    
    mixed_changes : process (state, cmd_calc, cmd_const, cmd_load, cmd_reg, cmd_auipc, cmd_jmp, cmd_stop, cmd_take_jmp, cmd_store)
    begin 
        -- set default values:        
        instr_en  <= '0';               -- default: not enabled
        pc_en     <= '0';               -- default: not enabled        
        reg_en    <= '0';               -- default: not enabled
        w_en      <= '0';               -- default: not enabled
        active    <= '1';               -- default: active
        sel_mux_1 <= sel_mux_1_rs_1;    -- default: use rs_1 as second input for alu     
        sel_mux_2 <= sel_mux_2_rs_2;    -- default: use rs_2 as second input for alu                
        sel_mux_3 <= sel_mux_3_alu_res; -- default: use alu's result for regs            
        sel_mux_4 <= sel_mux_4_pc;      -- default: use the pc as address      
        
        -- only change values that differ from the default: 
        case state is 
        when s_if =>
            next_state <= s_pfex;                                               -- always next state
            if cmd_take_jmp = '1' then sel_mux_4 <= sel_mux_4_alu_res; end if;  -- when branching, use address calculated by alu (only if condition was fullfilled)
            instr_en <= '1';                                                    -- fetch instruction
            pc_en    <= '1';                                                    -- update the programm counter
        when s_pfex =>
            if cmd_stop = '1' then         
                next_state <= s_stop;                                           -- only checkable when fetching instruction
            elsif cmd_load = '1' then                                           -- load instructions need three cycles (one extra to read memory, one extra to write regs)
                next_state <= s_rd;                                             -- load instructions need one more cycle to use the retrieved data from memory
                sel_mux_1  <= sel_mux_1_rs_1;                                   -- use rs1 as first summand
                sel_mux_2  <= sel_mux_2_const_2;                                -- use immediate (offset) as second summand
                sel_mux_4  <= sel_mux_4_alu_res;                                -- use alu result (addition) as address for memory
                                                                                -- in the next cycle/state the received data from memory is loaded into registers
            elsif cmd_store = '1' then                
                next_state <= s_mem;                                            -- store instructions can be done in two cycles (one more to write synchronous memory)               
                w_en   <= '1';                                                  -- enable write for memory
                sel_mux_1 <= sel_mux_1_const_1;                                 -- use imm as first summand
                sel_mux_2 <= sel_mux_2_rs_2;                                    -- use rs_2 as second summand (actually this is rs_1, it is getting swapped in instr dec, so no mux after reg_file is needed)
                sel_mux_3 <= sel_mux_3_alu_res;                                 -- use the alu result as write data for memory                                  
            elsif cmd_calc = '1' then 
                next_state <= s_if;                                             -- calculations can be done in one cycle                    
                if cmd_jmp = '1' then                                           -- contitional branches 
                    sel_mux_1 <= sel_mux_1_const_1;                             -- use pc as first summand
                    sel_mux_2 <= sel_mux_2_const_2;                             -- use imm as second summand  
                                                                                -- if condition is true, in the next cycle the right address is taken 
                end if; 
                if cmd_const = '1' then sel_mux_2 <= sel_mux_2_const_2; end if; -- use immediate as second operand (otherwise rs_2 is default)
                reg_en <= '1';                                                  -- enable writing the result to registers
                                                                                -- the other defaults are already right for non immediate calculations     
            elsif cmd_reg = '1' and cmd_jmp = '0' then                          -- this is only the LUI instruction
                next_state <= s_if;                                             -- lui can be done in one cycle 
                reg_en <= '1';                                                  -- enable writing the immediate to registers
                sel_mux_3 <= sel_mux_3_const_2;                                 -- use the immediate as write data for registers
            elsif cmd_auipc = '1' then 
                next_state <= s_if;                                             -- auipc can be done in one cycle 
                reg_en    <= '1';                                               -- enable writing the pc to registers
              --pc_en     <= '1';                                               -- update pc
                sel_mux_1 <= sel_mux_1_const_1;                                 -- use pc as first summand
                sel_mux_2 <= sel_mux_2_const_2;                                 -- use imm as second summand
                sel_mux_3 <= sel_mux_3_alu_res;                                 -- use the alu result (addition) as write data for registers       
            elsif cmd_jmp = '1' and cmd_calc = '0' then                         -- unconditional jumps        
                next_state <= s_if;                                             -- jumps can be done in one cycle (address is getting used in next one)           
                pc_en     <= '1';                                               -- update pc, because return address has to be stored   !!!!!!!!!!!!!!!!!!!!!!!!!! problem !!
                if cmd_reg = '0' then                                          -- JAL instruction
                    sel_mux_1 <= sel_mux_1_const_1;                             -- use pc as first summand
                else                                                            -- JALR instruction 
                    sel_mux_1 <= sel_mux_1_rs_1;                                -- use rs1 as first summand
                end if;
                sel_mux_2 <= sel_mux_2_const_2;                                 -- use imm as second summand  
                sel_mux_3 <= sel_mux_3_const_2;                                 -- use pc + 4 as data input for register write !!!!!!!!!!!!!!!!!!!!!!!! this is a problem !!
                                                                                -- unconditional jump: in the next cycle the address coming from alu is taken
                reg_en    <= '1';                                               -- enable registers to be written                 
            elsif cmd_stop = '1' then 
                next_state <= s_stop;
                active <= '0';
            else 
                next_state <= s_if;                                             -- always restart with instr fetch when faulty input;
                assert false; 
            end if;  
        when s_mem =>                                                           -- second cycle of memory instructions
            if cmd_load = '1' then
                next_state <= s_rd;                                             -- one more cycle to write regs                                
            else 
                next_state <= s_if;                                             -- finished, return to instruction fetching
            end if;
        when s_rd =>                                                            -- third cycle of load instructions
            next_state <= s_if;                                                 -- always restart after this state
            reg_en     <= '1';                                                  -- enable registers for writing
            instr_en   <= '1';                                                  -- get the data from the memory loaded in instruction decoding for extension
            sel_mux_3  <= sel_mux_3_const_2;                                    -- use the memory input fetched in the last state to write register
        when s_stop =>
            next_state <= s_stop;                                               -- fallback to itsself
            active <= '0';                                                      -- not active anymore -> needs reset
        when others =>
            next_state <= s_if;                                                 -- always restart with instr fetch if in phantom state 
            assert false; 
        end case;
    end process;
end mealy;