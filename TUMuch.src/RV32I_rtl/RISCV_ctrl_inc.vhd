-- erstellt von severin hanf
library work; 
use work.defs_pack.all;

library IEEE;
use IEEE.numeric_bit.all;

entity ctrl_inc is
    Port(
        data_out : out bit_vector(AddrSize-1 downto 0); 
        data_in  : in  bit_vector(AddrSize-1 downto 0) 
    );
end ctrl_inc;

architecture rtl of ctrl_inc is
begin
    process(data_in)
        variable tmp_int : integer := 0;
    begin
        tmp_int := to_integer(unsigned(data_in)) + 4;
        data_out <= bit_vector(to_unsigned(tmp_int, AddrSize));
    end process;
end rtl;