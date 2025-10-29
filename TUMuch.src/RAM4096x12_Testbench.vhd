-- ERSTELLT von Severin Hanf 
library IEEE;
use ieee.numeric_bit.all;

entity RAM4096x12_Testbench is 
    port(
        w_en         : out bit; 
        addr         : out bit_vector( 11 downto 0 ); 
        dataToMem    : out bit_vector( 11 downto 0 );
        dataFromMem1 : in  bit_vector( 11 downto 0 ); 
        dataFromMem2 : in  bit_vector( 11 downto 0 ) 
    );
end RAM4096x12_Testbench;



architecture Behavorial of RAM4096x12_Testbench is     
begin    
    process
        variable i : natural range 0 to 4095;         
    begin
        for i in 0 to 4095 loop
            --Write Data to Memory            
            addr <= bit_vector(to_unsigned(i, 12)); 
            dataToMem <= bit_vector(to_unsigned(i, 12)); 
            --Enable Write for 10ns
            w_en <= '1'; 
            wait for 10ns; 
            w_en <= '0';
            --Assert Read Data 
            assert (dataFromMem1 = dataFromMem2) and (dataFromMem1 = bit_vector(to_unsigned(i, 12)))
            report "wrong memory values"
            severity error;     
        end loop; 
        wait;  
    end process;
end Behavorial; 

