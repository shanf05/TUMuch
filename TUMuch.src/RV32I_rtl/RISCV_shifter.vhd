-- created by Severin Hanf

library work; 
use work.defs_pack.all;
library IEEE;
use IEEE.NUMERIC_BIT.ALL;

entity shifter32 is
    port(
        clk        : in  bit;
        data_in    : in  BusDataType; 
        data_out   : out BusDataType;
        direction  : in  bit; 
        shamt      : in  bit_vector (4 downto 0);
        arithmetic : in  bit
    );
end shifter32;

architecture rtl of shifter32 is    
begin
    process(clk)
        variable data_tmp : BusDataType := (others => '0');
        variable shamt_int : integer; 
    begin 
        if (clk = '1' and clk'event) then 
            shamt_int := to_integer(unsigned(shamt));
            if direction = '1' then                                                     --left shift
                data_tmp(31 downto shamt_int)  := data_in((31 - shamt_int) downto 0);
                data_tmp(shamt_int-1 downto 0) := (others=>'0');
            else                                                                        --right shift
                if arithmetic = '1' then
                    data_tmp(31 downto (31 - shamt_int)) := (others=>data_in(31));              --fill with msb
                else 
                    data_tmp(31 downto (31 - shamt_int)) := (others=>'0');      --fill with zeros
                end if;            
                data_tmp((31 - shamt_int) downto 0) := data_in(31 downto shamt_int);            
            end if;   
            data_out <= data_tmp;
        end if;
    end process;    
end rtl;

