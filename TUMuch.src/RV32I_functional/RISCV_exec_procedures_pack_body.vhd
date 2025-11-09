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
        if rs1 mod 4 /= 0 then
            report "Address misalignment -- LB_exec"
            severity warning;
        end if;
        
        case (rs1 + to_integer(signed(imm))) mod 4 is
            when 0 => temp := signed(Mem((rs1 + to_integer(signed(imm))) / 4) (7 downto 0));
            when 1 => temp := signed(Mem((rs1 + to_integer(signed(imm))) / 4) (15 downto 8));
            when 2 => temp := signed(Mem((rs1 + to_integer(signed(imm))) / 4) (23 downto 16));
            when 3 => temp := signed(Mem((rs1 + to_integer(signed(imm))) / 4) (31 downto 24));
        end case;
        
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure LBU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : unsigned(RegDataSize-1 downto 0);
    begin
        if rs1 mod 4 /= 0 then
            report "Address misalignment -- LBU_exec"
            severity warning;
        end if;
        
        case (rs1 + to_integer(signed(imm))) mod 4 is
            when 0 => temp := unsigned(Mem((rs1 + to_integer(signed(imm))) / 4) (7 downto 0));
            when 1 => temp := unsigned(Mem((rs1 + to_integer(signed(imm))) / 4) (15 downto 8));
            when 2 => temp := unsigned(Mem((rs1 + to_integer(signed(imm))) / 4) (23 downto 16));
            when 3 => temp := unsigned(Mem((rs1 + to_integer(signed(imm))) / 4) (31 downto 24));
        end case;
        
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure LH_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        if rs1 mod 4 /= 0 then
            report "Address misalignment -- LH_exec"
            severity warning;
        end if;
        
        case (rs1 + to_integer(signed(imm))) mod 4 is
            when 0 => temp := signed(Mem((rs1 + to_integer(signed(imm))) / 4) (15 downto 0));
            when 2 => temp := signed(Mem((rs1 + to_integer(signed(imm))) / 4) (31 downto 16));
            when others =>
                assert FALSE
                report "Illegal Imm -- LH_exec"
                severity error;
        end case;
        
        Reg(rd) := bit_vector(temp);
    end procedure;
        
    procedure LHU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : unsigned(RegDataSize-1 downto 0);
    begin
        if rs1 mod 4 /= 0 then
            report "Address misalignment -- LHU_exec"
            severity warning;
        end if;
        
        case (rs1 + to_integer(signed(imm))) mod 4 is
            when 0 => temp := unsigned(Mem((rs1 + to_integer(signed(imm))) / 4) (15 downto 0));
            when 2 => temp := unsigned(Mem((rs1 + to_integer(signed(imm))) / 4) (31 downto 16));
            when others =>
                assert FALSE
                report "Illegal Imm -- LHU_exec"
                severity error;
        end case;
        
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure LW_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        if rs1 mod 4 /= 0 then
            report "Address misalignment -- LB_exec"
            severity warning;
        end if;
        
        case (rs1 + to_integer(signed(imm))) mod 4 is
            when 0 => temp := signed(Mem((rs1 + to_integer(signed(imm))) / 4));
            when others =>
                assert FALSE
                report "Illegal Imm -- LB_exec"
                severity error;
        end case;
        
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure SB_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        if rs1 mod 4 /= 0 then
            report "Address misalignment -- SB_exec"
            severity warning;
        end if;
        
        case (rs1 + to_integer(signed(imm))) mod 4 is
            when 0 => Mem((rs1 + to_integer(signed(imm))) / 4) (7 downto 0)     := Reg(rs2)(7 downto 0);
            when 1 => Mem((rs1 + to_integer(signed(imm))) / 4) (15 downto 8)    := Reg(rs2)(7 downto 0);
            when 2 => Mem((rs1 + to_integer(signed(imm))) / 4) (23 downto 16)   := Reg(rs2)(7 downto 0);
            when 3 => Mem((rs1 + to_integer(signed(imm))) / 4) (32 downto 24)   := Reg(rs2)(7 downto 0);
        end case;
        
    end procedure;
    
    procedure SH_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        if rs1 mod 4 /= 0 then
            report "Address misalignment -- SH_exec"
            severity warning;
        end if;
        
        case (rs1 + to_integer(signed(imm))) mod 4 is
            when 0 => Mem((rs1 + to_integer(signed(imm))) / 4) (15 downto 0)     := Reg(rs2)(15 downto 0);
            when 2 => Mem((rs1 + to_integer(signed(imm))) / 4) (31 downto 16)   := Reg(rs2)(15 downto 0);
            when others =>
                assert FALSE
                report "Illegal Imm -- SH_exec"
                severity error;
        end case;
        
    end procedure;
    
    procedure SW_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        if rs1 mod 4 /= 0 then
            report "Address misalignment -- SW_exec"
            severity warning;
        end if;
        
        case (rs1 + to_integer(signed(imm))) mod 4 is
            when 0 => Mem((rs1 + to_integer(signed(imm))) / 4) := Reg(rs2);
            when others =>
                assert FALSE
                report "Illegal Imm -- SW_exec"
                severity error;
        end case;
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
        temp := signed(Reg(rs1)) + resize(signed(imm), RegDataSize);
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    

end package body exec_procedures_pack;