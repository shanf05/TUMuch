-- ERSTELLT VON JEONGJOO LIM
-- Specifications: 32bit wide Memory, 16 bit Address

package defs_pack is
    constant data_width : natural := 32;
    
    -------- OBJECT SIZES --------    
    -- memory sizes    
    constant MemAddrSize : integer := 16; -- untersten 2 bit für Byte adressierung
    
    -- instruction size
    constant InstrSize : integer := 32; -- Achtung: hier weicht von Folie ab! wahrscheinlich Schreibfehler
    
    -- data wire of bus, memory width
    constant BusDataSize : integer := 32;
    
    -- register sizes
    constant RegDataSize : integer := 32;
    constant RegAddrSize : integer := 5;
        
    -------- OBJECT TYPES --------    
    subtype InstrType       is bit_vector (InstrSize-1 downto 0);
    subtype BusDataType     is bit_vector (BusDataSize-1 downto 0);
    subtype RegDataType     is bit_vector (RegDataSize-1 downto 0);
    subtype MemDataType     is bit_vector (RegDataSize-1 downto 0);
    subtype RegAddrType    is integer range 2**RegAddrSize-1 downto 0; -- added by Severin Hanf
    subtype MemAddrType    is integer range 2**MemAddrSize-1 downto 0; -- added by Severin Hanf
    type    RegType         is array (RegAddrType) of RegDataType;
    type    MemType         is array (MemAddrType) of BusDataType;    
    
    -------- INSTR. COMP. SIZES -------- 
    -- to be implemented during fetch 
    subtype ImmType         is bit_vector (RegDataSize-1 downto 0);
end;