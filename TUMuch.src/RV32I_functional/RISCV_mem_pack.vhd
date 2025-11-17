-- erstellt von Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;
use IEEE.numeric_bit.all;
use IEEE.std_logic_textio.all;
library work;
use work.defs_pack.all;
use work.mnemonic_pack.all;
use work.inst_encoding_pack.all;
use work.trace_pack.all;

package mem_pack is

    --function returning memory
    impure function init_memory_asm (file filename : text) return Memtype;
    impure function init_memory_bin (file BinFile : text) return Memtype;
    procedure memory_data_dump (mem : MemType; file DataDumpFile : text);

    --functions for Type conversions from textfile
    function to_MemAddrType (MemAddr : string(1 to 6)) return MemAddrType;
    function to_RegAddrType (Reg : string(1 to 2)) return RegAddrType;
    function to_ImmType (ImmString : string; sign : boolean) return ImmType;

    --auxiliary functions
    function hexstr_to_int (s : string; sign : boolean) return integer;
    function hexchar_to_int (char : character) return integer;

end mem_pack;


package body mem_pack is

    function hexchar_to_int (char : character) return integer is
    variable value : integer := 0;
    begin
        case char is
            when '0' => value := 0;
            when '1' => value := 1;
            when '2' => value := 2;
            when '3' => value := 3;
            when '4' => value := 4;
            when '5' => value := 5;
            when '6' => value := 6;
            when '7' => value := 7;
            when '8' => value := 8;
            when '9' => value := 9;
            when 'A' | 'a' => value := 10;
            when 'B' | 'b' => value := 11;
            when 'C' | 'c' => value := 12;
            when 'D' | 'd' => value := 13;
            when 'E' | 'e' => value := 14;
            when 'F' | 'f' => value := 15;
            when others => assert false report "Invalid Operation -- Invalid Address" severity error;
            end case;
        return value;
    end function hexchar_to_int;

    function hexstr_to_int (s : string; sign : boolean) return integer is
    variable temp : integer := 0;
    variable result : integer := 0;
    variable bits : natural := 4 * s'length;
    begin
        for i in s'range loop
            temp := hexchar_to_int(s(i));
            result := result * 16 + temp;
        end loop;

        if sign then
            if result >= 2**(bits - 1) then
                result := result - 2**bits;
            end if;
        end if;

    return result;

    end function hexstr_to_int;


    function to_MemAddrType (MemAddr : string (1 to 6)) return MemAddrType is
    variable MemAddrString : string (1 to 4) := MemAddr(3 to 6);
    variable MemAddr_dec : MemAddrtype;
    begin
        MemAddr_dec := hexstr_to_int(MemAddrString, false) / 4;                --remove last 2 bits for 14 bit address space
        if (0 <= MemAddr_dec) and (MemAddr_dec <= 2**MemAddrSize-1) then
            return MemAddr_dec;
        else
            assert false
            report "Invalid Operation -- Memory address range: 0 - 16383"
            severity error;
        end if;

    end function to_MemAddrType;


    function to_RegAddrType (Reg : string(1 to 2)) return RegAddrType is
    variable RegAddr_dec : RegAddrType;
    begin
        if Reg(2) = ' ' then    --account for case X1, X2... -> Problem: Whitespace causes runtime error
            RegAddr_dec := RegAddrType'value((1 to 1 => Reg(1)));
        else
            RegAddr_dec := RegAddrType'value(Reg);
        end if;
        if (0 <= RegAddr_dec) and (RegAddr_dec <= 2**RegAddrSize-1) then
            return RegAddr_dec;
        else
            assert false
            report "Invalid Operation -- Register address range: x00 - x31"
            severity error;
        end if;

    end function to_RegAddrType;


    function to_ImmType (ImmString : string; sign : boolean) return ImmType is
        variable Imm_dec : integer;
    begin
        Imm_dec := hexstr_to_int(s => ImmString, sign => sign );
        return bit_vector(to_signed(Imm_dec, RegDataSize));
    end function to_ImmType;

    function Binary_to_data (s : string(1 to 32)) return MemDataType is
        variable data : MemDataType := (others=>'0');
    begin
        for i in 1 to 32 loop
            if s(33 - i) = '0' then
                data(i-1) := '0';
            elsif s(33 - i) = '1' then
                data(i-1) := '1';
            else
                data(i-1) := '0';   --if wrong input use 0
            end if;
        end loop;
        return data;
    end function Binary_to_data;



    impure function init_memory_asm (file filename : text) return MemType is

        variable l : line;                                          --buffer variable to store line of textfile
        variable debug_line : line;
        variable mem : MemType := (others => (others => '0'));      --initialising memory
        variable success : boolean;
        variable index : MemAddrType := 0;                          --index to write at specific address in mem starting at address 0
        variable v : string(1 to 50);                               --buffer variable for reading words in line
        variable rs1, rs2, rd : RegAddrType;
        variable mnemonic : MnemonicType;
        variable imm, data : ImmType;
        variable rs1_set, rd_set, imm_set, mnemonic_set : boolean;
        variable instr : InstrType;

    begin
        --iterate through all lines in file
        line_loop: loop
            exit when endfile(filename);
            readline(filename, l);
            --flags which instruction operands are used
            success:= true;

            --read word from each line
            word_loop: while success loop
                read(l, v(1), success);
                if v(1) = ' ' then null;
                elsif v(1) = '@' then
                    read(l, v(1 to 6), success);
                    index := to_MemAddrType(v(1 to 6));
                    mnemonic := INDEX_mnemonic;
                    mnemonic_set := true;
                    exit word_loop;

                elsif v(1) = '#' then
                    --case 1: 20 Bit data constant
                    if mnemonic = VAL_mnemonic then
                        read(l, v(1 to 5), success);
                        data := to_ImmType(v(1 to 5), true);
                    --case 2: 20 Bit Immediate in Instruction
                    elsif (mnemonic = JAL_mnemonic) or (mnemonic = LUI_mnemonic) or (mnemonic = AUIPC_mnemonic) then
                        read(l, v(1 to 5), success);
                        imm := to_ImmType(v(1 to 5), true);
                        imm_set := true;
                    --case 3: 12 Bit Immediate in Instruction
                    else
                        read(l, v(1 to 3), success);
                        imm := to_ImmType(v(1 to 3), true);
                        imm_set := true;
                    end if;
                    exit word_loop;                 --exit word loop as immediate always comes last in assembly syntax

                elsif (v(1) = 'X') or (v(1) = 'x') then
                    read(l, v(2), success);

                    --case 1: word is instruction XOR/XORI
                    if ((v(2) = 'O') or (v(2) = 'o')) and (mnemonic_set = false) then
                        for i in 3 to 5 loop
                            read(l, v(i), success);
                        end loop;
                        mnemonic := MnemonicType'(v(1 to 5));
                        mnemonic_set := true;
                    --case 2: word is a register
                    else
                        v(1) := v(2);
                        read(l, v(2), success);
                        if rd_set = true then
                            if rs1_set = true then
                                rs2 := to_RegAddrType(v(1 to 2));
                                exit word_loop;
                            else
                                rs1 := to_RegAddrType(v(1 to 2));
                                rs1_set := true;
                            end if;
                        else
                            rd := to_RegAddrType(v(1 to 2));
                            rd_set := true;
                        end if;
                    end if;
                else
                    if mnemonic_set = true then
                        assert false report "Invalid Operation - Mnemonic already set" severity error;
                    else
                        for i in 2 to 5 loop
                            read(l, v(i), success);
                        end loop;
                        mnemonic := MnemonicType'(v(1 to 5));
                        mnemonic_set := true;
                     end if;
                end if;

            end loop;                   --end of word loop

            -- Matching Cmd from Input file to valid mnemonic and returning instruction code
            if mnemonic_set = true then
            -- register-immediate instructions
                if mnemonic = ADDI_mnemonic then instr := ADDI_code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = SLTI_mnemonic then instr := SLTI_code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = SLTIU_mnemonic then instr := SLTIU_code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = ANDI_mnemonic then instr := ANDI_code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = ORI_mnemonic then instr := ORI_code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = XORI_mnemonic then instr := XORI_code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = SLLI_mnemonic then instr := SLLI_code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = SRLI_mnemonic then instr := SRLI_code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = SRAI_mnemonic then instr := SRAI_code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = LUI_mnemonic then instr := LUI_code(rd => rd, imm => imm);

                elsif mnemonic = AUIPC_mnemonic then instr := AUIPC_code(rd => rd, imm => imm);

                --register-register instructions:
                elsif mnemonic = ADD_mnemonic then instr := ADD_code(rs1 => rs1, rs2 => rs2, rd => rd);

                elsif mnemonic = SLT_mnemonic then instr := SLT_code(rs1 => rs1, rs2 => rs2, rd => rd);

                elsif mnemonic = SLTU_mnemonic then instr := SLTU_code(rs1 => rs1, rs2 => rs2, rd => rd);

                elsif mnemonic = AND_mnemonic then instr := AND_code(rs1 => rs1, rs2 => rs2, rd => rd);

                elsif mnemonic = OR_mnemonic then instr := OR_code(rs1 => rs1, rs2 => rs2, rd => rd);

                elsif mnemonic = XOR_mnemonic then instr := XOR_code(rs1 => rs1, rs2 => rs2, rd => rd);

                elsif mnemonic = SLL_mnemonic then instr := SLL_code(rs1 => rs1, rs2 => rs2, rd => rd);

                elsif mnemonic = SRL_mnemonic then instr := SRL_code(rs1 => rs1, rs2 => rs2, rd => rd);

                elsif mnemonic = SUB_mnemonic then instr := SUB_code(rs1 => rs1, rs2 => rs2, rd => rd);

                elsif mnemonic = SRA_mnemonic then instr := SRA_code(rs1 => rs1, rs2 => rs2, rd => rd);

                --NOP-instruction
                elsif mnemonic = NOP_mnemonic then instr := NOP_Code;

                elsif mnemonic = STOP_mnemonic then instr := STOP_Code;

                --unconditional branches: require switching of inputs as reg variables are filled in order (1)rd (2)rs1 (3)rs2
                elsif mnemonic = JAL_mnemonic then instr := JAL_Code(rd => rd, imm => imm);

                elsif mnemonic = JALR_mnemonic then instr := JALR_Code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = BEQ_mnemonic then instr := BEQ_Code(rs1 => rd, rs2 => rs1, imm => imm);

                elsif mnemonic = BNE_mnemonic then instr := BNE_Code(rs1 => rd, rs2 => rs1, imm => imm);

                elsif mnemonic = BLT_mnemonic then instr := BLT_Code(rs1 => rd, rs2 => rs1, imm => imm);

                elsif mnemonic = BLTU_mnemonic then instr := BLTU_Code(rs1 => rd, rs2 => rs1, imm => imm);

                elsif mnemonic = BGE_mnemonic then instr := BGE_Code(rs1 => rd, rs2 => rs1, imm => imm);

                elsif mnemonic = BGEU_mnemonic then instr := BGEU_Code(rs1 => rd, rs2 => rs1, imm => imm);

                --load instructions
                elsif mnemonic = LW_mnemonic then instr := LW_Code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = LH_mnemonic then instr := LH_Code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = LHU_mnemonic then instr := LHU_Code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = LB_mnemonic then instr := LB_Code(rs1 => rs1, rd => rd, imm => imm);

                elsif mnemonic = LBU_mnemonic then instr := LBU_Code(rs1 => rs1, rd => rd, imm => imm);

                --store instructions
                elsif mnemonic = SW_mnemonic then instr := SW_Code(rs1 => rs1, rs2 => rd, imm => imm);

                elsif mnemonic = SH_mnemonic then instr := SH_Code(rs1 => rs1, rs2 => rd, imm => imm);

                elsif mnemonic = SB_mnemonic then instr := SB_Code(rs1 => rs1, rs2 => rd, imm => imm);


                --store data (constants) at specific memory address range @0xF000

                elsif mnemonic = VAL_mnemonic then instr := InstrType(to_signed(to_integer(signed(data)), RegDataSize));

                elsif mnemonic = INDEX_mnemonic then null;

                else assert false report "Invalid Operation -- Unknown Operation" severity error;

                end if;
            else assert false report "Invalid Operation -- No Operation has been detected" severity error; --case: no mnemonic parsed from file
            end if;

            if mnemonic = INDEX_mnemonic then null; -- just keeping addrex index;
            else
                Mem(index) := instr;
                report("Instr output: ");
                write(debug_line, instr);
                writeline(output, debug_line);
                report"Index is:";
                write(debug_line, index);
                writeline(output, debug_line);
            end if;


            if index = 2**MemAddrSize-1 then --arrived at last line address of memory
                report "Last Memory Address reached";
                exit line_loop;
            else
                if mnemonic = INDEX_mnemonic then
                    null;
                else
                    index := index + 1;
                end if;
            end if;
            rd_set := false;
            rs1_set := false;
            imm_set := false;
            mnemonic_set := false;
        end loop;                      --end of line-loop
        return mem;                    --returning memory filled with binary stream for executing instructions
    end function;


    impure function init_memory_bin (file BinFile : text) return MemType is
        variable l : line;
        variable v : string(1 to 32);
        variable success : boolean;
        variable addr : MemAddrType := 0;
        variable mem : MemType := (others=>(others=>'0'));

    begin
        loop
            exit when endfile(BinFile);
            readline(BinFile, l);
            read(l, v(1 to 32), success);
            mem(addr) := Binary_to_data(v(1 to 32));
            report(v(1 to 32));
            addr := addr + 1;
        end loop;
        return mem;                    --returning memory filled with binary stream for executing instructions
    end function;

    procedure memory_data_dump (mem : MemType; file DataDumpFile : text) is         --evtl adresse und größe des dumps auswählba machen
        variable l : line;
    begin
        write( l , string'("ADDR | HEX      | BIN"));
        writeline(DataDumpFile, l);
        write( l , string'("---------------------------------------------------"));
        writeline(DataDumpFile, l);

        for i in 0 to 2**MemAddrSize-1 loop
            write( l , hex_image_addr(i*4) );
            write( l , string'(" | ") );
            write( l , hex_image_data(mem(i)), left, 8);
            write( l , string'(" | ") );
            write( l , to_string(mem(i)) );

            writeline(DataDumpFile, l);
        end loop;
    end procedure;

end mem_pack;

