-- ERSTELLT VON JEONGJOO LIM
-- Specifications: 32bit wide Memory, 16 bit Address

package defs_pack is    
    -- memory  
    constant AddrSize       : integer := 16;
    constant ByteAddrSize   : integer := 2;
    constant MemAddrSize    : integer := AddrSize - ByteAddrSize; -- untersten 2 bit für Byte adressierung
    constant MemDataSize    : integer := 32;
    subtype  MemDataType   is bit_vector (MemDataSize-1 downto 0);
    subtype  MemAddrType   is integer range 2**MemAddrSize-1 downto 0;     --14 Bits für Wortauswahl
    type     MemType       is array (MemAddrType) of MemDataType;
        
    -- registers
    constant RegDataSize  : integer := 32;    
    constant RegAddrSize  : integer := 5;
    subtype  RegDataType is bit_vector (RegDataSize-1 downto 0);
    subtype  RegAddrType is integer range 2**RegAddrSize-1 downto 0;     --5 Bits für Wortauswahl  
    type     RegType     is array (RegAddrType) of RegDataType;
    subtype  ShamtType   is bit_vector (4 downto 0);
    
     -- instructions 
    constant InstrSize  : integer := 32; -- Achtung: hier weicht von Folie ab! wahrscheinlich Schreibfehler
    subtype  InstrType is bit_vector (InstrSize-1 downto 0);
    subtype  ImmType   is bit_vector (RegDataSize-1 downto 0);
    subtype  PcType    is integer range 2**AddrSize-1 downto 0;
    
end; 