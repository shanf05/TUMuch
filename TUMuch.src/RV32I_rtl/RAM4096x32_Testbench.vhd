-- ERSTELLT von Severin Hanf
library IEEE;
use ieee.numeric_bit.all;
library work; 
use work.defs_pack.all;

entity RAM4096x32_Testbench is
    port(
        w_en        : out bit;
        addr        : out MemAddrType; 
        dataToMem   : out MemDataType;
        dataFromMem : in  MemDataType
    );
end RAM4096x32_Testbench; 

architecture stimul of RAM4096x32_Testbench is
begin
    process
        variable i : natural range 0 to 4095;
    begin
        for i in 0 to 4095 loop
            --Write Data to Memory
            w_en <= '1';
            addr <= i;
            dataToMem <= bit_vector(to_unsigned(i, 32));
            wait for 10ns;
            w_en <= '0';
            wait for 10ns;
        end loop;

        for i in 0 to 4095 loop
            --Assert Read Data
            addr <= i;
            assert (dataFromMem = bit_vector(to_unsigned(i, 32)))
            report "wrong memory values"
            severity error;
            wait for 10ns;
        end loop;
        report "no errors detected";
        wait;
    end process;
end stimul;