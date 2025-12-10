-- ERSTELLT VON severin hanf

library IEEE;
use IEEE.numeric_bit.all;

library work; 
use work.defs_pack.all; 

entity RAM16384x32 is 
    generic(  -- look if this is necessary
        tc : time := 0 ns; --delay to react on input change
        th : time := 0 ns --time to hold signals stable
    );  
    port(
        clk      : in bit; 
        w_en     : in bit;
        acc_size : in bit_vector(1 downto 0);               -- byte halfword or word accesses? 
        addr     : in bit_vector(AddrSize-1 downto 0); 
        data_in  : in  BusDataType;
        data_out : out BusDataType        
    );
end RAM16384x32;

architecture behavioral of RAM16384x32 is
    signal Mem : MemType;     --put flipflops right here 
begin
    synchronus_write : process
    begin        
        wait until clk = '1'; 
        if w_en = '1' then        
            case acc_size is
            when acc_size_word =>
                if addr(1 downto 0) = "00" then Mem(to_integer(unsigned(addr(AddrSize-1 downto 2)))) <= data_in;
                --else assert false report("wrong address for word access"); 
                end if;
            when acc_size_half_word =>
                case addr(1 downto 0) is
                when "00"   => Mem(to_integer(unsigned(addr(AddrSize-1 downto 2))))(15 downto 0)  <= data_in(15 downto 0);               
                when "10"   => Mem(to_integer(unsigned(addr(AddrSize-1 downto 2))))(31 downto 16) <= data_in(15 downto 0);
                when others => null; --assert false report("wrong address for half word access");
                end case;
            when acc_size_byte =>
                case addr(1 downto 0) is
                when "00" => Mem(to_integer(unsigned(addr(AddrSize-1 downto 2))))(7 downto 0)   <= data_in(7 downto 0);
                when "01" => Mem(to_integer(unsigned(addr(AddrSize-1 downto 2))))(15 downto 8)  <= data_in(7 downto 0);
                when "10" => Mem(to_integer(unsigned(addr(AddrSize-1 downto 2))))(23 downto 16) <= data_in(7 downto 0);
                when "11" => Mem(to_integer(unsigned(addr(AddrSize-1 downto 2))))(31 downto 24) <= data_in(7 downto 0);
                end case;
            when others => 
                --assert false report("wrong access size"); 
                null;           
            end case;
        end if;                    
    end process;
    
    asynchronus_read : process(Mem, addr)
    begin
        data_out <= Mem(to_integer(unsigned(addr(AddrSize-1 downto 2))));        
    end process;
    
end behavioral;