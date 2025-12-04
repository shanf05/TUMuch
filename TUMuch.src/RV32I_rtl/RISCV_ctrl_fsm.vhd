-- created by severin hanf
library work; 
use work.defs_pack.all;
use work.instr_dec_pack.all;

entity ctrl_fsm is
    Port(   
        clk       : in bit; 
        rst       : in bit; 
         
        -- controll signals from instruction decoder: 
        ctrl      : in  bit_vector(9 downto 0); 
        dev_rdy   : in  bit;
       
       -- outputs:  
        fc_sel    : out bit; 
        reg_en    : out bit; 
        d_in_mux  : out integer range 0 to 1; 
        d_out_mux : out integer range 0 to 1;
        io_type   : out bit; 
        io_en     : out bit;
        w_en      : out bit;
        a_out_mux : out integer range 0 to 3; 
        instr_en  : out bit;
        pc_mux    : out integer range 0 to 1;
        pc_en     : out bit; 
        addr_en   : out bit; 
        active    : out bit
    );
end ctrl_fsm;

architecture mealy of ctrl_fsm is
    --signal mapping from ctrl
    signal take_jmp  : bit := ctrl(0);
    signal store     : bit := ctrl(1);
    signal cmd_calc  : bit := ctrl(2);
    signal cmd_const : bit := ctrl(3);
    signal cmd_dir   : bit := ctrl(4);
    signal cmd_reg   : bit := ctrl(5);
    signal cmd_io    : bit := ctrl(6);
    signal cmd_pc    : bit := ctrl(7);
    signal cmd_jmp   : bit := ctrl(8);
    signal cmd_stop  : bit := ctrl(9);
    
    --states ? :
    type state_type is (s_if, s_pfex, s_stop, s_io, s_mem);
    signal state : state_type := s_stop;     
begin    
    
    next_state : process(clk, rst)
    begin 
        if rst = '0' then
            state <= s_IF;
        elsif clk = '1' and clk'event then
            case state is
            when s_if => 
                state <= s_pfex;
            when s_pfex =>
                if cmd_io = '1' then 
                    state <= s_io;
                elsif cmd_dir = '1' then 
                    state <= s_mem;
                elsif cmd_stop = '1' then
                    state <= s_stop;
                else 
                    state <= s_if;
                end if;
            when s_IO =>
                if dev_rdy = '1' then 
                    state <= s_if;
                else 
                    state <= s_io;
                end if;
            when s_mem => 
                state <= s_if;
            when s_stop => 
                state <= s_stop;
            end case;
        end if;    
    end process;
    
    
    output_gen : process (state, cmd_calc, cmd_const, cmd_dir, cmd_reg, cmd_io, cmd_pc, cmd_jmp, cmd_stop, take_jmp, store, dev_rdy)
    begin 
        a_out_mux <= 0; 
        instr_en  <= '0'; 
        addr_en   <= '0'; 
        pc_en     <= '0'; 
        pc_mux    <= 0; 
        reg_en    <= '0'; 
        d_in_mux  <= 0; 
        w_en      <= '0'; 
        io_type   <= '0'; 
        io_en     <= '0'; 
        active    <= '1'; 
        fc_sel    <= not cmd_calc; 
        --d_out_mux <= 0 when cmd_pc = '0' else 1;
        if cmd_pc = '0' then
            d_out_mux <= 0;
        else 
            d_out_mux <= 1;  
        end if;
        
        case state is 
        when s_if =>
            if take_jmp = '1' then 
                a_out_mux <= 1; 
            end if; 
            instr_en <= '1'; 
            pc_en    <= '1';
        when s_pfex =>
            if cmd_reg = '1' then 
                a_out_mux <= 2; 
            end if; 
            if cmd_dir = '1' or cmd_jmp = '1' then
                addr_en <= '1';
            end if;      
            if cmd_const = '1' or cmd_dir = '1' or (cmd_pc = '1' and store = '1' ) or cmd_jmp = '1' then            
                pc_en <= '1';
            end if;
            if cmd_pc = '1' then
                pc_mux <= 1; 
            end if;
            if cmd_calc = '1' or cmd_const = '1' or ((cmd_reg = '1' or cmd_pc = '1') and store = '0') then
                reg_en <= '1';
            end if;
            if cmd_reg = '1' and store = '1' then 
                w_en <= '1'; 
            end if;
            if cmd_io = '1' and store = '1' then 
                io_type <= '1'; 
            end if;        
        when s_io =>
            if (store = '0' and dev_rdy = '1') then
                reg_en <= '1';
            end if;
            d_in_mux <= 1;
            if store = '1' then 
                io_type <= '1'; 
            end if;
            if dev_rdy = '1' then 
                io_en <= '1'; 
            end if;
        when s_mem =>
            a_out_mux <= 1;
            if store = '0' then 
                reg_en <= '1';
            else 
                w_en <= '1';
            end if;
        when s_stop =>
            active <= '0'; 
        end case;
    end process;
end mealy;