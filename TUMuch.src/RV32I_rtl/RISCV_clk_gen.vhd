-- created by Max Biricz and Josip Pepic
library IEEE;
use ieee.numeric_bit.all;
library work;
use work.defs_pack.all;

entity clk_gen is
    generic(
            init_value      : bit := '1';
            init_delay      : time := 1 ns;
            T_high, T_low   : time := 5 ns;
            T_active        : time := 10000 ns
            );
    port (
        clk : out bit := init_value
        );
end clk_gen;

architecture dataflow of clk_gen is
    signal clk_sig : bit := '0';
begin
    clk_gen :process
        --variable clk_var : bit;
    begin        
        wait for T_high;
        clk_sig <= not clk_sig;        
        wait for T_low;
        clk_sig <= not clk_sig; 
    end process;
    
    clk <= clk_sig;
end dataflow;
