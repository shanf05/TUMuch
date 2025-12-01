-- erstellt von Severin Hanf 
library work; 
use work.defs_pack.all; 

entity alu32 is
    Port( 
        operand_1, operand_2 : in BusDataType; 
        carry_out            : in bit;
        operation            : in bit_vector (4 downto 0); -- 32 instr differenciated by 5 bit --> is this the cleanest way? 
        result               : out BusDataType    
    );
end alu32;

architecture rtl of alu32 is
    --cmp32    : entity work.cmp32 port map(...);
    --and32    : entity work.and32 port map(...);
    --or32     : entity work.or32 port map(...);
    --xor32    : entity work.xor32 port map(...);
    --addsub32 : entity work.addsub port map(...);
    --shiter32 : entity work.shifter32 port map(...);
    --mux32    : entity work.mux port map(..);    
begin

end rtl;
