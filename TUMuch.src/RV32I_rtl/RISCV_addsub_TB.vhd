--created by Jeongjoo Lim and Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.defs_pack.all;

entity addsub_TB is
    port(x1, x2 : out bit_vector(RegDataSize-1 downto 0);
         o_mode : out bit
           );
end addsub_TB;


architecture Behavioral of addsub_TB is
begin
    process
    begin
    o_mode <= '1';
    x1 <= "00000000000000000000000011111111";
    x2 <= "11000000000000000000000011111111";
    wait for 10 ns;
    o_mode <= '0';
    x1 <= "00000000000000000000001110000000";
    x2 <= "00000001111111000000001110000000";
    end process;

end Behavioral;


----Top Level Entity AddSub
entity addsub_TLE is
end addsub_TLE;

library work;
use work.defs_pack.all;

architecture Behavioral of addsub_TLE is
    signal x1_sig, x2_sig, y_sig : bit_vector(RegDataSize-1 downto 0);
    signal o_mode_sig : bit;
begin
    TB :  entity work.addsub_TB(Behavioral)
         port map(x1 => x1_sig, x2 => x2_sig, o_mode => o_mode_sig);
         
    UUT : entity work.addsub(RTL)
         port map(a => x1_sig, b => x2_sig, d_out => y_sig, o_mode => o_mode_sig);

end Behavioral;

