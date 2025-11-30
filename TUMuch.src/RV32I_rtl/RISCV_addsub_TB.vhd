--created by Jeongjoo Lim and Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.all;

library work;
use work.defs_pack.all;

entity addsub_TB is
    port(x1, x2 : out bit_vector(RegDataSize-1 downto 0);
         o_mode : out bit );
end addsub_TB;


architecture Behavioral of addsub_TB is
begin
    process begin
        o_mode <= '0';
        x1 <= (others => '0');
        x2 <= (others => '0');
        wait for 1 ns;
    
        o_mode <= '0';  -- add
        x1 <= X"00000001"; x2 <= X"00000001";         -- 1 + 1
        wait for 1 ns;
        x1 <= X"0000000F"; x2 <= X"00000001";         -- 15 + 1
        wait for 1 ns;
    
        o_mode <= '1';  -- subtract
        x1 <= X"0000000F"; x2 <= X"00000001";         -- 15 - 1
        wait for 1 ns;
        x1 <= X"00000001"; x2 <= X"0000000F";         -- 1 - 15 (negative)
        wait for 1 ns;
    
        o_mode <= '0';
        x1 <= X"FFFFFFFF"; x2 <= X"00000000";         -- x + 0
        wait for 1 ns;
        o_mode <= '1';
        x1 <= X"FFFFFFFF"; x2 <= X"00000000";         -- x - 0
        wait for 1 ns;
    
        o_mode <= '0';
        x1 <= X"7FFFFFFF"; x2 <= X"00000001";         -- +2^31-1 + 1 => overflow
        wait for 1 ns;
    
        o_mode <= '1';
        x1 <= X"80000000"; x2 <= X"00000001";         -- -2^31 - 1 => underflow
        wait for 1 ns;
    
        o_mode <= '0';
        x1 <= X"F0000000"; x2 <= X"F0000000";         -- large negative + large negative
        wait for 1 ns;
    
        o_mode <= '1';
        x1 <= X"00000010"; x2 <= X"FFFFFFF0";         -- 16 - (-16) = 32
        wait for 1 ns;
    
        o_mode <= '0';
        x1 <= X"AAAAAAAA"; x2 <= X"55555555";         -- pattern add
        wait for 1 ns;
        o_mode <= '1';
        x1 <= X"AAAAAAAA"; x2 <= X"55555555";         -- pattern subtract
        wait for 1 ns;
    
        o_mode <= '0';
        x1 <= X"12345678"; x2 <= X"9ABCDEF0";
        wait for 1 ns;
    
        o_mode <= '1';
        x1 <= X"DEADBEEF"; x2 <= X"0000C0DE";
        wait for 1 ns;
    
        wait;
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

