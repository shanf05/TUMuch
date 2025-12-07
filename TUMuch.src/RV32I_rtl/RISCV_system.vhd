library work; 
use work.defs_pack.all; 

entity system is
    port(
        clk    : in bit; 
        rst    : in bit;
        active : out bit
    ); 
end;

architecture rtl of system is
    signal addr_out_sig    : bit_vector(AddrSize-1 downto 0);
    signal addr_in_sig     : BusDataType; 
    signal data_in_sig     : BusDataType;
    signal data_out_sig    : BusDataType;
    signal data_out_signal : BusDataType; 
    signal w_en_sig        : bit;
    signal reg_en_sig      : bit; 
    signal sel_in_sig      : bit_vector(4 downto 0);
    signal sel_out_a_sig   : bit_vector(4 downto 0);
    signal sel_out_b_sig   : bit_vector(4 downto 0);
    signal sel_mux_1_sig   : bit;
    signal sel_mux_2_sig   : bit;
    signal sel_mux_3_sig   : bit;
    signal operation_sig   : bit_vector(2 downto 0);
    signal const_1_sig     : BusDataType; 
    signal const_2_sig     : BusDataType; 
    
begin
    ram4096x32 : entity work.ram4096x32 port map(
                                            clk=>clk, 
                                            w_en=>w_en_sig, 
                                            addr=>addr_out_sig, 
                                            data_in=>data_out_sig, 
                                            data_out=>data_in_sig
                                            );
    
    controller : entity work.controller port map(
                                            clk=>clk, 
                                            rst=>rst,
                                            addr_in=>addr_in_sig, 
                                            sel_mux_1=>sel_mux_1_sig, 
                                            sel_mux_2=>sel_mux_2_sig, 
                                            sel_mux_3=>sel_mux_3_sig, 
                                            operation=>operation_sig,
                                            const_1=>const_1_sig, 
                                            const_2=>const_2_sig,
                                            data_in=>data_in_sig, 
                                            addr_out=>addr_out_sig,
                                            w_en=>w_en_sig, 
                                            active=>active
                                            );
                                            
    datapath   : entity work.datapath   port map(
                                            clk=>clk, 
                                            rst=>rst, 
                                            data_out=>data_out_sig, 
                                            addr_in=>addr_in_sig, 
                                            sel_mux_1=>sel_mux_1_sig, 
                                            sel_mux_2=>sel_mux_2_sig, 
                                            sel_mux_3=>sel_mux_3_sig, 
                                            reg_en=>reg_en_sig,
                                            sel_in=>sel_in_sig,
                                            sel_out_a=>sel_out_a_sig,
                                            sel_out_b=>sel_out_b_sig,
                                            operation=>operation_sig,
                                            const_1=>const_1_sig,
                                            const_2=>const_2_sig                                            
                                            );    
end;