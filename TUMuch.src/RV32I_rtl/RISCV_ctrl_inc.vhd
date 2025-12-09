-- erstellt von severin hanf
library work; 
use work.defs_pack.all;

library IEEE;
use IEEE.numeric_bit.all;

entity ctrl_inc is
    Port(
        data_out : out bit_vector(AddrSize-1 downto 0); 
        data_in  : in  bit_vector(AddrSize-1 downto 0);
        enable   : in  bit
    );
end ctrl_inc;

architecture rtl of ctrl_inc is
begin
    process(data_in)        
    begin
        if enable = '1' then
            data_out <= data_in;
        end if;
    end process;
end rtl;