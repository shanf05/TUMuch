library work; 
use work.defs_pack.all;

entity ctrl_fsm is
    Port(
        fc_sel    : out bit; 
        reg_en    : out bit; 
        d_in_mux  : out bit; 
        d_out_mux : out bit;
        io_type   : out bit; 
        io_en     : out bit;
        w_en      : out bit;
        a_out_mux : out bit_vector(1 downto 0); 
        instr_en  : out bit;
        pc_mux    : out bit;
        pc_en     : out bit; 
        addr_en   : out bit; 
        
        dev_rdy   : in  bit;
        ctrl      : in  bit     -- look how many bits this needs        
    );
end ctrl_fsm;

architecture rtl of ctrl_fsm is

begin


end rtl;