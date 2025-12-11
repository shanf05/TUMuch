-- created by Josip Pepic
library ieee;
use ieee.numeric_bit.all;


entity mux2x1 is
    generic (
        data_width  : natural := 32
    );
    port (
        in_0, in_1  : in bit_vector(data_width - 1 downto 0);
        sel         : in bit;
        output      : out bit_vector(data_width - 1 downto 0)
         );
end mux2x1;

architecture RTL of mux2x1 is

begin
    process(in_0, in_1, sel)
    begin
        case sel is
            when '0'    => output <= in_0;
            when others => output <= in_1;
        end case;
    end process;
end RTL;