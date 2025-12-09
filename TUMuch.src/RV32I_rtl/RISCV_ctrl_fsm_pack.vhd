-- erstellt von Severin Hanf
package ctrl_fsm_pack is 
    subtype  StateType is bit_vector (4 downto 0); 
    constant s_if   : StateType := "10000";         -- instruction fetch 
    constant s_pfex : StateType := "01000";         -- parameter fetch (decode) and execute
    constant s_mem  : StateTYpe := "00100";         -- memory write
    constant s_rd   : StateType := "00010";         -- when memory read, one state more to store data in registers
    constant s_stop : StateType := "00001";         -- fullstop (and fallback to stop)
    
    -- MUX selects: 
    constant sel_mux_1_rs_2      : bit  := '0'; 
    constant sel_mux_1_const_1   : bit  := '1'; 
    
    constant sel_mux_2_alu_res   : bit  := '0'; 
    constant sel_mux_2_const_reg : bit  := '1'; 
    
    constant sel_mux_3_rs_1      : bit  := '0'; 
    constant sel_mux_3_rs_2      : bit  := '1'; 
    
    constant sel_mux_4_const_2   : bit  := '0'; 
    constant sel_mux_4_rs_1      : bit  := '1';
    
    constant sel_mux_5_imm_4     : bit_vector(1 downto 0)  := "00"; 
    constant sel_mux_5_addr_in   : bit_vector(1 downto 0)  := "01";
    constant sel_mux_5_imm       : bit_vector(1 downto 0)  := "10"; 
    constant sel_mux_5_gnd       : bit_vector(1 downto 0)  := "11"; -- do not use
    
    constant sel_mux_6_imm       : bit  := '0'; 
    constant sel_mux_6_pc        : bit  := '1';
    
    constant sel_mux_7_pc        : bit  := '0'; 
    constant sel_mux_7_inc_out   : bit  := '1';    
        
end package;