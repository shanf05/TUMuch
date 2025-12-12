-- created by Severin Hanf
library work; 
use work.defs_pack.all;

entity shifter32_Testbench is
end shifter32_Testbench;

architecture stimul of shifter32_Testbench is 
    signal data_in    : BusDataType; 
    signal data_out   : BusDataType;
    signal direction  : bit; 
    signal shamt      : bit_vector (4 downto 0);
    signal arithmetic : bit;
begin
    shiter32_uut : entity work.shifter32 port map(data_in=>data_in, data_out=>data_out, direction=>direction, shamt=>shamt, arithmetic=>arithmetic);
        
    inputgen : process
    begin
        data_in <= "11110000111100001010101010101010";
        direction <= '0';  --left
        arithmetic <= '0'; 
        shamt <= "01000";  -- 8 
        
        wait for 0ns;  --force delta cycle
        wait for 0ns;  --force delta cycle
        assert data_out = "11110000101010101010101000000000"
        report "wrong data_out in shift left"
        severity error; 
        
        wait for clkCycle;  --let waveform change
                
        data_in <= "10010110111100001010101010101010";
        direction <= '1';  --right
        arithmetic <= '0'; 
        shamt <= "01000";  -- 8 
        
        wait for 0 ns;  --force delta cycle       
        wait for 0ns;  --force delta cycle 
        assert data_out = "00000000100101101111000010101010"
        report "wrong data_out in shift right 1"
        severity error; 
        
        wait for clkCycle;  --let waveform change
                
        data_in <= "11110000111100001010101010101010";
        direction <= '1';  --right
        arithmetic <= '1'; 
        shamt <= "00011";  -- 3 
        
        wait for 0ns;  --force delta cycle     
        wait for 0ns;  --force delta cycle   
        assert data_out = "11111110000111100001010101010101"
        report "wrong data_out in shift right 2"
        severity error; 
        
        wait;        
    end process; 
    
    
end stimul;
