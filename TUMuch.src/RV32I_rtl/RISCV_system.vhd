library work; 
use work.defs_pack.all; 

entity system is
    port(
        clk      : in  bit; 
        rst      : in  bit;
        active   : out bit;
        w_en     : out bit; 
        addr_out : out bit_vector(AddrSize-1 downto 0);
        data_out : out BusDataType; 
        data_in  : in  BusDataType;
        acc_size : out bit_vector (1 downto 0)
    ); 
end;

architecture rtl of system is
    signal addr_in_sig     : bit_vector(AddrSize-1 downto 0);
    signal reg_en_sig      : bit; 
    signal sel_in_sig      : bit_vector(4 downto 0);
    signal sel_out_a_sig   : bit_vector(4 downto 0);
    signal sel_out_b_sig   : bit_vector(4 downto 0);
    signal sel_mux_1_sig   : bit;
    signal sel_mux_2_sig   : bit;
    signal sel_mux_4_sig   : bit;
    signal operation_sig   : bit_vector(3 downto 0);
    signal const_1_sig     : BusDataType; 
    signal const_2_sig     : BusDataType; 
    signal const_reg_sig   : BusDataType;
    signal comp_res_sig    : bit_vector(1 downto 0);
begin
    controller : entity work.controller port map(
                                            clk=>clk, 
                                            rst=>rst,
                                            addr_in=>addr_in_sig, 
                                            acc_size=>acc_size,
                                            sel_mux_1=>sel_mux_1_sig, 
                                            sel_mux_2=>sel_mux_2_sig,                                            
                                            sel_mux_4=>sel_mux_4_sig,
                                            operation=>operation_sig,
                                            const_1=>const_1_sig, 
                                            const_2=>const_2_sig,
                                            const_reg=>const_reg_sig,
                                            comp_res=>comp_res_sig,
                                            data_in=>data_in, 
                                            addr_out=>addr_out,
                                            w_en=>w_en, 
                                            active=>active
                                            );
                                            
    datapath : entity work.datapath   port map(
                                            clk=>clk, 
                                            rst=>rst, 
                                            data_out=>data_out,                                            
                                            addr_in=>addr_in_sig, 
                                            comp_res=>comp_res_sig,
                                            sel_mux_1=>sel_mux_1_sig, 
                                            sel_mux_2=>sel_mux_2_sig, 
                                            sel_mux_4=>sel_mux_4_sig, 
                                            reg_en=>reg_en_sig,
                                            sel_in=>sel_in_sig,
                                            sel_out_a=>sel_out_a_sig,
                                            sel_out_b=>sel_out_b_sig,
                                            operation=>operation_sig,
                                            const_1=>const_1_sig,
                                            const_2=>const_2_sig,
                                            const_reg=>const_reg_sig                                         
                                            );    
end;