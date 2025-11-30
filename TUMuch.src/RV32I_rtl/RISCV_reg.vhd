-- created by Josip Pepic
library IEEE;
use ieee.numeric_bit.all;
library work;
use work.defs_pack.all;

entity reg is
    port (
        RST : in  bit;
        EN  : in  bit;
        CLK : in  bit;
        D   : in  RegDataType;
        Q   : out RegDataType
          );
end reg;

architecture RTL of reg is
begin
    gen_reg : for i in 0 to RegDataSize-1 generate
            d_ff : entity work.D_FFRE(RTL)
                        port map(
                                clk     => clk,
                                rst     => rst,
                                en      => en,
                                D       => D(i),
                                Q       => Q(i)
                        );
    end generate;

end RTL;
