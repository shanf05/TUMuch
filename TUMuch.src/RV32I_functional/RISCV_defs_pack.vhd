-- ERSTELLT VON JEONGJOO LIM
-- Specifications:  32 Registers, 32bit wide Memory, 16bit address (14bit for memory, 2bit for byte)
--                  32bit wide instruction
--                  32=2^5 registers, 32bit wide each

package defs_pack is
    constant data_width : natural := 32;
    
    -------- OBJECT SIZES --------    
    -- PC, addr wire of bus, memory depth
    constant AddrSize : integer := 16;
    constant ByteAddrSize : integer := 2;
    constant MemoryAddrSize : integer := AddrSize - ByteAddrSize;
    
    -- instruction size
    constant InstrSize : integer := 32; -- Achtung: hier weicht von Folie ab! wahrscheinlich Schreibfehler
    
    -- data wire of bus, memory width
    constant BusDataSize : integer := 32;
    
    -- register sizes
    constant RegDataSize : integer := 32;
    constant RegAddrSize : integer := 5;
    
    -------- OBJECT TYPES --------    
    subtype AddrType is bit_vector (AddrSize-1 downto 0);
    subtype InstrType is bit_vector (InstrSize-1 downto 0);
    subtype BusDataType is bit_vector (BusDataSize-1 downto 0);
    subtype RegDataType is bit_vector (RegDataSize-1 downto 0);
    type RegType is array (integer range 2**RegAddrSize-1 downto 0) of RegDataType;
    type MemType is array(integer range 2**MemoryAddrSize-1 downto 0) of BusDataType;
    
    -------- INSTR. COMP. SIZES -------- 
    -- to be implemented during fetch 
end;