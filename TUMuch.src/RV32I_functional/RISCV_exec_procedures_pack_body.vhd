library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_BIT.ALL;
library work;
use work.exec_procedures_pack.all;

package body exec_procedures_pack is

-- ERSTELLT VON JEONGJOO LIM; Teil Orange; LB LBU LH LHU LW SB SH SW ADD SUB ADDI
    procedure LB_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin        
        temp := signed(Mem(rs1 + to_integer(signed(imm))));        
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure LBU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : unsigned(RegDataSize-1 downto 0);
    begin    
        temp := unsigned(Mem(rs1 + to_integer(signed(imm))));
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure LH_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        if rs1 + to_integer(signed(imm)) mod 2 /= 0 then
            report "Address misalignment -- LH_exec"
            severity warning;
        end if;
        
        temp(31 downto 8)   := signed(Mem(rs1 + to_integer(signed(imm)) + 1));
        temp(7 downto 0)    := signed(Mem(rs1 + to_integer(signed(imm))));
        
        Reg(rd) := bit_vector(temp);
    end procedure;
        
    procedure LHU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : unsigned(RegDataSize-1 downto 0);
    begin
        if rs1 + to_integer(signed(imm)) mod 2 /= 0 then
            report "Address misalignment -- LHU_exec"
            severity warning;
        end if;
        
        temp(31 downto 8)   := unsigned(Mem(rs1 + to_integer(signed(imm)) + 1));
        temp(7 downto 0)    := unsigned(Mem(rs1 + to_integer(signed(imm))));
        
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure LW_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
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
    end procedure;
    
    procedure SB_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        Mem(rs1 + to_integer(signed(imm))) := Reg(rs2)(7 downto 0);
    end procedure;
    
    procedure SH_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        if rs1 + to_integer(signed(imm)) mod 2 /= 0 then
            report "Address misalignment -- SH_exec"
            severity warning;
        end if;
        
        Mem(rs1 + to_integer(signed(imm)) + 1)  := Reg(rs2)(15 downto 8);
        Mem(rs1 + to_integer(signed(imm)))      := Reg(rs2)(7 downto 0);        
    end procedure;
    
    procedure SW_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        if rs1 + to_integer(signed(imm)) mod 4 /= 0 then
            report "Address misalignment -- SW_exec"
            severity warning;
        end if;
        
        Mem(rs1 + to_integer(signed(imm)) + 3)  := Reg(rs2)(31 downto 24);
        Mem(rs1 + to_integer(signed(imm)) + 2)  := Reg(rs2)(23 downto 16);
        Mem(rs1 + to_integer(signed(imm)) + 1)  := Reg(rs2)(15 downto 8);
        Mem(rs1 + to_integer(signed(imm)))      := Reg(rs2)(7 downto 0);
    end procedure;
    
    procedure ADD_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        temp := signed(Reg(rs1)) + signed(Reg(rs2));
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure SUB_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        temp := signed(Reg(rs1)) - signed(Reg(rs2));
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure ADDI_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        temp := signed(Reg(rs1)) + signed(imm);
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    

end package body exec_procedures_pack;