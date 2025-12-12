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
begin
process
    variable clk_var : bit;
    begin
        if now = 0ns then
            clk_var := not init_value;
            clk <= clk_var;
            wait for init_delay;
            clk_var := init_value;
        elsif clk_var = '0' and now > 0 ns and now < T_active then
            wait for T_low;
            clk_var := '1';
        elsif  clk_var = '1' and now > 0 ns and now < T_active then
            wait for T_high;
            clk_var := '0';
        else clk_var := clk_var;
        end if;
        clk <= clk_var;
end process;
end dataflow;
