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
    signal cmd_lui      : bit := ctrl(5);  -- only used for LUI
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
    
    mixed_changes : process (state, cmd_calc, cmd_const, cmd_load, cmd_lui, cmd_auipc, cmd_jmp, cmd_stop, cmd_take_jmp, cmd_store)
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
        sel_mux_5 <= sel_mux_5_reg;     -- default: use the value provided from register
        
        -- only change values that differ from the default: 
        case state is 
        when s_if =>
            next_state <= s_pfex;                                               -- always next state
            if cmd_take_jmp = '1' then sel_mux_4 <= sel_mux_4_alu_res; end if;  -- when jumping, use address calculated by alu
            instr_en <= '1';                                                    -- fetch instruction
            pc_en    <= '1';                                                    -- @ the current programm counter
        when s_pfex =>
            if    cmd_stop = '1' then         
                next_state <= s_stop;   
            elsif cmd_load = '1' then   
                next_state <= s_mem;                
            elsif cmd_calc = '1' then 
                if cmd_const = '1' then sel_mux_2 <= sel_mux_2_const_2; end if; -- use immediate as second operand (otherwise rs_2 is default)
                reg_en <= '1';                                                  -- enable writing the result to registers
                                                                                -- the other defaults are already right for non immediate calculations     
            elsif cmd_lui = '1' then 
                reg_en <= '1';                                                  -- enable writing the immediate to registers
                sel_mux_3 <= sel_mux_3_const_2;                                 -- use the immediate as write data for registers
            elsif cmd_auipc = '1' then 
                reg_en <= '1';                                                  -- enable writing the pc to registers
                pc_en  <= '1';                                                  -- use pc as first summand
                sel_mux_1 <= sel_mux_1_const_1;                                 -- use pc as first summand
                sel_mux_2 <= sel_mux_2_const_2;                                 -- use imm as second summand
                sel_mux_3 <= sel_mux_3_alu_res;                                 -- use the alu result (addition) as write data for registers          
            elsif cmd_stop = '1' then 
                next_state <= s_stop;
                active <= '0';             
            else 
                next_state <= s_if;                                            -- always restart with instr fetch when faulty input;
                assert false; 
            end if; 
        when s_mem =>         
            -- the same for load and store:
            sel_mux_1 <= sel_mux_1_rs_1;                                        -- use reg(rs1) as first summand for mem address
            sel_mux_2 <= sel_mux_2_const_2;                                     -- use sign_extended(imm) as second summand for mem address
            sel_mux_4 <= sel_mux_4_alu_res;                                     -- use the calculated result as mem address
                       
            if cmd_load = '1' then 
                next_state <= s_rd;                                             -- loading memory values into register requires one extra cycle                        
            elsif cmd_store = '1' then 
                next_state <= s_if;                                             -- fallback to istr fetch
                w_en   <= '1';                                                  -- enable write for memory
                seL_mux_1 <= sel_mux_1_const_1;                                 -- use imm as first summand
                sel_mux_2 <= sel_mux_2_rs_2;                                    -- use rs_2 as second summand (actually this is rs_1, it is getting swapped in instr dec, so no mux after reg_file is needed)
                sel_mux_3 <= sel_mux_3_alu_res;                                 -- use the alu result as write data for memory
            else 
                next_state <= s_if;                                             -- always restart with instr fetch when faulty input;
                assert false; 
            end if;
        when s_rd =>
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