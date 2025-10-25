-- ERSTELLT VON JEONGJOO LIM

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;

-- ENTITY DECLARATION
entity RAM4096x12 is 
port(
    w_en : in bit;
    addr : in bit_vector( 11 downto 0 );
    data_in : in bit_vector( 11 downto 0 );
    data_out: out bit_vector( 11 downto 0 )
);
end RAM4096x12;

--ARCHITECTURE BODY (for uut1)
architecture Behavioral_BitVector of RAM4096x12 is
begin
    process( w_en , addr , data_in )
    type mem_type is array
    (bit,bit,bit,bit,bit,bit,
    bit,bit,bit,bit,bit,bit) of
    bit_vector( 11 downto 0 );
    variable Mem : mem_type;
    begin
    -- conditional write
    if w_en = '1' then
        Mem(addr(11),addr(10),addr(9),addr(8),
        addr(7),addr(6),addr(5),addr(4),
        addr(3),addr(2),addr(1),addr(0))
        := data_in;
    end if;
    -- continuous read
    data_out<=Mem(addr(11),addr(10),addr(9),
    addr(8),addr(7),addr(6),
    addr(5),addr(4),addr(3),
    addr(2),addr(1),addr(0));
    end process;
end Behavioral_BitVector;

--Erstellt von Max Biricz
--ARCHITECTURE BODY (for uut2; uut1 and uut2 share same entity)
architecture Behavioral_Integer of RAM4096x12 is
begin
    process(w_en, addr, data_in)
        type mem_type is array
             (natural range 0 to 4095) 
              of bit_vector(11 downto 0);
        variable addr_nat : natural;
        variable Mem : mem_type;
    begin
    
        addr_nat := to_integer(unsigned(addr));
        if w_en = '1' then
            Mem(addr_nat) := data_in;
        end if;
        data_out<=Mem(addr_nat);

    end process;
end Behavioral_Integer;