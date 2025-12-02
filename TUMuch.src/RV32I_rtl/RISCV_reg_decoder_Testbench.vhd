-- created by Josip Pepic
library IEEE;
use IEEE.numeric_bit.ALL;
library work;
use work.defs_pack.all;

entity reg_decoder_Testbench is
    port (
         we     : out bit;
         w_addr : out RegAddrType;
         en     : in ENType
         );
end reg_decoder_Testbench;

architecture Behavioral of reg_decoder_Testbench is

begin
    process 
        variable expected_en : ENType := (others=>'0');
        
    begin
        we <= '1';
        w_addr <= 0;
        
        for i in 0 to 31 loop
            if i = 16 then
                we <= '0';
                wait for 0 ns;
            end  if;
            
            w_addr <= i;
            expected_en := (others=>'0');
            if i < 16 then
                expected_en(i) := '1';
            end if;
            
            wait for 5 ns;
            
            assert en = expected_en
            report "wrong en-vector"
            severity error;
        end loop;
        wait;
    end process;

end Behavioral;

------------------------ testbench TLE ---------------------------
library work;
use work.defs_pack.all;


entity reg_decoder_TLE is
end entity;

architecture Behavioral of reg_decoder_TLE is
    signal we_s       : bit;
    signal w_addr_s   : RegAddrType;
    signal en_s       : ENType;
begin
    TB  :   entity work.reg_decoder_Testbench(Behavioral)
                port map(
                    we      =>we_s,
                    w_addr  =>w_addr_s,
                    en      =>en_s
                    );
    dec :   entity work.reg_decoder(RTL)
                port map(
                    we      =>we_s,
                    w_addr  =>w_addr_s,
                    en      =>en_s
                    );
end architecture;