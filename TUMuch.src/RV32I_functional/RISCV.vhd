library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;
use work.defs_pack.all;
use work.inst_encoding_pack.all;
use work.inst_layout_pack.all;



entity RISCV is
end RISCV;

architecture functional of RISCV is
begin
    process
        variable PC : AddrType := X"0000";
        variable Instr : InstrType := (others=>'0');
        variable Reg : RegType := (others=>(others=>'0'));
        variable Mem: MemType := (others=>(others=>'0'));
    begin
        -- fetch, decode and execute instructions
    end process;
end functional;
