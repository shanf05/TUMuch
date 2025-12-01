-- ERSTELLT von Severin Hanf
library IEEE;
use ieee.numeric_bit.all;
library work; 
use work.defs_pack.all;

entity RAM4096x32_Testbench is 
end RAM4096x32_Testbench; 

architecture stimul of RAM4096x32_Testbench is
   signal clk      : bit := '0';
   signal w_en     : bit := '0'; 
   signal addr     : MemAddrType := 0; 
   signal data_in  : MemDataType := (others=>'0'); 
   signal data_out : MemDataType := (others=>'0'); 
begin    
    ram4096x132_uut : entity work.ram4096x32 port map(clk=>clk, w_en=>w_en, addr=>addr, data_in=>data_in, data_out=>data_out); 
    
    clkgen : process
    begin
        wait for clkCycle/2;
        clk <= not clk; 
    end process; 
        
    
    inputgen : process
        variable i : natural range 0 to 4095;
    begin
        w_en <= '1';
        for i in 0 to 4095 loop
            --Write Data to Memory            
            addr <= i;
            data_in <= bit_vector(to_unsigned(i, 32));
            wait for clkCycle;            
        end loop;

        w_en <= '0';
        data_in <= (others=>'0'); 
        for i in 0 to 4095 loop
            --Assert Read Data
            addr <= i;
            wait for 0ns;    --force delty cycles for update
            wait for 0ns; 
            assert (data_out = bit_vector(to_unsigned(i, 32)))
            report "wrong memory values"
            severity error;
            wait for clkCycle;
        end loop;
        wait;
    end process;
end stimul;