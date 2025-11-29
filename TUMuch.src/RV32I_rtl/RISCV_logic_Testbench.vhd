-- created by JEONGJOO LIM
library IEEE;
use IEEE.numeric_bit.all;

entity logic_Testbench is
    port(
        x1 : out bit_vector( 31 downto 0 );
        x2 : out bit_vector( 31 downto 0 )
    );
end logic_Testbench;

architecture Behavorial of logic_Testbench is
begin
    process
    begin
        x1 <= "01010101010101010101010101010101";
        x2 <= "10101010101010101010101010101010";
        wait for 1ns;
        
        x1 <= "00000000000000000000000000000000";
        
        wait for 1 ns;
            
        wait;
    end process;
end Behavorial;

------------------------ testbench TLE ---------------------------


entity logic_Testbench_TLE is
end logic_Testbench_TLE;

architecture Behavioral of logic_Testbench_TLE is
    component or32 is
        port(
            x1, x2 :    in bit_vector(31 downto 0);
            y :         out bit_vector(31 downto 0)
        );
    end component;
    
    component xor32 is
        port(
            x1, x2 :    in bit_vector(31 downto 0);
            y :         out bit_vector(31 downto 0)
        );
    end component;
    
    component nor32 is
        port(
            x1, x2 :    in bit_vector(31 downto 0);
            y :         out bit_vector(31 downto 0)
        );
    end component;
    
    component logic_Testbench is
        port(
            x1 :     out bit_vector(31 downto 0);
            x2 :     out bit_vector(31 downto 0)
        );
    end component;

    signal x1_sig, x2_sig, y_or_sig, y_xor_sig, y_nor_sig: bit_vector (31 downto 0); 
begin
    TB: logic_Testbench port map(x1 => x1_sig, x2 => x2_sig);
    UUT1: or32 port map(x1 => x1_sig, x2 => x2_sig, y => y_or_sig);
    UUT2: xor32 port map(x1 => x1_sig, x2 => x2_sig, y => y_xor_sig);
    UUT3: nor32 port map(x1 => x1_sig, x2 => x2_sig, y => y_nor_sig);
                    
end Behavioral;

configuration logic_Testbench_TLE_CONF of logic_Testbench_TLE is
    for Behavioral
        for TB: logic_Testbench use entity work.logic_Testbench(Behavioral);
        end for;
        for UUT1: or32 use entity work.or32(Behavioral);
        end for;
        for UUT2: xor32 use entity work.xor32(Behavioral);
        end for;
        for UUT3: nor32 use entity work.nor32(Behavioral);
        end for;
    end for;
end configuration;