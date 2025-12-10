library IEEE;
use IEEE.numeric_bit.ALL;
library work;
use work.defs_pack.all;
use work.mem_pack.all;
use work.helper_func.all;
use work.trace_pack.all;
use std.textio.all;


entity TB is
    port (
        clk             : in bit;
        data_to_mem     : out BusDataType;
        data_from_mem   : in BusDataType;
        mem_addr        : out bit_vector(AddrSize-1 downto 0);
        w_en            : out bit;
        
        sel             : out bit
        
     );
end TB;

architecture Behavioral of TB is
    file BinFile        : Text open read_mode is "../../../../TUMuch.rsc/RV32I_rtl/bin_input.txt";
    file DataDumpFile   : Text open write_mode is "../../../../TUMuch.rsc/RV32I_rtl/data_dump.txt";
begin
    process
        variable l : line;
        variable v : string(1 to 32);
        variable success : boolean;
        variable addr   : integer range 0 to 2**MemAddrSize-1 := 0; 
    begin
        sel <= '1';
        w_en <= '1';
        loop
            exit when endfile(BinFile);
            readline(BinFile, l);
            read(l, v(1 to 32), success);
            data_to_mem <= Binary_to_data(v(1 to 32));
            mem_addr <= bit_vector(to_unsigned(addr, AddrSize));
            wait until clk'event and clk='1';
            addr := addr +1;
        end loop;
        w_en <= '0';
        sel <= '0';
        
        wait for 1000 ms;      -- wait for cpu to work off all instructions
        
        sel <= '1';
        
        write( l , string'(" ADDR  |   HEX    |              BIN"));
        writeline(DataDumpFile, l);
        write( l , string'("-----------------------------------------------------"));
        writeline(DataDumpFile, l);
        
        for i in 0 to 2**MemAddrSize-1 loop
            mem_addr <= bit_vector(to_unsigned(i, AddrSize));
            
            wait for 5 ns;
            
            write( l , string'("0x") );            
            write( l , hex_image_4(bit_vector(to_unsigned(i*4, 32))) );
            write( l , string'(" | ") );
            write( l , hex_image_8(data_from_mem), left, 8);
            write( l , string'(" | ") );
            write( l , func_to_string(data_from_mem));

            writeline(DataDumpFile, l);
        end loop;
        
        
    end process;

end Behavioral;
