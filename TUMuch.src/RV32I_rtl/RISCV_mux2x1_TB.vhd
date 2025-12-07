-- created by Josip Pepic
library ieee;
use ieee.numeric_bit.all;
library work;

entity mux2x1_TB is
end mux2x1_TB;

architecture Behavioral of mux2x1_TB is
    signal tb_0, tb_1, res  : bit_vector(31 downto 0);
    signal sel              : bit := '0';
begin

    mux_2x1 :   entity work.mux2x1(RTL)
                    port map(
                        in_0   => tb_0,
                        in_1   => tb_1,
                        sel    => sel,
                        output => res
                    );

    process
    begin
        tb_0 <= (others=>'0');
        tb_1 <= x"00000001";
        sel  <= '0';
        wait for 5 ns;
  
        assert res = x"00000000"
        report "unexpected output"
        severity error;
        
        sel  <= '1';
        wait for 5 ns;
        
        assert res = x"00000001"
        report "unexpected output"
        severity error;
        
        wait;
    end process;

end Behavioral;
