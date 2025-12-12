--ERSTELLT von JOSIP PEPIC
library IEEE;
use IEEE.numeric_bit.all;
library work;
use work.defs_pack.all;

package helper_func is
    function func_to_string (bv : bit_vector(31 downto 0)) return string;
    function Binary_to_data (s : string(1 to 32)) return MemDataType;
    function  hex_image_8(data : bit_vector(31 downto 0)) return string;
    function  hex_image_4(data : bit_vector(31 downto 0)) return string;  
end package;

package body helper_func is 
    function func_to_string (bv : bit_vector(31 downto 0)) return string is
        variable result : string (1 to 32);
        variable temp : character;
    begin
        for i in 1 to 32 loop
            if bv(i-1) = '0' then temp := '0';
            elsif bv(i-1) = '1' then temp := '1';
            else assert False report "Invalid bitvector input"; 
            end if;
            result(33-i):= temp;
        end loop;
         return result;
    end function func_to_string;

    function Binary_to_data (s : string(1 to 32)) return MemDataType is
        variable data : MemDataType := (others=>'0');
    begin
        for i in 1 to 32 loop
            if s(33 - i) = '0' then
                data(i-1) := '0';
            elsif s(33 - i) = '1' then
                data(i-1) := '1';
            else
                data(i-1) := '0';   --if wrong input use 0
            end if;
        end loop;
        return data;
    end function Binary_to_data;
    
    function hex_image_8(data : bit_vector(31 downto 0)) return string is
        constant hex_table : string := "0123456789ABCDEF";
        variable result    : string(1 to 8);
        variable sector    : unsigned(3 downto 0);       
    begin        
        for i in 0 to 7 loop
            -- select 4-bit sector
            sector := unsigned(data(31 - i*4 downto 28 - i*4));
            -- map sector (0-15) to hex char
            result(i+1) := hex_table(to_integer(sector) + 1);
        end loop;
        return result;        
    end function; 
    
    function hex_image_4(data : bit_vector(31 downto 0)) return string is
        constant hex_table : string := "0123456789ABCDEF";
        variable result    : string(1 to 4);
        variable sector    : unsigned(3 downto 0);       
    begin        
        for i in 0 to 3 loop
            -- select 4-bit sector
            sector := unsigned(data(15 - i*4 downto 12 - i*4));
            -- map sector (0-15) to hex char
            result(i+1) := hex_table(to_integer(sector) + 1);            
        end loop;
        return result;        
    end function; 
    
    
end package body; 

