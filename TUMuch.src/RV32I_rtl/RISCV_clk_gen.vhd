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
        clk : buffer bit := init_value
        );
end clk_gen;

architecture dataflow of clk_gen is

begin
    clk <= not init_value, init_value after init_delay
            when now = 0 ns 
            else '1' after T_low when clk = '0' and now > 0 ns and now < T_active 
            else '0' after T_high when clk = '1' and now > 0 ns and now < T_active 
            else clk;

end dataflow;
