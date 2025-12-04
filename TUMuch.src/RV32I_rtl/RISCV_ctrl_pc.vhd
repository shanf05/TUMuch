-- erstellt von severin hanf
library work; 
use work.defs_pack.all;



entity ctrl_pc is
    Port(
        pc    : out bit_vector (AddrSize-1 downto 0);
        pc_in : in  bit_vector (AddrSize-1 downto 0); 
        pc_en : in  bit
    );
end ctrl_pc;

architecture rtl of ctrl_pc is
begin
    process(pc_in, pc_en)         
    begin
        pc <= pc_in when pc_en = '1' else (others=>'0');    -- was ist es wenn nicht aktiv?
    end process;
end rtl;