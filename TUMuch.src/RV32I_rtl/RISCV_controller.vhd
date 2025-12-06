--created by severin hanf
library work;
use work.defs_pack.all; 
use work.instr_dec_pack.all;
library IEEE;
use IEEE.numeric_bit.all;


-- • The Controller is no pure FSM but an FSM embedded in other units.
--    - The instruction decoder (ID) as look-up table
--    - The FSM as mealy machine
-- • The other units are responsible for specific tasks:
--    - Store assembler operation address (PC)
--    - Store assembler operation for decoding (INSTR)
---   - Store addresses of other addresses or data (ADDR)
--    - Increment assembler operation address (INC)
--    - Immediate switch of memory addresses or input for datapath / PC (MUX)
-- • Except for the instruction decoder and the FSM, all units have already
--   been developed.


-- see controllerAndFsmModeling @ 10

entity controller is
    port(
        -- clk, asynchronus rst:
        clk : in bit;
        rst : in bit;
        
        -- interface to datapath:        
        addr_in   : in  BusDataType;    -- this is longer than it needs to be -> adjustment in addr_mux
        sel_mux_1 : out bit;
        sel_mux_2 : out bit;
        sel_mux_3 : out bit; 
        
        reg_en    : out bit;
        sel_in    : out bit_vector(4 downto 0);
        sel_out_a : out bit_vector(4 downto 0);
        sel_out_b : out bit_vector(4 downto 0);
        operation : out bit_vector(2 downto 0);        
        
        const_1   : out BusDataType;
        const_2   : out BusDataType;
                
        -- interface to memory: 
        data_in   : in  BusDataType;
        addr_out  : out bit_vector(AddrSize-1 downto 0);
        w_en      : out bit;
       
        -- status: 
        active : out bit
    );
end controller;

architecture rtl of controller is
    -- pc:
    signal pc_sig        : bit_vector(AddrSize-1 downto 0) := (others=>'0');    -- from pc to mux and to id    
    -- instr: 
    signal instr_en_sig  : bit := '0';                                          -- from fsm to instr
    signal instr_sig     : BusDataType := (others=>'0');                        -- from instr to id    
    -- fsm: 
    signal sel_mux_4_sig : bit := '0';                                          -- from fsm to mux
    signal pc_en_sig     : bit := '0';                                          -- from fsm to pc 
  --signal inc_en_sig    : bit := '0';                                          -- from fsm to inc -> do i need this -> test !    
    -- id:
    signal ctrl_sig      : ctrl_bv_type := (others=>'0');                       -- id to fsm    
    -- inc: 
    signal inc_out_sig   : bit_vector(AddrSize-1 downto 0) := (others=>'0');    -- from inc to pc
       
    -- mux: 
    signal addr_out_sig : bit_vector(AddrSize-1 downto 0) := (others=>'0');     -- from mux to port and to inc    
begin    
    instr     : entity work.ctrl_instr     port map(data_in=>data_in, enable=>instr_en_sig, data_out=>instr_sig); -- done wiring    
    pc        : entity work.ctrl_pc        port map(data_in=>inc_out_sig, data_out=>pc_sig, enable=>pc_en_sig);                -- done wiring    
    ctrl_fsm  : entity work.ctrl_fsm       port map(clk=>clk, rst=>rst, ctrl=>ctrl_sig, reg_en=>reg_en, instr_en=>instr_en_sig, w_en=>w_en, pc_en=>pc_en_sig, sel_mux_1=>sel_mux_1, sel_mux_2=>sel_mux_2, sel_mux_3=>sel_mux_3, sel_mux_4=>sel_mux_4_sig); -- done wiring    
    --instr_dec : entity work.ctrl_instr_dec port map(sel_in=>sel_in, sel_out_a=>sel_out_a, sel_out_b=>sel_out_b, ctrl=>ctrl_sig, instr=>instr_sig, op=>operation); -- done wiring    
    inc       : entity work.ctrl_inc       port map(data_in=>addr_out_sig, data_out=>inc_out_sig);     
    --mux_4     : entity work.mux            generic map(ports=>2) port map(input=>mux_inputs_a, output=>data_out, sel=>d_out_mux_sig); -- this is the one on the top     
     
    addr_out <= addr_out_sig;   -- because input and output this needs to be buffered    
end rtl;








