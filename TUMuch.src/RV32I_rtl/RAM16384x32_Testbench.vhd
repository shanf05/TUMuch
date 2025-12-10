-- ERSTELLT von Severin Hanf
library IEEE;
use ieee.numeric_bit.all;
library work; 
use work.defs_pack.all;

entity RAM16384x32_Testbench is 
end RAM16384x32_Testbench; 

architecture stimul of RAM16384x32_Testbench is
   signal clk      : bit := '0';
   signal w_en     : bit := '0'; 
   signal addr     : bit_vector(AddrSize-1 downto 0); 
   signal data_in  : MemDataType := (others=>'0'); 
   signal data_out : MemDataType := (others=>'0'); 
   signal acc_size : bit_vector (1 downto 0) := acc_size_word; 
begin    
    ram16384x132_uut : entity work.ram16384x32 port map(clk=>clk, w_en=>w_en, addr=>addr, acc_size=>acc_size, data_in=>data_in, data_out=>data_out); 
    
    clkgen : process
    begin
        wait for clkCycle/2;
        clk <= not clk; 
    end process; 
        
    
    inputgen : process
        variable i : natural range 0 to 4095;
    begin
        ------------- word tests ---------------------------------
        w_en <= '1';
        acc_size <= acc_size_word; 
        for i in 0 to 4095 loop
            --Write Data to Memory            
            addr <= bit_vector(to_unsigned(i, 16));
            data_in <= bit_vector(to_unsigned(i, 32));
            wait for clkCycle;            
        end loop;

        w_en <= '0';
        data_in <= (others=>'0'); 
        for i in 0 to 4095 loop
            --Assert Read Data
            addr <= bit_vector(to_unsigned(i, 16));
            wait for 0ns;    --force delty cycles for update
            wait for 0ns; 
            assert (data_out = bit_vector(to_unsigned(i, 32)))
            report "wrong memory values"
            severity error;
            wait for clkCycle;
        end loop;
        
        ------------- halfword tests ------------------------------
        w_en <= '1';
        acc_size <= acc_size_half_word; 
        for i in 0 to 2047 loop
            --Write Data to Memory            
            addr <= bit_vector(to_unsigned(i*2, 16));
            data_in <= bit_vector(to_unsigned(i, 32));
            wait for clkCycle;            
        end loop;

        w_en <= '0';
        data_in <= (others=>'0'); 
        for i in 0 to 4095 loop
            --Assert Read Data
            addr <= bit_vector(to_unsigned(i, 16));
            wait for 0ns;    --force delty cycles for update
            wait for 0ns; 
            assert (data_out = bit_vector(to_unsigned(i+1, 16)) & bit_vector(to_unsigned(i, 16)))
            report "wrong memory values"
            severity error;
            wait for clkCycle;
        end loop;
        
        ------------- byte tests ------------------------------
        
        wait;
    end process;
end stimul;