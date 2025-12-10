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
        active          : in bit;                               -- active signal from fsm
        clk             : in bit;                               
        data_from_mem   : in BusDataType;
        
        rst             : out bit;                              -- used to "start" the cpu manually
        data_to_mem     : out BusDataType;                      
        mem_addr        : out bit_vector(AddrSize-1 downto 0);
        w_en            : out bit;
        acc_size        : out bit_vector(1 downto 0);
        
        sel             : out bit                               -- high when TB is connected to memory, low when system is connected to memory
        
     );
end TB;

architecture Behavioral of TB is
    file BinFile        : Text open read_mode is "../../../../TUMuch.rsc/RV32I_rtl/bin_input.txt";
    file DataDumpFile   : Text open write_mode is "../../../../TUMuch.rsc/RV32I_rtl/data_dump.txt";
begin
    process
        variable l : line;
        variable w : line;
        variable v : string(1 to 32);
        variable success : boolean;
        variable addr   : integer range 0 to 2**MemAddrSize-1 := 0; 
    begin
        
        
        rst <= '0';
        
        -------------------- Memory Load --------------------
        
        sel <= '1';
        w_en <= '1';
        acc_size <= acc_size_word;
        loop
            exit when endfile(BinFile);
            readline(BinFile, l);
            read(l, v(1 to 32), success);
            data_to_mem <= Binary_to_data(v(1 to 32));
            mem_addr <= bit_vector(to_unsigned(addr, AddrSize));
            wait until clk'event and clk='1';
            addr := addr + 4;
        end loop;
        w_en <= '0';
        sel <= '0';
        
        -- wait for cpu to finish instructions 
        rst <= '1';
        wait for 0 ns;
        rst <= '0';
        wait until active = '0';
        
        -------------------- Memory Dump --------------------
        sel <= '1';
        
        write( w , string'(" ADDR  |   HEX    |              BIN"));
        writeline(DataDumpFile, w);
        write( w , string'("-----------------------------------------------------"));
        writeline(DataDumpFile, w);
        
        addr := 0;
        for i in 0 to 2**MemAddrSize-1 loop
            mem_addr <= bit_vector(to_unsigned(addr, AddrSize));
            
            wait for 0 ns;
            wait for 0 ns;
            
            write( w , string'("0x") );            
            write( w , hex_image_4(bit_vector(to_unsigned(i*4, 32))) );
            write( w , string'(" | ") );
            write( w , hex_image_8(data_from_mem), left, 8);
            write( w , string'(" | ") );
            write( w , func_to_string(data_from_mem));

            writeline(DataDumpFile, w);
            addr := addr +4;
        end loop;
        
        wait;
    end process;

end Behavioral;
