library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_BIT.ALL;
library work;
use work.exec_procedures_pack.all; 
use work.defs_pack.all; 

package body exec_procedures_pack is   

    procedure LB_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable memAddr: MemAddrType;
    begin
        memAddr := to_integer(unsigned(Reg(rs1))) + to_integer(signed(imm))/4; -- word address
                
        case to_integer(signed(imm)) mod 4 is
            when 0 =>
                Reg(rd)(7 downto 0)  := Mem(memAddr)(7 downto 0);     
                Reg(rd)(31 downto 8) := (others =>  Mem(memAddr)(7)); --signed extension o upper 24 bits
            when 1 => 
                Reg(rd)(7 downto 0)  := Mem(memAddr)(15 downto 8);     
                Reg(rd)(31 downto 8) := (others =>  Mem(memAddr)(15)); --signed extension o upper 24 bits
            when 2 => 
                Reg(rd)(7 downto 0)  := Mem(memAddr)(23 downto 16);
                Reg(rd)(31 downto 8) := (others =>  Mem(memAddr)(23)); --signed extension o upper 24 bits
            when 3 => 
                Reg(rd)(7 downto 0)  := Mem(memAddr)(31 downto 24);     
                Reg(rd)(31 downto 8) := (others =>  Mem(memAddr)(31)); --signed extension o upper 24 bits
            when others => NULL;
        end case;
        IncrementPc(pc);
    end procedure;
    
    procedure LBU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable memAddr: MemAddrType;
    begin
        memAddr := to_integer(unsigned(Reg(rs1))) + to_integer(signed(imm))/4; -- word address
            
        case to_integer(signed(imm)) mod 4 is
            when 0 => 
                Reg(rd)(7 downto 0)  := Mem(memAddr)(7 downto 0);     
                Reg(rd)(31 downto 8) := (others =>  '0'); --unsigned extension o upper 24 bits
            when 1 => 
                Reg(rd)(7 downto 0)  := Mem(memAddr)(15 downto 8);     
                Reg(rd)(31 downto 8) := (others =>  '0'); --unsigned extension o upper 24 bits        
            when 2 => 
                Reg(rd)(7 downto 0)  := Mem(memAddr)(23 downto 16);
                Reg(rd)(31 downto 8) := (others =>  '0'); --unsigned extension o upper 24 bits
            when 3 => 
                Reg(rd)(7 downto 0)  := Mem(memAddr)(31 downto 24);     
                Reg(rd)(31 downto 8) := (others =>  '0'); --unsigned extension o upper 24 bits
            when others => NULL;
        end case;
        IncrementPc(pc);
    end procedure;
    
    procedure LH_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable memAddr: MemAddrType;
    begin
        memAddr := to_integer(unsigned(Reg(rs1))) + to_integer(signed(imm))/4; -- word address
        
        case to_integer(signed(imm)) mod 4 is
            when 0 => 
                Reg(rd)(15 downto 0)  := Mem(memAddr)(15 downto 0);     
                Reg(rd)(31 downto 16) := (others=>Mem(memAddr)(15)); --signed extension o upper 16 bits
            when 2 => 
                Reg(rd)(15 downto 0)  := Mem(memAddr)(31 downto 16);
                Reg(rd)(31 downto 16) := (others=>Mem(memAddr)(31)); --signed extension o upper 16 bits
            when others =>
                assert(false);
                report "Invalid offset -- LH_exec"
                severity warning;            
        end case;
        IncrementPc(pc);
    end procedure;
        
    procedure LHU_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable memAddr: MemAddrType;
    begin
        memAddr := to_integer(unsigned(Reg(rs1))) + to_integer(signed(imm))/4; -- word address
                 
        case to_integer(signed(imm)) mod 4 is
            when 0 => Reg(rd) := "0000000000000000" & Mem(memAddr)(15 downto 0);    --unsigned extension o upper 16 bits    
            when 2 => Reg(rd) := "0000000000000000" & Mem(memAddr)(31 downto 16);   --unsigned extension o upper 16 bits
            when others =>
                assert(false);
                report "Invalid offset -- LHU_exec"
                severity warning;            
        end case;
        IncrementPc(pc);
    end procedure;
    
    procedure LW_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable memAddr: MemAddrType;
    begin
        memAddr := to_integer(unsigned(Reg(rs1))) + to_integer(signed(imm))/4; -- word address
        
    	case to_integer(signed(imm)) mod 4 is
    	    when 0 => Reg(rd) := Mem(memAddr);
    	    when others =>
                assert(false);
                report "Invalid offset -- LW_exec"
                severity warning;            
    	end case;    	              
        IncrementPc(pc);
    end procedure;
    
    procedure SB_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable memAddr: MemAddrType;
    begin
        memAddr := to_integer(unsigned(Reg(rs1))) + to_integer(signed(imm))/4; -- word address
        
    	case to_integer(signed(imm)) mod 4 is
            when 0 => Mem(memAddr)(7 downto 0)      := Reg(rs2)(7 downto 0);
            when 1 => Mem(memAddr)(15 downto 8)     := Reg(rs2)(7 downto 0);
            when 2 => Mem(memAddr)(23 downto 16)    := Reg(rs2)(7 downto 0);
            when 3 => Mem(memAddr)(31 downto 24)    := Reg(rs2)(7 downto 0);
            when others => 
                assert(false); 
                report "Invalid offset -- SB_exec"
                severity warning;
        end case;
        IncrementPc(pc);
    end procedure;
    
    procedure SH_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable memAddr: MemAddrType;
    begin
        memAddr := to_integer(unsigned(Reg(rs1))) + to_integer(signed(imm))/4; -- word address
        
    	case to_integer(signed(imm)) mod 4 is
            when 0 => Mem(memAddr)(15 downto 0)     := Reg(rs2)(15 downto 0);        
            when 2 => Mem(memAddr)(31 downto 16)    := Reg(rs2)(15 downto 0);        
            when others => 
                assert(false); 
                report "Invalid offset -- SH_exec"
                severity warning;
        end case;
        IncrementPc(pc);       
    end procedure;
    
    procedure SW_exec (rs1, rs2 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable memAddr: MemAddrType;
    begin
        memAddr := to_integer(unsigned(Reg(rs1))) + to_integer(signed(imm))/4; -- word address
        
    	case to_integer(signed(imm)) mod 4 is
    	    when 0 => Mem(memAddr) := Reg(rs2);
    	    when others =>
                assert(false);
                report "Invalid offset -- LW_exec"
                severity warning;            
    	end case;    	       
        IncrementPc(pc);
    end procedure;
    
    procedure ADD_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        temp := signed(Reg(rs1)) + signed(Reg(rs2));
        Reg(rd) := bit_vector(temp);
        IncrementPc(pc);
    end procedure;
    
    procedure SUB_exec (rd, rs1, rs2 : RegAddrType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        temp := signed(Reg(rs1)) - signed(Reg(rs2));
        Reg(rd) := bit_vector(temp);
        IncrementPc(pc);
    end procedure;
    
    procedure ADDI_exec (rd, rs1 : RegAddrType; imm : ImmType; Reg : inout RegType; Mem : inout MemType; pc : inout PCType) is   --ERSTELLT VON JEONGJOO LIM
        variable temp : signed(RegDataSize-1 downto 0);
    begin
        temp := signed(Reg(rs1)) + signed(imm);
        Reg(rd) := bit_vector(temp);
        IncrementPc(pc);
    end procedure;    
    
    procedure JAL_exec  (rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is --erstellt von Severin Hanf 
    begin    
        reg(rd) := bit_vector(to_unsigned((pc + 4),32)); --store the return address in rd
        pc := pc + to_integer(signed(imm));             --jump to the new address                       
    end procedure;              
    
    procedure JALR_exec (rs1, rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is --erstellt von Severin Hanf
    variable jumpAddress : PcType;    
    begin
        reg(rd) := bit_vector(to_unsigned((pc+4),32));                           --store the return address        
        jumpAddress := to_integer(unsigned(reg(rs1))) + to_integer(signed(imm)); --get the jump address
        jumpAddress := (jumpAddress / 2) * 2;                                    --set lowest bit to zero
        pc := jumpAddress;                                                       --jump to the new address
    end procedure; 
    
    procedure BEQ_exec (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is --erstellt von Severin Hanf    
    variable offset : PcType;
    begin
        if(reg(rs1) = reg(rs2)) then 
            offset := to_integer(signed(imm(12 downto 1))); --branch, because equal
        else 
            offset := 4;                                    --no branch, because not equal
        end if; 
        pc := pc + offset;                                                      
    end procedure;
    
    procedure BNE_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is --erstellt von Severin Hanf    
    variable offset : PcType;
    begin
        if(reg(rs1) /= reg(rs2)) then 
            offset := to_integer(signed(imm(12 downto 1))); --branch, because not equal
        else 
            offset := 4;                                    --no branch, because equal
        end if; 
        pc := pc + offset;                                                      
    end procedure;
    
    procedure BLT_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is --erstellt von Severin Hanf    
    variable offset : PcType;
    begin
        if(signed(reg(rs1)) < signed(reg(rs2))) then 
            offset := to_integer(signed(imm(12 downto 1))); --branch, because rs1 < rs2
        else 
            offset := 4;                                    --no branch
        end if; 
        pc := pc + offset;                                                      
    end procedure;
    
    procedure BGE_exec  (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is --erstellt von Severin Hanf    
    variable offset : PcType;
    begin
        if(signed(reg(rs1)) >= signed(reg(rs2))) then 
            offset := to_integer(signed(imm(12 downto 1))); --branch, because rs1 >= rs2
        else 
            offset := 4;                                    --no branch
        end if; 
        pc := pc + offset;                                                      
    end procedure;
    
    procedure BLTU_exec (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is --erstellt von Severin Hanf    
    variable offset : PcType;
    begin
        if(unsigned(reg(rs1)) < unsigned(reg(rs2))) then
            offset := to_integer(signed(imm(12 downto 1))); --branch, because rs1 < rs2
        else 
            offset := 4;                                   --no branch
        end if; 
        pc := pc + offset;                                                      
    end procedure;
    
    procedure BGEU_exec (rs1, rs2 : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is --erstellt von Severin Hanf    
    variable offset : PcType;
    begin
        if(unsigned(reg(rs1)) >= unsigned(reg(rs2))) then 
            offset := to_integer(signed(imm(12 downto 1))); --branch, because rs1 >= rs2
        else 
            offset := 4;                                    --no branch
        end if; 
        pc := pc + offset;
    end procedure;

     procedure LUI_exec(rd : RegAddrType; imm : ImmType; mem : inout MemType; Reg : inout RegType; pc : inout PCType) is    --erstellt von Max Biricz
    begin
        Reg(rd) := imm;             --no concatenation with X"000" -> already implemented in RISCV.vhd execute case
        IncrementPc(pc);
    end procedure LUI_exec;
    
    procedure AUIPC_exec(rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is    --erstellt von Max Biricz
    begin
        Reg(rd) := bit_vector(to_unsigned(pc + to_integer(signed(imm)), 32));
        IncrementPc(pc);
    end procedure AUIPC_exec;    
    
    procedure XORI_exec(rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is   --erstellt von Max Biricz
    variable temp : RegDatatype;
    begin
        temp := Reg(rs1) xor imm;       --no concatenation with X"000" -> already implemented in RISCV.vhd execute case
        Reg(rd) := bit_vector(temp);
        IncrementPc(pc);
    end procedure XORI_exec;
    
    procedure ORI_exec(rs1, rd : RegAddrType; imm : Immtype; mem : inout MemType; reg : inout RegType; pc : inout PCType) is    --erstellt von Max Biricz
    variable temp : RegDataType;
    begin
        temp := Reg(rs1) or imm;
        Reg(rd) := bit_vector(temp);
        IncrementPc(pc);
    end procedure ORI_exec;    
    
    procedure ANDI_exec(rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is    --erstellt von Max Biricz
    variable temp : RegDatatype;
    begin
        temp := Reg(rs1) and imm;
        Reg(rd) := bit_vector(temp);
        IncrementPc(pc);
    end procedure ANDI_exec;
    
    procedure SLLI_exec(rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is    --erstellt von Max Biricz
    variable temp : RegDataType;
    variable shamt : ShamtType := imm(4 downto 0);
    begin
        temp := reg(rs1) sll to_integer(unsigned(shamt));
        reg(rd) := temp;
        IncrementPc(pc);
    end procedure SLLI_exec;
    
    procedure SRLI_exec(rs1, rd : RegAddrType; imm : Immtype; mem : inout MemType; reg : inout RegType; pc : inout PCType) is    --erstellt von Max Biricz
    variable temp : RegDataType;
    variable shamt : ShamtType := imm(4 downto 0);
    begin
        temp := reg(rs1) srl to_integer(unsigned(shamt));
        reg(rd) := temp;
        IncrementPc(pc);
    end procedure SRLI_exec;
    
    
    procedure SRAI_exec(rs1, rd : RegAddrType; imm : ImmType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is   --erstellt von Max Biricz
    variable shamt : ShamtType := imm(4 downto 0);
    variable shift_index : integer := to_integer(unsigned(shamt));
    begin
        reg(rd) := reg(rs1) sra shift_index;
        IncrementPc(pc);
    end procedure SRAI_exec;
    
    procedure SLTI_exec(rs1, rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is   --erstellt von Max Biricz
    variable rs1_buff : RegDataType := reg(rs1);
    begin
        if to_integer(signed(rs1_buff)) < to_integer(signed(imm)) then
            reg(rd) := bit_vector(to_unsigned(1, 32));
        else
            reg(rd) := bit_vector(to_unsigned(0, 32));
        end if;
        IncrementPc(pc);
    end procedure SLTI_exec;
    
    procedure SLTIU_exec(rs1, rd : RegAddrType; imm : RegDataType; mem : inout MemType; reg : inout RegType; pc : inout PCType) is   --erstellt von Max Biricz
    variable rs1_buff : RegDataType := reg(rs1);
    begin
        if to_integer(unsigned(rs1_buff)) < to_integer(unsigned(imm)) then
            reg(rd) := bit_vector(to_unsigned(1, 32));
        else
            reg(rd) := bit_vector(to_unsigned(0, 32));
        end if;
        IncrementPc(pc);
    end procedure SLTIU_exec;
    
    procedure STOP_exec is --erstellt von Max Biricz
    begin
        report "End of programm reached -- Stopping execution";
        wait;
    end procedure STOP_exec;      
    
    procedure XOR_exec(rd, rs1, rs2 : RegAddrType; reg : inout RegType; pc : inout PCType) is -- ERSTELLT VON JOSIP PEPIC 
    begin 
        reg(rd) := reg(rs1) xor reg(rs2);
        IncrementPc(pc);
    end procedure; 
    
    procedure OR_exec(rd, rs1, rs2 : RegAddrType; reg : inout RegType; pc : inout PCType) is -- ERSTELLT VON JOSIP PEPIC
    begin 
        reg(rd) := reg(rs1) or reg(rs2);
        IncrementPc(pc);
    end procedure; 
    
    procedure AND_exec(rd, rs1, rs2 : RegAddrType; reg : inout RegType; pc : inout PCType) is  -- ERSTELLT VON JOSIP PEPIC
    begin 
        reg(rd) := reg(rs1) and reg(rs2);
        IncrementPc(pc);
    end procedure; 
    
    procedure SLL_exec(rd, rs1, rs2 : RegAddrType; reg : inout RegType; pc : inout PCType) is -- ERSTELLT VON JOSIP PEPIC
        variable shift_amount : integer; 
    begin 
        shift_amount := to_integer(unsigned(reg(rs2))); 
        reg(rd) := reg(rs1) sll shift_amount;
        IncrementPc(pc);
    end procedure; 
    
    procedure SRL_exec(rd, rs1, rs2 : RegAddrType; reg : inout RegType; pc : inout PCType) is -- ERSTELLT VON JOSIP PEPIC
        variable shift_amount : integer; 
    begin 
        shift_amount := to_integer(unsigned(reg(rs2))); 
        reg(rd) := reg(rs1) srl shift_amount;
        IncrementPc(pc);
    end procedure; 
    
    procedure SRA_exec(rd, rs1, rs2 : RegAddrType; reg : inout RegType; pc : inout PCType) is -- ERSTELLT VON JOSIP PEPIC
        variable shift_amount : integer; 
    begin 
        shift_amount := to_integer(unsigned(reg(rs2))); 
        reg(rd) := reg(rs1) sra shift_amount;
        IncrementPc(pc);
    end procedure; 
    
    procedure SLT_exec(rd, rs1, rs2 : RegAddrType; reg : inout RegType; pc : inout PCType) is -- ERSTELLT VON JOSIP PEPIC
    begin 
        if (signed(reg(rs1)) < signed(reg(rs2))) then 
            reg(rd) := bit_vector(to_signed(1, 32)); 
        else 
            reg(rd) := bit_vector(to_signed(0, 32)); 
        end if;
        IncrementPc(pc);
    end procedure; 
    
    procedure SLTU_exec(rd, rs1, rs2 : RegAddrType; reg : inout RegType; pc : inout PCType) is -- ERSTELLT VON JOSIP PEPIC
    begin 
        if (unsigned(reg(rs1)) < unsigned(reg(rs2))) then 
            reg(rd) := bit_vector(to_signed(1, 32)); 
        else 
            reg(rd) := bit_vector(to_signed(0, 32));
        end if;        
        IncrementPc(pc);
    end procedure;
    
end package body exec_procedures_pack;