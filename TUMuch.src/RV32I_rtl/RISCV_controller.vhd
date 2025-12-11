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
        addr_in   : in  bit_vector(AddrSize-1 downto 0);
        sel_mux_1 : out bit;
        sel_mux_2 : out bit;
        sel_mux_4 : out bit; 
        
        reg_en    : out bit;
        sel_in    : out bit_vector(4 downto 0);
        sel_out_a : out bit_vector(4 downto 0);
        sel_out_b : out bit_vector(4 downto 0);
        operation : out bit_vector(3 downto 0);        
        
        const_1   : out BusDataType;
        const_2   : out BusDataType;
        const_reg : out BusDataType;
        
        bra_cond  : in  bit;
                
        -- interface to memory: 
        data_in   : in  BusDataType;
        addr_out  : out bit_vector(AddrSize-1 downto 0);
        w_en      : out bit;
        acc_size  : out bit_vector(1 downto 0);
       
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
    signal sel_mux_5_sig : bit_vector(1 downto 0) := "00";                      -- from fsm to mux_5
    signal sel_mux_6_sig : bit := '0';                                          -- from fsm to mux_6
    signal sel_mux_7_sig : bit := '0';                                          -- from fsm to mux_7        
    signal pc_en_sig     : bit := '0';                                          -- from fsm to pc 
    signal inc_en_sig    : bit := '0';                                          -- from fsm to inc       
    -- id:      
    signal cmd_store_sig, cmd_calc_sig, cmd_const_sig, cmd_load_sig, cmd_reg_sig, cmd_auipc_sig, cmd_jmp_sig, cmd_stop_sig : bit := '0';   -- id to fsm
    signal imm_sig       : bit_vector(AddrSize-1 downto 0) := (others=>'0');    -- id to muxes
    -- inc: 
    signal inc_sig       : bit_vector(AddrSize-1 downto 0) := (others=>'0');    -- from inc to pc
    signal inc_out_sig   : bit_vector(AddrSize-1 downto 0) := (others=>'0');    -- from inc to addr_out    
    -- adder:
    signal summand_1_sig : bit_vector(AddrSize-1 downto 0) := (others=>'0');   -- from mux to adder
    signal summand_2_sig : bit_vector(AddrSize-1 downto 0) := (others=>'0');   -- from mux to adder
begin    
    pc        : entity work.ctrl_pc        port map(
                                                data_in=>inc_sig, 
                                                data_out=>pc_sig, 
                                                enable=>pc_en_sig
                                                );  
    ctrl_fsm  : entity work.ctrl_fsm       port map(
                                                clk=>clk, 
                                                rst=>rst, 
                                                cmd_store=>cmd_store_sig,
                                                cmd_calc=>cmd_calc_sig,
                                                cmd_const=>cmd_const_sig,
                                                cmd_load=>cmd_load_sig,
                                                cmd_reg=>cmd_reg_sig,
                                                cmd_auipc=>cmd_auipc_sig,
                                                cmd_jmp=>cmd_jmp_sig,
                                                cmd_stop=>cmd_stop_sig, 
                                                reg_en=>reg_en, 
                                                instr_en=>instr_en_sig, 
                                                inc_en=>inc_en_sig,
                                                w_en=>w_en, 
                                                pc_en=>pc_en_sig, 
                                                bra_cond=>bra_cond,
                                                sel_mux_1=>sel_mux_1, 
                                                sel_mux_2=>sel_mux_2, 
                                                sel_mux_4=>sel_mux_4, 
                                                sel_mux_5=>sel_mux_5_sig,
                                                sel_mux_6=>sel_mux_6_sig,
                                                sel_mux_7=>sel_mux_7_sig, 
                                                active=>active
                                                );   
    instr_dec : entity work.ctrl_instr_dec port map(
                                                instr=>instr_sig,
                                                pc_in => pc_sig,   
                                                data_in=>data_in,                                              
                                                sel_in=>sel_in, 
                                                sel_out_a=>sel_out_a, 
                                                sel_out_b=>sel_out_b,                                                
                                                cmd_store=>cmd_store_sig,
                                                cmd_calc=>cmd_calc_sig,
                                                cmd_const=>cmd_const_sig,
                                                cmd_load=>cmd_load_sig,
                                                cmd_reg=>cmd_reg_sig,
                                                cmd_auipc=>cmd_auipc_sig,
                                                cmd_jmp=>cmd_jmp_sig,
                                                cmd_stop=>cmd_stop_sig,
                                                op=>operation, 
                                                const_1 => const_1, 
                                                const_2 => const_2, 
                                                const_reg => const_reg,
                                                imm => imm_sig,
                                                acc_size=>acc_size                                               
                                                );    
    inc       : entity work.ctrl_inc       port map(
                                                data_in=>inc_out_sig, 
                                                data_out=>inc_sig,
                                                enable=>inc_en_sig
                                                ); 
    instr     : entity work.ctrl_instr     port map(
                                                data_in=>data_in,
                                                data_out=>instr_sig,
                                                enable=>instr_en_sig
                                                );   
    mux_5     : entity work.mux4x1          generic map(data_width=>16) 
                                            port map(
                                                in_0=>bit_vector(to_unsigned(4, 16)),   -- + 4
                                                in_1=>addr_in,                          -- + reg(rs1)
                                                in_2=>imm_sig,                          -- + imm
                                                in_3=>bit_vector(to_unsigned(0, 16)),   -- gnd
                                                sel=>sel_mux_5_sig, 
                                                output=>summand_2_sig
                                                );
    mux_6     : entity work.mux2x1          generic map(data_width=>16) 
                                            port map(
                                                in_0=>imm_sig, 
                                                in_1=>pc_sig, 
                                                sel=>sel_mux_6_sig, 
                                                output=>summand_1_sig
                                                );
    mux_7     : entity work.mux2x1          generic map(data_width=>16) 
                                            port map(
                                                in_0=>pc_sig, 
                                                in_1=>inc_out_sig, 
                                                sel=>sel_mux_7_sig, 
                                                output=>addr_out
                                            );    
    addsub_16 : entity work.addsub          generic map(Datasize => 16) 
                                            port map(
                                                a => summand_1_sig, 
                                                b => summand_2_sig, 
                                                d_out =>inc_out_sig,    
                                                o_mode => '0'                           -- always add
                                            );
     
end rtl;








