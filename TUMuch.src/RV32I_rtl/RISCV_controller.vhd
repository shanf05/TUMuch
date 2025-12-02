--created by severin hanf
library work; 
use work.defs_pack.all; 

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
        clk : in bit;
        rst : in bit;
        
        --- command and address in, flags
        data_in   : in BusDataType;                 --from input device
        addr_in_1 : in MemAddrType;                 --from register file ?
        addr_in_2 : in MemAddrType;                 --from register file ?
        
        --- datapath signals
        fc_sel    : out bit;                        -- to flow controller, flow control select, 
        reg_en    : out bit;                        -- to register_file
        sel_in    : out bit_vector(1 downto 0);     -- to register_file
        sel_out_a : out bit_vector(1 downto 0);     -- to register_file
        sel_out_b : out bit_vector(1 downto 0);     -- to register_file
        sel_out_c : out bit_vector(1 downto 0);     -- to register_file
        operation : out bit_vector(2 downto 0);     -- to alu, see alu implementation -> 5 bits for 32 instructions
        data_out  : out BusDataType;                -- to flow controller
        
        --- memory and other external interface
        device_ready : in bit;                      -- from input / output device, check for periphery 
        mem_addr_out : out MemAddrType;             -- to memory
        w_en         : out bit;                     -- to memory
        d_in_mux     : out bit;                     -- to flow controller ? 
        io_type      : out bit;                     -- to input / output devices
        io_en        : out bit;                     -- to input / output devices
        
        --- active signal
        active : out bit                            -- controller status    
    );
end controller;

architecture rtl of controller is
    -- pc:
    signal pc_sig    : PcType := 0;                      -- from pc to mux32x4
    signal pc_in_sig : PcType := 0;                      -- from mux32x2_b to pc
    signal pc_en_sig : bit := '0';                       -- fsm to pc    
    
    -- addr: 
    signal addr_en_sig : bit := '0';                     -- from fsm to addr
    signal addr_sig    : MemAddrType;                    -- addr to mux32x4
    
    -- instr: 
    signal instr_en_sig : bit := '0';                    -- from fsm to instr
    signal instr_sig    : BusDataType := (others=>'0');  -- instr to instruction decoder
    
    -- fsm: 
    signal d_out_mux_sig : bit := '0';                   -- fsm to mux32x2_a
    signal pc_mux_sig    : bit := '0';                   -- fsm to mux32x2_b
    signal a_out_mux_sig : bit_vector (1 downto 0) := "00"; -- fsm to muc32x4
    
    -- instruction decoder:
    signal ctrl_sig : bit := '0';                        -- id to fsm -> how many bits is this wide? 
    
    -- inc: 
    signal inc_out_sig : MemAddrType := 0;              -- from inc to mux32x2_b
    
    -- mux32x4: 
    signal addr_out_sig : MemAddrType := 0;             -- from mux32x4 to port, needs to be buffered    
begin
    
    instr     : entity work.ctrl_instr     port map(data_in=>data_in, instr_en=>instr_en_sig, data_out=>instr_sig); -- done wiring    
    pc        : entity work.ctrl_pc        port map(pc=>pc_sig, pc_in=>pc_in_sig, pc_en=>pc_en_sig);                -- done wiring    
    addr      : entity work.ctrl_addr      port map(data_in=>data_in, addr_en=>addr_en_sig, addr=>addr_sig);        -- done wiring    
    ctrl_fsm  : entity work.ctrl_fsm       port map(fc_sel=>fc_sel, reg_en=>reg_en, d_in_mux=>d_in_mux, d_out_mux=>d_out_mux_sig, instr_en=>instr_en_sig, pc_mux=>pc_mux_sig, pc_en=>pc_en_sig, addr_en=>addr_en_sig, dev_rdy=>device_ready, w_en=>w_en, ctrl=>ctrl_sig); -- done wiring    
    --instr_dec : entity work.ctrl_instr_dec port map(sel_in=>sel_in, sel_out_a=>sel_out_a, sel_out_b=>sel_out_b, sel_out_c=>sel_out_c, ctrl=>ctrl_sig, instr=>instr_sig, op=>operation); -- done wiring    
    inc       : entity work.ctrl_inc       port map(addr_in=>addr_out_sig, inc_out=>inc_out_sig);     
    --mux32x2_a : entity work.mux            port map(in_1=>data_in, in_2=>pc_sig, out=>data_out); -- this is the one on the top     
    --mux32x2_b : entity work.mux            port map(in_1=>addr_in_2, in_2=>inc_out_sig);  -- this is the one on the bottom    
    --mux32x4   : entity work.mux            port map(in_1=>addr_in_1, in_2=>addr_sig, in_3=>pc_sig, in_4=>(others=>'0'), out=>addr_out_sig, sel=>a_out_mux_sig);    
    
    mem_addr_out <= addr_out_sig;   -- because input and output this needs to be buffered
end rtl;





