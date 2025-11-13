library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_BIT.ALL;
library work;
use work.exec_procedures_pack.all; 
use work.defs_pack.all; 

package body exec_procedures_pack is   

-- ERSTELLT VON JEONGJOO LIM; Teil Orange; LB LBU LH LHU LW SB SH SW ADD SUB ADDI
    procedure LB_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin        
        temp := signed(Mem(rs1 + to_integer(signed(imm))));        
        Reg(rd) := bit_vector(temp);
        pc := pc + 4;
    end procedure;
    
    procedure LBU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
        variable temp : unsigned(RegDataSize-1 downto 0);
    begin    
        temp := unsigned(Mem(rs1 + to_integer(signed(imm))));
        Reg(rd) := bit_vector(temp);
        pc := pc + 4;
    end procedure;
    
    procedure LH_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        if rs1 + to_integer(signed(imm)) mod 2 /= 0 then
            report "Address misalignment -- LH_exec"
            severity warning;
        end if;
        
        temp(31 downto 8)   := signed(Mem(rs1 + to_integer(signed(imm)) + 1));
        temp(7 downto 0)    := signed(Mem(rs1 + to_integer(signed(imm))));
        
        Reg(rd) := bit_vector(temp);
        pc := pc + 4;
    end procedure;
        
    procedure LHU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
        variable temp : unsigned(RegDataSize-1 downto 0);
    begin
        if rs1 + to_integer(signed(imm)) mod 2 /= 0 then
            report "Address misalignment -- LHU_exec"
            severity warning;
        end if;
        
        temp(31 downto 8)   := unsigned(Mem(rs1 + to_integer(signed(imm)) + 1));
        temp(7 downto 0)    := unsigned(Mem(rs1 + to_integer(signed(imm))));
        
        Reg(rd) := bit_vector(temp);
        pc := pc + 4;
    end procedure;
    
    procedure LW_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        if rs1 + to_integer(signed(imm)) mod 4 /= 0 then
            report "Address misalignment -- LB_exec"
            severity warning;
        end if;
        
        temp(31 downto 24)  := signed(Mem(rs1 + to_integer(signed(imm)) + 3));
        temp(24 downto 16)  := signed(Mem(rs1 + to_integer(signed(imm)) + 2));
        temp(15 downto 8)   := signed(Mem(rs1 + to_integer(signed(imm)) + 1));
        temp(7 downto 0)    := signed(Mem(rs1 + to_integer(signed(imm))));
        
        Reg(rd) := bit_vector(temp);
        pc := pc + 4;
    end procedure;
    
    procedure SB_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
    begin
        Mem(rs1 + to_integer(signed(imm))) := Reg(rs2)(7 downto 0);
        pc := pc + 4;
    end procedure;
    
    procedure SH_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
    begin
        if rs1 + to_integer(signed(imm)) mod 2 /= 0 then
            report "Address misalignment -- SH_exec"
            severity warning;
        end if;
        
        Mem(rs1 + to_integer(signed(imm)) + 1)  := Reg(rs2)(15 downto 8);
        Mem(rs1 + to_integer(signed(imm)))      := Reg(rs2)(7 downto 0);        
        pc := pc + 4;
    end procedure;
    
    procedure SW_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
    begin
        if rs1 + to_integer(signed(imm)) mod 4 /= 0 then
            report "Address misalignment -- SW_exec"
            severity warning;
        end if;
        
        Mem(rs1 + to_integer(signed(imm)) + 3)  := Reg(rs2)(31 downto 24);
        Mem(rs1 + to_integer(signed(imm)) + 2)  := Reg(rs2)(23 downto 16);
        Mem(rs1 + to_integer(signed(imm)) + 1)  := Reg(rs2)(15 downto 8);
        Mem(rs1 + to_integer(signed(imm)))      := Reg(rs2)(7 downto 0);
        pc := pc + 4;
    end procedure;
    
    procedure ADD_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        temp := signed(Reg(rs1)) + signed(Reg(rs2));
        Reg(rd) := bit_vector(temp);
        pc := pc + 4;
    end procedure;
    
    procedure SUB_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        temp := signed(Reg(rs1)) - signed(Reg(rs2));
        Reg(rd) := bit_vector(temp);
        pc := pc + 4;
    end procedure;
    
    procedure ADDI_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout MemAddrType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        temp := signed(Reg(rs1)) + signed(imm);
        Reg(rd) := bit_vector(temp);
        pc := pc + 4;
    end procedure;
    
    
    ---------------------------------------
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

    ---------------------------------------
-- erstellt von Max Biricz; Teil Lila; LUI AUIPC XORI ORI ANDI SLLI SRLI SRAI SLTI SLTIU
     procedure LUI_exec(rd : RegAddrType; imm : ImmType; mem : inout MemType; Reg : inout RegType; pc : inout MemAddrType) is
    begin
        Reg(rd) := imm;             --no concatenation with X"000" -> already implemented in RISCV.vhd execute case
    end procedure LUI_exec;
    
    procedure AUIPC_exec(rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is
    begin
        Reg(rd) := bit_vector(to_unsigned(pc + to_integer(signed(imm)), 32));
    end procedure AUIPC_exec;
    
    
    procedure XORI_exec(rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is
    variable temp : RegDatatype;
    begin
       temp := Reg(rs1) xor imm;       --no concatenation with X"000" -> already implemented in RISCV.vhd execute case
       Reg(rd) := bit_vector(temp);
        
    end procedure XORI_exec;
    
    procedure ORI_exec(rs1, rd : RegAddrType; imm : Immtype; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is
    variable temp : RegDataType;
    begin
       temp := Reg(rs1) or imm;
       Reg(rd) := bit_vector(temp);
        
    end procedure ORI_exec;
    
    
    procedure ANDI_exec(rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is
    variable temp : RegDatatype;
    begin
        
        temp := Reg(rs1) and imm;
        Reg(rd) := bit_vector(temp);
    end procedure ANDI_exec;
    
    procedure SLLI_exec(rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is
    variable temp : RegDataType;
    variable shamt : ShamtType := imm(4 downto 0);
    begin
        temp := reg(rs1) sll to_integer(unsigned(shamt));
        reg(rd) := temp;
    end procedure SLLI_exec;
    
    
    
    procedure SRLI_exec(rs1, rd : RegAddrType; imm : Immtype; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is
    variable temp : RegDataType;
    variable shamt : ShamtType := imm(4 downto 0);
    begin
        temp := reg(rs1) srl to_integer(unsigned(shamt));
        reg(rd) := temp;
    end procedure SRLI_exec;
    
    
    procedure SRAI_exec(rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is
    variable shamt : ShamtType := imm(4 downto 0);
    variable rs1_temp : RegDataType := bit_vector(reg(rs1));
    variable temp : RegDataType;
    variable msb : bit_vector(0 downto 0);
    variable shift_index : integer := 32 - to_integer(unsigned(shamt));
    begin
        --case 1: shift by 0 places
        if to_integer(unsigned(shamt)) = 0 then
            reg(rd) := reg(rs1);
        --case 2: shift by >= 1 bits
        else
        msb(0) := rs1_temp(31);
        temp := rs1_temp srl to_integer(unsigned(shamt));
        temp(31 downto shift_index ) := (others => msb(0));
        reg(rd) := temp; 
        end if;
         
    end procedure SRAI_exec;
    
    procedure SLTI_exec(rs1, rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is
    variable rs1_buff : RegDataType := reg(rs1);
    begin
        if to_integer(signed(rs1_buff)) < to_integer(signed(imm)) then
            reg(rd) := bit_vector(to_unsigned(1, 32));
        else
            reg(rd) := bit_vector(to_unsigned(0, 32));
        end if;
        
    end procedure SLTI_exec;
    
    procedure SLTIU_exec(rs1, rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout MemAddrType) is
    variable rs1_buff : RegDataType := reg(rs1);
    begin
        if to_integer(unsigned(rs1_buff)) < to_integer(unsigned(imm)) then
            reg(rd) := bit_vector(to_unsigned(1, 32));
        else
            reg(rd) := bit_vector(to_unsigned(0, 32));
        end if;
    end procedure SLTIU_exec;   
    
    
    ---------------------------------------
    
    
end package body exec_procedures_pack;