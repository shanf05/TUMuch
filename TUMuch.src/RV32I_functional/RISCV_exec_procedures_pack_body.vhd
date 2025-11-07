library work;
use work.exec_procedures_pack.all; 
use work.defs_pack.all; 
library ieee;
use IEEE.numeric_bit.all;

package body exec_procedures_pack is   

    procedure JAL_exec  (rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType)    is                --Severin Hanf
    variable tmp1 : bit_vector(19 downto 0) := (others=>'0'); 
    variable tmp2 : integer := 0; 
    begin    
        reg(rd) := bit_vector(to_unsigned(pc + 4,32) ); --store the return address in rd              
        
        if(imm(20) = '0') then            
            pc := pc + to_integer(unsigned(imm(10 downto 1) & imm(11) & imm(19 downto 12) & '0'));
        else 
            pc := pc + to_integer(signed(imm(10 downto 1) & imm(11) & imm(19 downto 12) & '0'));
        end if;               
        
    end procedure;              
    
    procedure JALR_exec (rs1, rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is           --Severin Hanf
    begin
    
    end procedure; 
    
end package body exec_procedures_pack;