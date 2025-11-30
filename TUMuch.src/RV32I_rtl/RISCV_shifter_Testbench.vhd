-- created by Severin Hanf
library work; 
use work.defs_pack.all;

entity shifter32_Testbench is
end shifter32_Testbench;

architecture stimul of shifter32_Testbench is
    signal clk        : bit; 
    signal data_in    : BusDataType; 
    signal data_out   : BusDataType;
    signal direction  : bit; 
    signal shamt      : bit_vector (4 downto 0);
    signal arithmetic : bit;
begin
    shiter32_uut : entity work.shifter32 port map(clk=>clk, data_in=>data_in, data_out=>data_out, direction=>direction, shamt=>shamt, arithmetic=>arithmetic);
    
    clkgen : process
    begin
        wait for clkCycle/2;
        clk <= not clk;           
    end process; 
    
    
    inputgen : process
    begin
        data_in <= "11110000111100001010101010101010";
        direction <= '1';  --left
        arithmetic <= '0'; 
        shamt <= "01000";  -- 8 
        wait for clkCycle;
        assert data_out = "11110000101010101010101000000000"
        report "wrong data_out in shift left"
        severity error; 
        
        wait for clkCycle; 
        
        data_in <= "11110000111100001010101010101010";
        direction <= '0';  --right
        arithmetic <= '0'; 
        shamt <= "01000";  -- 8 
        wait for clkCycle; 
        assert data_out = "00000000111100001111000010101010"
        report "wrong data_out in shift right"
        severity error; 
        
        wait;        
    end process; 
    
    
end stimul;
