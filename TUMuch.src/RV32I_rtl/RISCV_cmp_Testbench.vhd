-- created by Josip Pepic
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.defs_pack.all;


entity cmp_Testbench is
    port (
        a           : out BusDataType;
        b           : out BusDataType;
        is_signed   : out bit;
        lt_res      : in  BusDataType;
        equal_res   : in bit
     );
end cmp_Testbench;

architecture Behavioral of cmp_Testbench is

begin
    process
    begin
        a <= (others=>'0');
        b <= (others=>'0');
        is_signed <= '0';   -- lt = 0, eq = 1
        wait for 5 ns;
        
        is_signed <= '1';   -- lt = 0, eq = 1
        wait for 5 ns;      
        
        b(0) <= '1';        -- lt = 1, eq = 0
        wait for 5 ns;
        
        b(b'high) <= '1';   -- lt = 0, eq = 0
        wait for 5 ns;
        
        is_signed <= '0';   -- lt = 1, eq = 0
        wait for 5 ns;
        
        wait;
    end process;

end Behavioral;

------------------------ testbench TLE ---------------------------
library work;
use work.defs_pack.all;

entity cmp_TLE is
end entity;

architecture Behavioral of cmp_TLE is
    signal a_s          : BusDataType;
    signal b_s          : BusDataType;
    signal is_signed_s  : bit;
    signal lt_res_s     : BusDataType;
    signal equal_res_s  : bit;
begin
    TB  :   entity work.cmp_Testbench(Behavioral)
                port map(
                        a           => a_s,
                        b           => b_s,
                        is_signed   => is_signed_s,
                        lt_res      => lt_res_s,
                        equal_res   => equal_res_s    
                        );
                        
    CMP :   entity work.cmp(RTL)
                port map(
                        a           => a_s,
                        b           => b_s,
                        is_signed   => is_signed_s,
                        lt_out      => lt_res_s,
                        equal_out   => equal_res_s    
                        );

end architecture;

