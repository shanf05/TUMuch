-- ERSTELLT VON JOSIP PEPIC

entity RAM4096x12_TLE is
end RAM4096x12_TLE;

architecture Behavioral of RAM4096x12_TLE is
    component RAM4096x12 is
        port (  w_en : in bit;
                addr : in bit_vector( 11 downto 0 );
                data_in : in bit_vector( 11 downto 0 );
                data_out: out bit_vector( 11 downto 0 )
        );
    end component;
    
    component RAM4096x12_Testbench is
        port (  w_en         : out bit; 
                addr         : out bit_vector( 11 downto 0 ); 
                dataToMem    : out bit_vector( 11 downto 0 );
                dataFromMem1 : in  bit_vector( 11 downto 0 ); 
                dataFromMem2 : in  bit_vector( 11 downto 0 ) 
        );
    end component;

    signal w_en_sig : bit;
    signal addr_sig, dataToMem_sig, dataFromMem1_sig, dataFromMem2_sig: bit_vector (11 downto 0); 
begin
    TB: RAM4096x12_Testbench
            port map(w_en => w_en_sig, addr => addr_sig, dataToMem => dataToMem_sig,
                    dataFromMem1 => dataFromMem1_sig, dataFromMem2 => dataFromMem2_sig);
                 
    UUT1: RAM4096x12
            port map(w_en => w_en_sig, addr => addr_sig, data_in => dataToMem_sig,
                    data_out => dataFromMem1_sig);
                    
    UUT2: RAM4096x12
            port map(w_en => w_en_sig, addr => addr_sig, data_in => dataToMem_sig,
                    data_out => dataFromMem2_sig);
end Behavioral;

configuration RAM4096x12_TLE_CONF of RAM4096x12_TLE is
    for Behavioral
        for TB: RAM4096x12_Testbench use entity work.RAM4096x12_Testbench(Behavorial);
        end for;
        for UUT1: RAM4096x12 use entity work.RAM4096x12(Behavioral_BitVector);
        end for;
        for UUT2: RAM4096x12 use entity work.RAM4096x12(Behavioral_Integer);
        end for;
    end for;
end configuration;