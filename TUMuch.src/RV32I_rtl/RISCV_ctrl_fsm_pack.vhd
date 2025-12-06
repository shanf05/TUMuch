-- erstellt von Severin Hanf
package ctrl_fsm_pack is 
    subtype  StateType is bit_vector (4 downto 0); 
    constant s_if   : StateType := "10000";         -- instruction fetch 
    constant s_pfex : StateType := "01000";         -- parameter fetch (decode) and execute
    constant s_mem  : StateTYpe := "00100";         -- memory write
    constant s_rd   : StateType := "00010";         -- when memory read, one state more to store data in registers
    constant s_stop : StateType := "00001";         -- fullstop (and fallback to stop)
    
    -- MUX selects: 
    constant pc_mux_sel_inc    : bit  := '0'; 
    constant pc_mux_sel_a_in_2 : bit  := '1'; 
    
    constant a_out_mux_sel_a_in_1 : bit_vector(1 downto 0) := "00";
    constant a_out_mux_sel_addr   : bit_vector(1 downto 0) := "01"; 
    constant a_out_mux_sel_pc     : bit_vector(1 downto 0) := "10"; 
    
    constant d_out_mux_sel_d_in : bit_vector(1 downto 0) := "00"; 
    constant d_out_mux_sel_pc   : bit_vector(1 downto 0) := "01";
    constant d_out_muc_sel_imm  : bit_vector(1 downto 0) := "10"; 
    
end package;