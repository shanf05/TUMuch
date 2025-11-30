-- created by JEONGJOO LIM
library IEEE;
use IEEE.numeric_bit.all;
library work; 
use work.defs_pack.all;

--- OR ----

entity or32 is
    port(
        x1, x2 :    in bit_vector(31 downto 0);
        y :         out bit_vector(31 downto 0)
    );
end or32;

architecture rtl of or32 is
begin
    process(x1, x2)
    begin
        y <= x1 OR x2;
    end process;
end rtl;

--- XOR ----

entity xor32 is
    port(
        x1, x2 :    in bit_vector(31 downto 0);
        y :         out bit_vector(31 downto 0)
    );
end xor32;

architecture rtl of xor32 is
begin
    process(x1, x2)
    begin
        y <= x1 XOR x2;
    end process;
end rtl;

--- NOR ----

entity nor32 is
    port(
        x1, x2 :    in bit_vector(31 downto 0);
        y :         out bit_vector(31 downto 0)
    );
end nor32;

architecture rtl of nor32 is
begin
    process(x1, x2)
    begin
        y <= x1 NOR x2;
    end process;
end rtl;

--- AND ---
entity and32 is
    port(
        --x1, x2 : in  BusDataType; 
        --y      : out BusDataType; 
        x1, x2 : in  bit_vector(31 downto 0); 
        y      : out bit_vector(31 downto 0); 
        clk    : in  bit
    );
end and32; 

architecture rtl of and32 is
begin 
    process(clk)
    begin
        if clk'event and clk = '1' then 
            y <= x1 and x2;
        end if; 
    end process;    
end rtl; 