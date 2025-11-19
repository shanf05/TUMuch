--ERSTELLT von JOSIP PEPIC
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.defs_pack.all;
use IEEE.numeric_bit.all;

package helper_func is
    procedure write_val_to_reg(reg: inout RegType; rd: in RegAddrType; val: in RegDataType);
    procedure IncrementPC(pc : inout PcType);
    
    --functions for Type conversions from textfile
    function to_MemAddrType (MemAddr : string(1 to 6)) return MemAddrType;
    function to_RegAddrType (Reg : string(1 to 2)) return RegAddrType;
    function to_ImmType (ImmString : string; sign : boolean) return ImmType;

    --auxiliary functions
    function hexstr_to_int (s : string; sign : boolean) return integer;
    function hexstr_to_bit_vector(s : string) return bit_vector;
    function func_to_string (bv : bit_vector(31 downto 0)) return string;
    function hexchar_to_int (char : character) return integer;
    function Binary_to_data (s : string(1 to 32)) return MemDataType;
    
end package;

package body helper_func is 
    procedure write_val_to_reg(reg: inout RegType; rd: in RegAddrType; val: in RegDataType) is 
    begin
        if rd /= 0 then reg(rd) := val;
        else
            assert false
            report "Invalid Access -- x0 is read only"
            severity warning;
        end if;
    end procedure;
    
    procedure IncrementPC(pc : inout PcType) is
    begin
        pc := pc + 4;    
    end procedure;
    
    -------------------------------
    
    function to_MemAddrType (MemAddr : string (1 to 6)) return MemAddrType is
    variable MemAddrString : string (1 to 4) := MemAddr(3 to 6);
    variable MemAddr_dec : MemAddrtype;
    begin
        MemAddr_dec := hexstr_to_int(MemAddrString, false) / 4;                --remove last 2 bits for 14 bit address space
        if (0 <= MemAddr_dec) and (MemAddr_dec <= 2**MemAddrSize-1) then
            return MemAddr_dec;
        else
            assert false
            report "Invalid Operation -- Memory address range: 0 - 16383"
            severity error;
            return 0;
        end if;

    end function to_MemAddrType;


    function to_RegAddrType (Reg : string(1 to 2)) return RegAddrType is
    variable RegAddr_dec : RegAddrType;
    begin
        if Reg(2) = ' ' then    --account for case X1, X2... -> Problem: Whitespace causes runtime error
            RegAddr_dec := RegAddrType'value((1 to 1 => Reg(1)));
        else
            RegAddr_dec := RegAddrType'value(Reg);
        end if;
        if (0 <= RegAddr_dec) and (RegAddr_dec <= 2**RegAddrSize-1) then
            return RegAddr_dec;
        else
            assert false
            report "Invalid Operation -- Register address range: x00 - x31"
            severity error;
            return 0;
        end if;

    end function to_RegAddrType;


    function to_ImmType (ImmString : string; sign : boolean) return ImmType is
        variable Imm_dec : integer;
    begin
        Imm_dec := hexstr_to_int(s => ImmString, sign => sign );
        return bit_vector(to_signed(Imm_dec, RegDataSize));
    end function to_ImmType;
    
    -------------------------------
    
    function hexchar_to_int (char : character) return integer is
    variable value : integer := 0;
    begin
        case char is
            when '0' => value := 0;
            when '1' => value := 1;
            when '2' => value := 2;
            when '3' => value := 3;
            when '4' => value := 4;
            when '5' => value := 5;
            when '6' => value := 6;
            when '7' => value := 7;
            when '8' => value := 8;
            when '9' => value := 9;
            when 'A' | 'a' => value := 10;
            when 'B' | 'b' => value := 11;
            when 'C' | 'c' => value := 12;
            when 'D' | 'd' => value := 13;
            when 'E' | 'e' => value := 14;
            when 'F' | 'f' => value := 15;
            when others => assert false report "Invalid Operation -- Invalid Address" severity error;
            end case;
        return value;
    end function hexchar_to_int;

    function hexstr_to_int (s : string; sign : boolean) return integer is
    variable temp : integer := 0;
    variable result : integer := 0;
    variable bits : natural := 4 * s'length;
    begin
        for i in s'range loop
            temp := hexchar_to_int(s(i));
            result := result * 16 + temp;
        end loop;

        if sign then
            if result >= 2**(bits - 1) then
                result := result - 2**bits;
            end if;
        end if;

    return result;

    end function hexstr_to_int;
    
    function hexstr_to_bit_vector(s : string) return bit_vector is
    variable length : integer := s'length;
    variable result : bit_vector (4*length-1 downto 0);
    variable temp : unsigned (3 downto 0);
    begin
    
    for i in 0 to length-1 loop
        temp := to_unsigned(hexchar_to_int(s(i+1)), 4);
        for j in 0 to 3 loop
        result(4*length- 1 - 4*i -j):= temp(3-j);
        end loop;
    end loop;
    return result;
    end function hexstr_to_bit_vector;
    
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



end package body; 

