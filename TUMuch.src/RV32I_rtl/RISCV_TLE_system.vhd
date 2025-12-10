library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;
library work; 
use work.defs_pack.all; 

--Top Level Entity between System and clk & rst generator
entity TLE_system is
end TLE_system;

architecture RTL of TLE_system is
signal clk_sig, rst_sig, active_sig, w_en_sig, dbg_sig : bit;
signal addr_out_sig : bit_vector(AddrSize-1 downto 0);
signal data_out_sig, data_in_sig : BusDataType;
signal acc_size_sig : bit_vector (1 downto 0);

--initialisation: 
signal dbg_data_sig : BusDataType; 
signal dbg_addr_sig : bit_vector(AddrSize-1 downto 0);
signal dbg_w_en_sig : bit; 

begin
    system : entity work.system
             port map(
                clk => clk_sig, 
                rst => rst_sig, 
                active => active_sig,
                w_en => w_en_sig,    
                addr_out => addr_out_sig,
                data_out => data_out_sig, 
                data_in => data_in_sig, 
                acc_size => acc_size_sig
                );
            
    rst_gen : entity work.rst_gen
              port map (rst => rst_sig);
              
    clk_gen : entity work.clk_gen
              port map (clk => clk_sig);
    
    ram16384x32 : entity work.ram16384x32 port map(
                                            clk=>clk_sig, 
                                            w_en=>w_en_sig, 
                                            addr=>addr_out_sig, 
                                            acc_size=>acc_size_sig,
                                            data_in=>data_out_sig, 
                                            data_out=>data_in_sig
                                            );
                                             
    dbg_mux_1 : entity work.mux2x1 port map(in_0=>data_out_sig, in_1=>dbg_data_sig, sel=>dbg_sig);        --data 
    dbg_mux_2 : entity work.mux2x1 generic map (data_width=>16) port map(in_0=>dbg_addr_sig, in_1=>addr_out_sig, sel=>dbg_sig);        --addr
    --dbg_mux_3 : entity work.mux2x1 generic map (data_width=>1) port map(in_0=>dbg_w_en_sig, in_1=>w_en_sig, sel=>dbg_sig);        --w_en
end RTL;
