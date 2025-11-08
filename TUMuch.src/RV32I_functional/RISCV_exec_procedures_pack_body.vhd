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
        if rs1 mod 4 = 0 then
            case to_integer(unsigned(imm)) is
                when 0 => temp := signed(Mem(rs1)(7 downto 0));
                when 1 => temp := signed(Mem(rs1)(15 downto 8));
                when 2 => temp := signed(Mem(rs1)(23 downto 16));
                when 3 => temp := signed(Mem(rs1)(31 downto 24));
                when others =>
                    assert FALSE
                    report "Illegal Imm -- LB_exec"
                    severity error;
            end case;
        else
            assert FALSE
            report "Illegal Address -- LB_exec"
            severity error;
        end if;
        
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure LBU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : unsigned(RegDataSize-1 downto 0);
    begin
        if rs1 mod 4 = 0 then
            case to_integer(unsigned(imm)) is
                when 0 => temp := unsigned(Mem(rs1)(7 downto 0));
                when 1 => temp := unsigned(Mem(rs1)(15 downto 8));
                when 2 => temp := unsigned(Mem(rs1)(23 downto 16));
                when 3 => temp := unsigned(Mem(rs1)(31 downto 24));
                when others =>
                    assert FALSE
                    report "Illegal Imm -- LBU_exec"
                    severity error;
            end case;
        else
            assert FALSE
            report "Illegal Address -- LBU_exec"
            severity error;
        end if;
        
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure LH_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        if rs1 mod 4 = 0 then
            case to_integer(unsigned(imm)) is
                when 0 => temp := signed(Mem(rs1)(15 downto 0));
                when 2 => temp := signed(Mem(rs1)(32 downto 16));
                when others =>
                    assert FALSE
                    report "Illegal Imm -- LH_exec"
                    severity error;
            end case;
        else
            assert FALSE
            report "Illegal Address -- LH_exec"
            severity error;
        end if;
        
        Reg(rd) := bit_vector(temp);
    end procedure;
        
    procedure LHU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
        variable temp : unsigned(RegDataSize-1 downto 0);
    begin
        if rs1 mod 4 = 0 then
            case to_integer(unsigned(imm)) is
                when 0 => temp := unsigned(Mem(rs1)(15 downto 0));
                when 2 => temp := unsigned(Mem(rs1)(32 downto 16));
                when others =>
                    assert FALSE
                    report "Illegal Imm -- LHU_exec"
                    severity error;
            end case;
        else
            assert FALSE
            report "Illegal Address -- LHU_exec"
            severity error;
        end if;
        
        Reg(rd) := bit_vector(temp);
    end procedure;
    
    procedure LW_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        if rs1 mod 4 = 0 then
            if to_integer(unsigned(imm)) = 0 then
                Reg(rd) := Mem(rs1);
            else
                assert FALSE
                report "Illegal Imm -- LW_exec"
                severity error;
            end if;
        else
            assert FALSE
            report "Illegal Address -- LW_exec"
            severity error;
        end if;
    end procedure;
    
    procedure SB_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
    
    procedure SH_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
    
    end procedure;
    
    procedure SW_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        if rs1 mod 4 = 0 then
            if to_integer(unsigned(imm)) = 0 then
                Mem(rs1) := Reg(rs2); -- problematsich
            else
                assert FALSE
                report "Illegal Imm -- SW_exec"
                severity error;
            end if;
        else
            assert FALSE
            report "Illegal Address -- SW_exec"
            severity error;
        end if;
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