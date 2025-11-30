-- created by Josip Pepic
library ieee;
use ieee.numeric_bit.all;

--      ports specifies the amount of input ports

--      following convetion should be used for the input vector: inputs <= ... & Port2 & Port1 & Port0;
--      Port0, Port1, ... each have <data_width>-bits and (... Port2 & Port1 & Port0) has to be <ports> * <data_width> -bit long

--      if sel = x then PortX is selected ...

entity mux is
    generic (
        data_width  : integer := 32;           
        ports       : integer := 4              
    );
    port ( 
        input       : in bit_vector ((ports *data_width) - 1 downto 0);      -- one-dimensional input instead of two-dimensional 
        sel         : in integer range 0 to ports - 1;                      -- can be changed to vector type if its more convenient
        output      : out bit_vector(data_width - 1 downto 0)
    );
end mux;

architecture RTL of mux is

begin
    process(input, sel)
    begin   
        output <= input(sel*data_width + data_width - 1 downto data_width * sel);
    end process;

end RTL;
