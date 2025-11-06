library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_BIT.ALL;
library work;
use work.exec_procedures_pack.all;

package body exec_procedures_pack is

-- ERSTELLT VON JEONGJOO LIM; Teil Orange; LB LBU LH LHU LW SB SH SW ADD SUB ADDI
    procedure LB_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
    
    procedure LBU_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
    
    procedure LH_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
    
    procedure LHU_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
    end procedure;
    
    procedure LW_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
    begin
        
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
    begin
        Reg(rd) := bit_vector(signed(Reg(rs1)) + signed(Reg(rs2)));
    end procedure;
    
    procedure SUB_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType) is
    begin
        Reg(rd) := bit_vector(signed(Reg(rs1)) - signed(Reg(rs2)));
    end procedure;
    
    procedure ADDI_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType) is
    begin
        --Reg(rd) := bit_vector(signed(Reg(rs1)) + signed((31 downto 12 => imm(11)) & imm ));
    end procedure;
    
    

end package body exec_procedures_pack;