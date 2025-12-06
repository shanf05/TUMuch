-- created by severin hanf
library work; 
use work.defs_pack.all;
use work.instr_dec_pack.all;
use work.ctrl_fsm_pack.all;

entity ctrl_fsm is
    Port(        
        clk       : in  bit;                        -- clk
        rst       : in  bit;                        -- asynchronus rese
        ctrl      : in  bit_vector(8 downto 0);     -- controll signals from instruction decoder
        reg_en    : out bit;                        -- enables register    
        w_en      : out bit;                        -- enables write in memory  
        instr_en  : out bit;                        -- enables forwarding instruction in instruction decoder
        pc_en     : out bit;                        -- enables forwarding pc as address
        addr_en   : out bit;                        -- enables forwarding data_in as address 
        active    : out bit;                        -- system status
        a_out_mux : out bit_vector (1 downto 0);    -- selects which address u want to send to memory/pc (from register / data_in / pc)
        d_out_mux : out bit;                        -- selects which data u want to send to alu
        pc_mux    : out bit;                        -- selects if u want to use +4 incremented pc or a pc from data_in  
        fc_sel    : out bit                         -- selects if u want to use data_in or alu_res for register input
    );    
end ctrl_fsm;

architecture mealy of ctrl_fsm is
    --signal mapping from ctrl:
    signal cmd_take_jmp : bit := ctrl(0);  -- after jump instructions
    signal cmd_store    : bit := ctrl(1);  -- store instructions
    signal cmd_calc     : bit := ctrl(2);  -- every instruction that goes into alu
    signal cmd_const    : bit := ctrl(3);  -- every instruction with immediate, that has to go to alu
    signal cmd_load     : bit := ctrl(4);  -- every load instruction
    signal cmd_reg      : bit := ctrl(5);  -- every instruction that uses regs
    signal cmd_pc       : bit := ctrl(6);  -- only used for AUPIC (pc needs to go to data_in)
    signal cmd_jmp      : bit := ctrl(7);  -- fump instructions
    signal cmd_stop     : bit := ctrl(8);  -- stor execution    
    
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
    
    mixed_changes : process (state, cmd_calc, cmd_const, cmd_load, cmd_reg, cmd_pc, cmd_jmp, cmd_stop, cmd_take_jmp, cmd_store)
    begin 
        -- set default values:        
        instr_en  <= '0';       -- default: not enabled
        addr_en   <= '0';       -- default: not enabled
        pc_en     <= '0';       -- default: not enabled        
        reg_en    <= '0';       -- default: not enabled
        w_en      <= '0';       -- default: not enabled
        active    <= '1';       -- default: active
        pc_mux    <= '0';       -- default: use +4 incremented addr
        a_out_mux <= "00";      -- default: use pc !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! anpassen !
        d_out_mux <= cmd_pc;    -- default: use pc for data_out when AUIPC instr
        
        -- only change values that differ from the default: 
        case state is 
        when s_if =>
            next_state <= s_pfex;                                   -- always next state
            if cmd_take_jmp = '1' then a_out_mux <= "01"; end if;   -- when jumping, use address calculated by alu
            instr_en <= '1';                                        -- fetch instruction
            pc_en    <= '1';                                        -- @ the current programm counter
        when s_pfex =>
            if      cmd_load = '1' or cmd_store = '1' then next_state <= s_mem;        
            elsif   cmd_stop = '1' then next_state <= s_stop; 
            else    next_state <= s_if; 
            end if;            
            if cmd_reg = '1' then a_out_mux <= "10"; end if;        -- ?
            addr_en <= cmd_load or cmd_jmp; 
            pc_en   <= cmd_const or cmd_load or cmd_pc or cmd_jmp; 
            pc_mux  <= cmd_pc; 
            reg_en  <= cmd_calc or cmd_const or ((cmd_reg and cmd_pc) and cmd_store); 
            w_en    <= cmd_reg and cmd_store;            
        when s_mem =>            
            --if      cmd_load = '1' then next_state <= s_rd; 
            --else    next_state <= s_if;
            --end if; 
                         
            --a_out_mux <= 1;
            --if store = '0' then 
            --    reg_en <= '1';
            --else 
            --    w_en <= '1';
            --end if;
            null;
        when s_rd =>
            next_state <= s_if; 
        when s_stop =>
            next_state <= s_stop;
            active <= '0'; 
        end case;
    end process;
end mealy;