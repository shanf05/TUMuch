-- ERSTELLT VON JEONGJOO LIM

library IEEE;
use IEEE.NUMERIC_STD.ALL;
use work.defs_pack.all;

entity Datapath is
    port ( 
        -- clock, reset
        clk : in bit;
        rst : in bit;
        
        -- data output
        data_out_1  : out BusDataType; 
        data_out_2  : out BusDataType; -- requires buffer
        
        -- from controller
        d_in_mux  : in bit;
        fc_sel    : in bit; 
        reg_en    : in bit;                            -- to register_file
        sel_in    : in RegAddrType;                    -- to register_file
        sel_out_a : in RegAddrType;                    -- to register_file
        sel_out_b : in RegAddrType;                    -- to register_file
        operation : in bit_vector(2 downto 0);         -- to alu, see alu implementation -> 5 bits for 32 instructions
        data_in   : in BusDataType                     -- to flow controller
        
        
    );
end Datapath;

architecture RTL of Datapath is
    
    signal alu_in  : BusDataType;
    signal alu_res : BusDataType;
    
    signal rf_in   : BusDataType; 
    
    signal data_out_2_sig : BusDataType;
    
begin
    alu : entity work.alu32 port map(
        operand_a => alu_in,
        operand_b => data_out_2_sig,
        
        operation => operation,                 -- should be fixed when mux sel is bit_vector
        
        result => alu_res
    );
    
    fc : entity work.fc port map(
        alu_res => alu_res,
        d_in => data_in,
        
        fc_sel => fc_sel,
        
        rf_in => rf_in
    );
    
    rf : entity work.reg_file port map(             -- rf missing 3rd output
        clk => clk,
        rst => rst,
        
        we => reg_en,
        w_addr => sel_in,
        w_data => rf_in,
        
        re_addr_1 => sel_out_a,
        r_data_1 => data_out_1,
        re_addr_2 => sel_out_b,
        r_data_2 => data_out_2_sig 
    );
    
    data_out_2 <= data_out_2_sig;
end RTL;
