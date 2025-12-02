-- created by JEONGJOO LIM JOSIP PEPIC

library ieee;
use ieee.numeric_bit.all;

entity demux is
    generic (
        data_width  : integer := 32;           
        ports       : integer := 4              
    );
    port ( 
        input       : in bit_vector (data_width - 1 downto 0);      
        sel         : in integer range 0 to ports - 1;                      -- can be changed to vector type if its more convenient
        output      : out bit_vector(ports*data_width - 1 downto 0)         -- one-dimensional output instead of two-dimensional 
    );
end demux;

architecture RTL of demux is

begin
    process(input, sel)
    begin
        output <= (others => '0');   
        output(sel*data_width + data_width - 1 downto data_width * sel) <= input;
    end process;

end RTL;
