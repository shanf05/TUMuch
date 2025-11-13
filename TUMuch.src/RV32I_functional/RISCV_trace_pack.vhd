--erstellt von Severin Hanf 
use std.textio.all; 
library work; 
use work.defs_pack.all; 
use work.inst_layout_pack.all;
use work.mnemonic_pack.all;
library ieee;
use IEEE.numeric_bit.all;
package trace_pack is
    procedure print_header(file TraceFile : Text);
    procedure print_tail(file TraceFile : Text);
    procedure write_instruction_trace(l: inout line; reg : RegType; instr : InstrType; pc : PCType);
    function  cmd_image(instr : InstrType) return string;
    function  hex_image_data(data : integer) return string; 
    function  hex_image_addr(addr : integer) return string;   
end package trace_pack; 

package body trace_pack is


    procedure print_header(file TraceFile : Text) is
        variable l : line; 
    begin
        --write program counter
        write( l , string'("PC "));
        write( l , string'(" | ") );
        --write instruction
        write( l , string'(" CMD "));
        write( l , string'(" | ") );
               
        --write registers
        for i in 0 to 31 loop 
            write( l , string'(" x"), left );
            write( l , i , left, 6);
            write( l , string'(" | ") );
        end loop;  
        writeline(TraceFile, l);
    end procedure; 
    
    procedure print_tail(file TraceFile : Text) is
        variable l : line; 
    begin
        --write border
        write(l, string'("---------------------------------------------------------------------"));
        writeline(TraceFile, l);
    end procedure; 
        
    function cmd_image(instr : InstrType) return string is
    begin
        case instr(6 downto 0) is            
            when OP_AUIPC => return AUIPC_mnemonic;
            when OP_LUI   => return LUI_mnemonic;                
            when OP_JAL   => return JAL_mnemonic;
            when OP_JALR  => return JALR_mnemonic;   
            when OP_IMM   => 
                case instr(14 downto 12) is     
                when F3_ADD  => return ADDI_mnemonic;
                when F3_SLT  => return SLTI_mnemonic;
                when F3_SLTU => return SLTIU_mnemonic;
                when F3_AND  => return ANDI_mnemonic;
                when F3_OR   => return ORI_mnemonic;
                when F3_XOR  => return XORI_mnemonic;
                when F3_SLL  => return SLLI_mnemonic;
                when F3_SRL | F3_SRA  => 
                    if    (Instr(31 downto 25) = F7_SRL) then return SRLI_mnemonic;
                    elsif (Instr(31 downto 25) = F7_SRA) then return SRAI_mnemonic;
                    elsif (Instr(31 downto 25) = F7_SLL) then return SLLI_mnemonic;
                    else                                     
                        assert FALSE;
                        return "ERROR";
                    end if;                           
                when others  => 
                    assert FALSE;
                    return "ERROR";
                end case;                                            
            when OP_OP => 
                case instr(14 downto 12) is     
                when F3_ADD  => 
                    if    (Instr(31 downto 25) = F7_ADD) then return ADD_mnemonic;
                    elsif (Instr(31 downto 25) = F7_SUB) then return SUB_mnemonic;
                    else                                      
                        assert FALSE;
                        return "ERROR";
                    end if;
                when F3_SLT  => 
                    if (Instr(31 downto 25) = F7_SLT) then return SLT_mnemonic;                    
                    else
                        assert FALSE;                                   
                        return "ERROR"; 
                    end if;
                when F3_SLTU => 
                    if (Instr(31 downto 25) = F7_SLT) then return SLTU_mnemonic;                    
                    else                                   
                        assert FALSE;
                        return "ERROR"; 
                    end if;
                when F3_AND  => 
                    if (Instr(31 downto 25) = F7_AND) then return AND_mnemonic;                    
                    else                                   
                        assert FALSE;
                        return "ERROR"; 
                    end if; 
                when F3_OR   => 
                    if (Instr(31 downto 25) = F7_OR) then return OR_mnemonic;                    
                    else                                  
                        assert FALSE;
                        return "ERROR"; 
                    end if; 
                when F3_XOR  => 
                    if (Instr(31 downto 25) = F7_XOR) then return XOR_mnemonic;                    
                    else   
                        assert FALSE;                                   
                        return "ERROR"; 
                    end if; 
                when F3_SLL  => 
                    if (Instr(31 downto 25) = F7_SLL) then return SLL_mnemonic;                    
                    else                                   
                        assert FALSE;
                        return "ERROR"; 
                    end if; 
                when F3_SRL  => 
                    if (Instr(31 downto 25) = F7_SRL) then return SRL_mnemonic;                    
                    else                                   
                        assert FALSE;
                        return "ERROR"; 
                    end if; 
                when F3_SRA  =>  
                    if (Instr(31 downto 25) = F7_SRA) then return SRA_mnemonic;                    
                    else                                   
                        assert FALSE;
                        return "ERROR"; 
                    end if;                 
                when others  => 
                    assert FALSE;
                    return "ERROR";
                end case;                  
            when OP_BRANCH => 
                case instr(14 downto 12) is     
                when F3_BEQ  => return BEQ_mnemonic;
                when F3_BNE  => return BNE_mnemonic;
                when F3_BLT  => return BLT_mnemonic;
                when F3_BLTU => return BLTU_mnemonic;
                when F3_BGE  => return BGEU_mnemonic;
                when F3_BGEU => return BGEU_mnemonic;
                when others  => 
                    assert FALSE;
                    return "ERROR";
                end case;
            when OP_LOAD => 
                case instr(14 downto 12) is     
                when F3_LB  => return LB_mnemonic;
                when F3_LBU => return LBU_mnemonic;
                when F3_LH  => return LH_mnemonic;
                when F3_LHU => return LHU_mnemonic;
                when F3_LW  => return LW_mnemonic;
                when others => 
                    assert FALSE;
                    return "ERROR";
                end case;
            when OP_STORE => 
                case instr(14 downto 12) is     
                when F3_SB  => return SB_mnemonic;
                when F3_SH  => return SH_mnemonic;
                when F3_SW  => return SW_mnemonic;                
                when others => 
                    assert FALSE;
                    return "ERROR";     
                end case;        
            when others =>
                assert FALSE;               
                return "ERROR";
        end case;
    end cmd_image; 
    
    function hex_image_data(data : integer) return string is
        constant hex_table : string(1 to 16):= "0123456789ABCDEF";
        variable result : string( 1 to 8 );        
    begin        
        for i in 0 to 7 loop 
            result(8 - i) := hex_table( (data / (16**i)) mod 16 +1);
        end loop; 
        return result;
    end hex_image_data;
    
    function hex_image_addr(addr : integer) return string is
        constant hex_table : string(1 to 16):= "0123456789ABCDEF";
        variable result : string( 1 to 4 );        
    begin        
        result(4):=hex_table(addr mod 16 + 1);
        result(3):=hex_table((addr / 16) mod 16 + 1);
        result(2):=hex_table((addr / 256) mod 16 + 1);
        result(1):=hex_table((addr / 4096) mod 16 + 1);
        return result;
    end hex_image_addr;
    
    procedure write_instruction_trace(l: inout line; reg : RegType; instr : InstrType; pc : PCType) is
    begin 
        --write program counter
        write( l , hex_image_addr(to_integer(unsigned(pc))), left, 3);
        write( l , string'(" | ") );
        
        --write instruction mnemonic
        write( l , cmd_image(instr), left, 5);        
        write( l , string'(" | ") );
        
        --write registers
        for i in 0 to 31 loop 
            write( l , hex_image_data(to_integer(unsigned(reg(i)))) , left, 8);
            write( l , string'(" | ") );
        end loop; 
    end procedure;


end package body trace_pack; 