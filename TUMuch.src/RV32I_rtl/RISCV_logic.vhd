-- created by JEONGJOO LIM
library IEEE;
use IEEE.numeric_bit.all;
library work; 
use work.defs_pack.all;

--- OR ----

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

--- XOR ----
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

--- NOR ----
use work.defs_pack.all;

entity nor32 is
    port(
        x1, x2 : in  BusDataType; 
        y      : out BusDataType
    );
end nor32;

architecture rtl of nor32 is
begin
    process(x1, x2)
    begin        
        y <= x1 nor x2; 
    end process;  
end rtl;

use work.defs_pack.all;

--- AND ---
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