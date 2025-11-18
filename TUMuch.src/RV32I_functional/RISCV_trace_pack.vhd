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
    procedure write_instr_info(l: inout line; instr : InstrType; pc : PCType; rs1, rs2, rd : RegAddrType);
    procedure write_registers(l: inout line; reg : RegType; imm : ImmType; hasImm : boolean);
    function  cmd_image(instr : InstrType) return string;
    function  hex_image_8(data : bit_vector(31 downto 0)) return string;
    function  hex_image_5(data : bit_vector(31 downto 0)) return string;  
end package trace_pack; 

package body trace_pack is


    procedure print_header(file TraceFile : Text) is
        variable l : line; 
    begin
        --write program counter
        write( l , string'(" PC  "));
        write( l , string'(" | ") );
        
        --write instruction
        write( l , string'(" CMD "));
         write( l , string'(" | ") );
         
        --write registers used in instruction
        write( l, string'("DE S1 S2"));
         write( l , string'(" | ") );
         
        --write parameters
        write( l, string'("  P  "));
               
        --write registers
        for i in 0 to 31 loop 
            write( l , string'(" | ") );
            write( l , string'("   x"), left );
            write( l , i , left, 4);
        end loop;  
        writeline(TraceFile, l);
    end procedure; 
    
    procedure print_tail(file TraceFile : Text) is
        variable l : line; 
        variable tmp : string(1 to 385); 
    begin
        --write border
        tmp := "----------------------------------------------------------------------" &
               "----------------------------------------------------------------------" &
               "----------------------------------------------------------------------" &
               "----------------------------------------------------------------------" &
               "----------------------------------------------------------------------" &
               "-----------------------------------";
        write(l, tmp);
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
            when OP_STOP => return STOP_mnemonic;
            when others =>
                assert FALSE;               
                return "NO_OP";
        end case;
    end function; 
    
    function hex_image_8(data : bit_vector(31 downto 0)) return string is
        constant hex_table : string := "0123456789ABCDEF";
        variable result    : string(1 to 8);
        variable sector    : unsigned(3 downto 0);       
    begin        
        for i in 0 to 7 loop
            -- select 4-bit sector
            sector := unsigned(data(31 - i*4 downto 28 - i*4));
            -- map sector (0-15) to hex char
            result(i+1) := hex_table(to_integer(sector) + 1);
            
            --sector := unsigned(data(3 + i*4 downto i*4));
            -- map sector (0-15) to hex char
            --result(size - i) := hex_table(to_integer(sector) + 1);
            
        end loop;
        return result;        
    end function; 
    
    function hex_image_5(data : bit_vector(31 downto 0)) return string is
        constant hex_table : string := "0123456789ABCDEF";
        variable result    : string(1 to 5);
        variable sector    : unsigned(3 downto 0);       
    begin        
        for i in 0 to 4 loop
            -- select 4-bit sector
            sector := unsigned(data(19 - i*4 downto 16 - i*4));
            -- map sector (0-15) to hex char
            result(i+1) := hex_table(to_integer(sector) + 1);
            
            --sector := unsigned(data(3 + i*4 downto i*4));
            -- map sector (0-15) to hex char
            --result(size - i) := hex_table(to_integer(sector) + 1);
            
        end loop;
        return result;        
    end function; 
    
    
    procedure write_instr_info(l: inout line; instr : InstrType; pc : PCType; rs1, rs2, rd : RegAddrType) is
        variable temp : string(1 to 5);
    begin 
        --write program counter        
        write( l , hex_image_5(bit_vector(to_unsigned(pc, 32))), left);
        write( l , string'(" | ") );
        
        --write instruction mnemonic
        write( l , cmd_image(instr), left, 5);
        write( l , string'(" | ") );
        
        --write used registers
        write( l , rd, left, 2 );
        write( l , string'(" ") );
        write( l , rs1, left, 2 );
        write( l , string'(" ") );
        write( l , rs2, left, 2 );
        write( l , string'(" | ") );
        
    end procedure;
    
    procedure write_registers(l: inout line; reg : RegType; imm : ImmType; hasImm : boolean) is
        variable temp : string(1 to 5);
    begin
        --write immediate
        if hasImm then 
            --temp := hex_image_5(imm,8)(3 to 8);
            --write( l , temp);          --achtung! das hier klappt nicht !!
            write( l ,  hex_image_5(imm));
        else 
            write( l , string'(" --- ") );
        end if;
        
        --write registers
        for i in 0 to 31 loop 
            write( l , string'(" | ") );
            write( l , hex_image_8(reg(i)) , left, 8);            
        end loop; 
    end procedure;
    
    
    

end package body trace_pack; 
