library work;
use work.exec_procedures_pack.all; 
use work.defs_pack.all; 
library ieee;
use IEEE.numeric_bit.all;

package body exec_procedures_pack is   

    procedure JAL_exec  (rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is --Severin Hanf 
    begin    
        reg(rd) := bit_vector(to_unsigned(pc + 4,32) ); --store the return address in rd
        pc := pc + to_integer(signed(imm));             --jump to the new address                       
    end procedure;              
    
    procedure JALR_exec (rs1, rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is --Severin Hanf
    variable jumpAddress : unsigned(31 downto 0); 
    begin
        reg(rd) := bit_vector(to_unsigned(pc + 4,32));                                            --store the return address        
        jumpAddress := to_unsigned(to_integer(unsigned(reg(rs1))) + to_integer(signed(imm)), 32); --get the jump address
        jumpAddress(0) := '0';
        pc := to_integer(jumpAddress);                                                            --jump to the new address
    end procedure; 
    
    procedure BEQ_exec (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is --Severin Hanf    
    variable offset : signed(31 downto 0);
    begin
        if(reg(rs1) = reg(rs2)) then 
            offset := signed(imm);          --branch, because equal
        else 
            offset := to_signed(4, 32);     --no branch, because not equal
        end if; 
        pc := pc + to_integer(offset);                                                      
    end procedure;
    
    procedure BNE_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is --Severin Hanf    
    variable offset : signed(31 downto 0);
    begin
        if(reg(rs1) /= reg(rs2)) then 
            offset := signed(imm);          --branch, because not equal
        else 
            offset := to_signed(4, 32);     --no branch, because equal
        end if; 
        pc := pc + to_integer(offset);                                                      
    end procedure;
    
    procedure BLT_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is --Severin Hanf    
    variable offset : signed(31 downto 0);
    begin
        if(signed(reg(rs1)) < signed(reg(rs2))) then 
            offset := signed(imm);          --branch, because rs1 < rs2
        else 
            offset := to_signed(4, 32);     --no branch
        end if; 
        pc := pc + to_integer(offset);                                                      
    end procedure;
    
    procedure BGE_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is --Severin Hanf    
    variable offset : signed(31 downto 0);
    begin
        if(signed(reg(rs1)) >= signed(reg(rs2))) then 
            offset := signed(imm);          --branch, because rs1 >= rs2
        else 
            offset := to_signed(4, 32);     --no branch
        end if; 
        pc := pc + to_integer(offset);                                                      
    end procedure;
    
    procedure BLTU_exec (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is --Severin Hanf    
    variable offset : signed(31 downto 0);
    begin
        if(unsigned(reg(rs1)) < unsigned(reg(rs2))) then
            offset := signed(imm);                          --branch, because rs1 < rs2
        else 
            offset := to_signed(4, 32);                     --no branch
        end if; 
        pc := pc + to_integer(offset);                                                      
    end procedure;
    
    procedure BGEU_exec (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is --Severin Hanf    
    variable offset : signed(31 downto 0);
    begin
        if(unsigned(reg(rs1)) >= unsigned(reg(rs2))) then 
            offset := signed(imm);          --branch, because rs1 >= rs2
        else 
            offset := to_signed(4, 32);     --no branch
        end if; 
        pc := pc + to_integer(offset);                                                      
    end procedure;
    
     
    
    
end package body exec_procedures_pack;