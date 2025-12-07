-- ERSTELLT VON JEONGJOO LIM
-- NOT FOR SYNTHESIS!

library IEEE;
use IEEE.NUMERIC_STD.ALL;

entity rst_gen is
    generic (
        rst_level   : bit := '0';
        init_delay  : time := 1 ns;
        T_rst       : time := 10 ns
    );
    port (
        rst         : out bit
    );
end rst_gen;

architecture behavioral of rst_gen is
begin
    rst <=  not rst_level,
            rst_level after init_delay,
            not rst_level after init_delay + T_rst;
end;