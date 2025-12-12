-- created by Josip Pepic
library ieee;
use ieee.numeric_bit.all;
library work;
use work.defs_pack.all;

entity mux32x1_TB is
end mux32x1_TB;

architecture Behavioral of mux32x1_TB is
    signal tb_in    : RegType; 
    signal res      : bit_vector(31 downto 0);
    signal sel      : bit_vector(4 downto 0);
begin

    mux_2x1 :   entity work.mux32x1(RTL)
                    port map(
                        in_0   => tb_in(0),
                        in_1   => tb_in(1),
                        in_2   => tb_in(2),
                        in_3   => tb_in(3),
                        in_4   => tb_in(4),
                        in_5   => tb_in(5),
                        in_6   => tb_in(6),
                        in_7   => tb_in(7),
                        in_8   => tb_in(8),
                        in_9   => tb_in(9),
                        in_10  => tb_in(10),
                        in_11  => tb_in(11),
                        in_12  => tb_in(12),
                        in_13  => tb_in(13),
                        in_14  => tb_in(14),
                        in_15  => tb_in(15),
                        in_16  => tb_in(16),
                        in_17  => tb_in(17),
                        in_18  => tb_in(18),
                        in_19  => tb_in(19),
                        in_20  => tb_in(20),
                        in_21  => tb_in(21),
                        in_22  => tb_in(22),
                        in_23  => tb_in(23),
                        in_24  => tb_in(24),
                        in_25  => tb_in(25),
                        in_26  => tb_in(26),
                        in_27  => tb_in(27),
                        in_28  => tb_in(28),
                        in_29  => tb_in(29),
                        in_30  => tb_in(30),
                        in_31  => tb_in(31),
                        sel    => sel,
                        output => res
                    );

    process
    begin
        for i in 0 to 31 loop
            tb_in(i) <= bit_vector(to_unsigned(i, 32));
            wait for 5 ns;
        end loop;
        
        for i in 0 to 31 loop
            sel  <= bit_vector(to_unsigned(i, 5));
            wait for 5 ns;
            
            assert to_integer(unsigned(res)) = i
            report "unexpected output"
            severity error;
        end loop;
        
        wait;
    end process;

end Behavioral;