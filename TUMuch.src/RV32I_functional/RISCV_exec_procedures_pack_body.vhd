library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_BIT.ALL;
library work;
use work.exec_procedures_pack.all;

package body exec_procedures_pack is

-- ERSTELLT VON JEONGJOO LIM; Teil Orange; LB LBU LH LHU LW SB SH SW ADD SUB ADDI
    procedure LB_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
    
    procedure LBU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
    
    procedure LH_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
        
    procedure LHU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
    
    procedure LW_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        case rs1 mod 4 is
            when 0 => 
                case to_integer(signed(imm)) is
                    when 0 => Reg(rs1) := Mem(rs1);
                    when others =>
                        assert FALSE
                        report "Illegal Imm -- LW_exec"
                        severity error;
                end case;                 
            when others =>                                  
                assert FALSE
                report "Illegal Address -- LW_exec"
                severity error;
        end case;
    end procedure;
    
    procedure SB_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
    
    procedure SH_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
    
    procedure SW_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
    begin
    
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