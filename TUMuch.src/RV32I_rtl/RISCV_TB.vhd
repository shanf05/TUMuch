library IEEE;
use IEEE.numeric_bit.ALL;
library work;
use work.defs_pack.all;
use work.helper_func.all;
use std.textio.all;


entity TB is
    port (
        active          : in bit;                               -- active signal from fsm
        clk             : in bit;                               
        data_from_mem   : in BusDataType;
        
        rst             : out bit;                              -- used to reset the cpu manually
        data_to_mem     : out BusDataType;                      
        mem_addr        : out bit_vector(AddrSize-1 downto 0);
        w_en            : out bit;
        acc_size        : out bit_vector(1 downto 0);
        
        sel             : out bit                               -- high when TB is connected to memory, low when system is connected to memory
        
     );
end TB;

architecture Behavioral of TB is
    file BinFile        : Text open read_mode is "../../../../TUMuch.rsc/RV32I_rtl/test/bin/bin_input_BLT.txt";    -- USE THIS TO CHOOSE YOUR TEST
                                                                                                                            -- TO SEE WHAT THE TEST DOES, looak at /test/asm/asm_input_xyz.txt
                                                                                                                            -- IF YOU ARE USING THE input_LOAD.txt UNCOMMENT THE MEMORY OVERWRITE BELOW
    file DataDumpFile   : Text open write_mode is "../../../../TUMuch.rsc/RV32I_rtl/data_dump.txt";
    
    -- Data to overwrite in specific adresses (useful for STORE tests) --
    type addr_array is array (natural range <>) of bit_vector(AddrSize-1 downto 0);
    type data_array is array (natural range <>) of BusDataType;
    
    constant OVERWRITE_ADDR : addr_array := (
        x"1000",
        x"1004",
        x"1008"
    );
    constant OVERWRITE_DATA : data_array := (
        x"89ABCDEF",
        x"FEDCBA98",
        x"00001000"
    );
begin
    process
        variable l : line;
        variable w : line;
        variable v : string(1 to 32);
        variable success : boolean;
        variable addr   : integer range 0 to 2**MemAddrSize-1 := 0; 
    begin
        rst <= '1';
    
        ---------------------------------- Memory Load --------------------------------------------
        
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
        
        
        -------------------- Memory Overwrite (used for LOAD test -> uncomment) --------------------
        
        --for i in overwrite_addr'range loop
        --    data_to_mem <= overwrite_data(i);
        --    mem_addr <= overwrite_addr(i);
        --    wait until clk'event and clk='1';
        --end loop;        
        
        ------------------------------------ Run Instructions --------------------------------------
        
        w_en <= '0';
        sel <= '0';
         
        wait for 15 ns;
        rst <= '0';
        
        -- wait for cpu to finish instructions
        wait until active = '0';
        
        --------------------------------------- Memory Dump -----------------------------------------
        sel <= '1';
        
        write( w , string'(" ADDR  |   HEX    |              BIN"));
        writeline(DataDumpFile, w);
        write( w , string'("-----------------------------------------------------"));
        writeline(DataDumpFile, w);
        
        addr := 0;
        for i in 0 to 2**MemAddrSize-1 loop
            mem_addr <= bit_vector(to_unsigned(addr, AddrSize));
            
            wait for 10 ps;
            
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
