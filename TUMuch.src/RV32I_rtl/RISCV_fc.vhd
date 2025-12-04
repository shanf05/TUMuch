-- ERSTELLT VON JEONGJOO LIM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.defs_pack.all;

entity FC is
    port ( 
        ALU_RES :   in BusDataType;
        D_IN:       in BusDataType;
        FC_SEL :    in bit; 
        
        FLAG_IN :   out bit_vector(3 downto 0);
        RF_IN :     out BusDataType
    );
end FC;

architecture RTL of FC is
    signal MUX_INPUT : bit_vector(2*BusDataSize-1 downto 0) := (others => '0');
    signal MUX_SEL : integer range 0 to 1 := 0;
begin
    -- not cmd_calc, so ALU_RES when 0, D_IN when 1 
    MUX_INPUT <= ALU_RES & D_IN; 
    MUX_SEL <= 1 when FC_SEL = '1' else 0;
    
    mux32x2 : entity work.mux generic map(ports=>2) port map(input => MUX_INPUT, output => RF_IN, sel => MUX_SEL);
    
end RTL;
