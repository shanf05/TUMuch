-- created by Josip Pepic
library ieee;
use ieee.numeric_bit.all;


entity mux4x1 is
    generic (
        data_width  : natural := 32
    );
    port (
        in_0, in_1, in_2, in_3  : in bit_vector(data_width - 1 downto 0);
        sel                     : in bit_vector(1 downto 0);
        output                  : out bit_vector(data_width - 1 downto 0)
         );
end mux4x1;

architecture RTL of mux4x1 is

begin
    process(in_0, in_1, in_2, in_3, sel)
        variable sel_int : integer range 0 to 3;
    begin
        sel_int := to_integer(unsigned(sel));
        case sel_int is
            when 0 => output <= in_0;
            when 1 => output <= in_1;
            when 2 => output <= in_2;
            when others => output <= in_3;
        end case;
    end process;

end RTL;