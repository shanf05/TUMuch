-- created by JEONGJOO LIM
library IEEE;
use IEEE.numeric_bit.all;

entity logic_Testbench is
    port(
        x1 : out bit_vector( 31 downto 0 );
        x2 : out bit_vector( 31 downto 0 )
    );
end logic_Testbench;

architecture Behavioral of logic_Testbench is
begin
    process
    begin
        x1 <= "01010101010101010101010101010101";
        x2 <= "10101010101010101010101010101010";
        wait for 1 ns;
        
        x1 <= "00000000000000000000000000000000";
        
        wait for 1 ns;
            
        wait;
    end process;
end Behavioral;

------------------------ testbench TLE ---------------------------


entity logic_Testbench_TLE is
end logic_Testbench_TLE;

architecture Behavioral of logic_Testbench_TLE is

    signal x1_sig, x2_sig     : bit_vector(31 downto 0);
    signal y_or_sig, y_xor_sig, y_nor_sig : bit_vector(31 downto 0);

begin

    TB   : entity work.logic_Testbench(Behavioral)
           port map (x1 => x1_sig, x2 => x2_sig);

    UUT1 : entity work.or32(rtl)
           port map (x1 => x1_sig, x2 => x2_sig, y => y_or_sig);

    UUT2 : entity work.xor32(rtl)
           port map (x1 => x1_sig, x2 => x2_sig, y => y_xor_sig);

    UUT3 : entity work.nor32(rtl)
           port map (x1 => x1_sig, x2 => x2_sig, y => y_nor_sig);

end Behavioral;
