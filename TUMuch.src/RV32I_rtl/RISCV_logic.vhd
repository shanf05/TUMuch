-- created by JEONGJOO LIM
library IEEE;
use IEEE.numeric_bit.all;
library work; 
use work.defs_pack.all;

--- OR ---------------------------------

entity or32 is
    port(
        x1, x2 : in  BusDataType; 
        y      : out BusDataType
    );
end or32;

architecture rtl of or32 is
begin
    process(x1, x2)
    begin
        y <= x1 or x2;         
    end process;  
end rtl;

--- XOR ---------------------------------
use work.defs_pack.all;
entity xor32 is
    port(
        x1, x2 : in  BusDataType; 
        y      : out BusDataType
    );
end xor32;

architecture rtl of xor32 is
begin
    process(x1, x2)
    begin         
        y <= x1 xor x2;            
    end process;  
end rtl;


--- AND -------------------------------
use work.defs_pack.all;
entity and32 is
    port(
        x1, x2 : in  BusDataType; 
        y      : out BusDataType
    );
end and32; 

architecture rtl of and32 is
begin 
    process(x1, x2)
    begin         
        y <= x1 and x2;
    end process;    
end rtl; 