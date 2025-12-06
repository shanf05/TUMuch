-- erstellt von severin hanf
library work; 
use work.defs_pack.all;

entity ctrl_pc is
    Port(
        data_out : out bit_vector (AddrSize-1 downto 0);
        data_in  : in  bit_vector (AddrSize-1 downto 0); 
        enable   : in  bit
    );
end ctrl_pc;

architecture rtl of ctrl_pc is
begin
    process(data_in, enable)         
    begin
        if enable = '1' then 
            data_out <= data_in;
        end if; 
    end process;
end rtl;