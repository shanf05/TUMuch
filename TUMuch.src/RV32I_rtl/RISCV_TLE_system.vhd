library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;
library work; 
use work.defs_pack.all; 

--Top Level Entity between System, clk generator, RAM and TB
entity TLE_system is
end TLE_system;

architecture RTL of TLE_system is
signal clk_sig, rst_sig, active_sig: bit;

-- System Signals
signal w_en_sys_sig : bit;
signal addr_out_sys_sig : bit_vector(AddrSize-1 downto 0);
signal data_out_sys_sig : BusDataType;
signal acc_size_sys_sig : bit_vector (1 downto 0);

-- TB signals
signal w_en_tb_sig, sel_sig : bit;
signal addr_out_tb_sig : bit_vector(AddrSize-1 downto 0);
signal data_out_tb_sig : BusDataType;
signal acc_size_tb_sig : bit_vector (1 downto 0);

-- RAM signals
signal w_en_sig : bit;
signal addr_out_sig : bit_vector(AddrSize-1 downto 0);
signal data_out_sig, data_in_sig : BusDataType;
signal acc_size_sig : bit_vector (1 downto 0);


--initialisation: 
--signal dbg_data_sig : BusDataType; 
--signal dbg_addr_sig : bit_vector(AddrSize-1 downto 0);
--signal dbg_w_en_sig : bit; 

begin
    system : entity work.system
             port map(
                clk => clk_sig, 
                rst => rst_sig, 
                active => active_sig,
                w_en => w_en_sys_sig,    
                addr_out => addr_out_sys_sig,
                data_out => data_out_sys_sig, 
                data_in => data_out_sig, 
                acc_size => acc_size_sys_sig
                );
            
--    rst_gen : entity work.rst_gen
--              port map (rst => rst_sig);
              
    clk_gen : entity work.clk_gen
              port map (clk => clk_sig);
    
    ram16384x32 : entity work.ram16384x32 port map(
                                            clk=>clk_sig, 
                                            w_en=>w_en_sig, 
                                            addr=>addr_out_sig, 
                                            acc_size=>acc_size_sig,
                                            data_in=>data_in_sig, 
                                            data_out=>data_out_sig
                                            );
    
    TB          : entity work.TB(Behavioral) port map(
                                                active => active_sig, 
                                                clk => clk_sig, 
                                                rst => rst_sig, 
                                                w_en => w_en_tb_sig, 
                                                data_from_mem => data_out_sig, 
                                                data_to_mem => data_out_tb_sig, 
                                                mem_addr => addr_out_tb_sig,
                                                acc_size => acc_size_tb_sig, 
                                                sel => sel_sig);
             
    mux_w_en        : entity work.mux2x1    generic map (data_width => 1) port map(in_0(0) => w_en_sys_sig, in_1(0) => w_en_tb_sig, sel => sel_sig, output(0) => w_en_sig);
    mux_addr        : entity work.mux2x1    generic map (data_width => AddrSize) port map(in_0 => addr_out_sys_sig, in_1 => addr_out_tb_sig, sel => sel_sig, output => addr_out_sig);
    mux_data_in     : entity work.mux2x1    generic map (data_width => BusDataSize) port map(in_0 => data_out_sys_sig, in_1 => data_out_tb_sig, sel => sel_sig, output => data_in_sig);
--     mux_data_out    : entity work.mux2x1    generic map (data_width => BusDataSize) port map(in_0 =>, in_1 => , sel => sel_sig);
    mux_acc_size    : entity work.mux2x1    generic map (data_width => 2) port map(in_0 => acc_size_sys_sig, in_1 => acc_size_tb_sig, sel => sel_sig, output => acc_size_sig);

end RTL;
