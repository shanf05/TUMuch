-- created by Josip Pepic
library ieee;
use ieee.numeric_bit.all;
library work;

entity mux4x1_TB is
end mux4x1_TB;

architecture Behavioral of mux4x1_TB is
    signal tb_0, tb_1, tb_2, tb_3, res  : bit_vector(31 downto 0);
    signal sel  : bit_vector(1 downto 0);
begin

    mux_2x1 :   entity work.mux4x1(RTL)
                    port map(
                        in_0   => tb_0,
                        in_1   => tb_1,
                        in_2   => tb_2,
                        in_3   => tb_3,
                        sel    => sel,
                        output => res
                    );

    process
    begin
        for i in 0 to 3 loop
            
        end loop;
        
        tb_0 <= bit_vector(to_unsigned(0, 32));
        tb_1 <= bit_vector(to_unsigned(1, 32));
        tb_2 <= bit_vector(to_unsigned(2, 32));
        tb_3 <= bit_vector(to_unsigned(3, 32));
        
        sel  <= bit_vector(to_unsigned(0, 2));
        wait for 5 ns;
        
        assert res = bit_vector(to_unsigned(0, 32))
        report "unexpected output"
        severity error;
        
        sel  <= bit_vector(to_unsigned(1, 2));
        wait for 5 ns;
        
        assert res = bit_vector(to_unsigned(1, 32))
        report "unexpected output"
        severity error;
        
        sel  <= bit_vector(to_unsigned(2, 2));
        wait for 5 ns;
        
        assert res = bit_vector(to_unsigned(2, 32))
        report "unexpected output"
        severity error;
        
        sel  <= bit_vector(to_unsigned(3, 2));
        wait for 5 ns;
        
        assert res = bit_vector(to_unsigned(3, 32))
        report "unexpected output"
        severity error;
        
        wait;
    end process;

end Behavioral;