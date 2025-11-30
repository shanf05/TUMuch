library work; 
use work.defs_pack.all; 

entity system is
end;

architecture rtl of system is
    signal clk : bit := '0';
begin
    --ram4096x12 : entity work.ram4096x12 port map(w_en=>w_en, addr=>addr, data_in=>data_in, data_out=>data_out);
    --alu32 : entity work.alu32 port mpa(...)
    --ram4096x32 : entity work.ram4096x12 port map(..);    
    
    clkgen : process
    begin
        wait for clkCycle/2;
        clk <= not clk; 
    end process; 
end;
