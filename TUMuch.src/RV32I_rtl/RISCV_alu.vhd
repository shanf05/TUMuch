-- erstellt von Severin Hanf 
library work; 
use work.defs_pack.all; 

entity alu32 is
    Port( 
        operand_a, operand_b : in  BusDataType; 
        operation            : in  bit_vector (2 downto 0); 
        result               : out BusDataType    
    );
end alu32;

-- Operation codes coming from instruction decoder: 
--      xor(i)      000
--      or(i)       001
--      and(i)      010
--      add(i)      011
--      sub(i)      100
--      sll(i)      101
--      srl(i)      110
--      sra(i)      111

architecture rtl of alu32 is
    --cmp32    : entity work.cmp32 port map(...);
    --and32    : entity work.and32 port map(...);
    --or32     : entity work.or32 port map(...);
    --xor32    : entity work.xor32 port map(...);
    --addsub32 : entity work.addsub port map(...);
    --shiter32 : entity work.shifter32 port map(...);
    --mux32    : entity work.mux port map(..);    
    
    -- adder: 
    signal o_mode_sig : bit := '0';     -- 0 <=> add, 1 <=> sub
    signal res_addsub_sig : BusDataType := (others=>'0'); 
    
    --shifter: 
    signal dir_sig         : bit := '0'; -- 0 <=> left, 1 <=> right
    signal arith_sig       : bit := '0'; -- 0 <=> off, 1 <=> on
    signal res_shifter_sig : BusDataType := (others=>'0');         
    signal res_and_sig     : BusDataType := (others=>'0');
    signal res_or_sig      : BusDataType := (others=>'0');
    signal res_xor_sig     : BusDataType := (others=>'0');
        
begin    
    addsub32  : entity work.addsub    port map(o_mode=>o_mode_sig, a=>operand_a, b=>operand_b, d_out=>res_addsub_sig);
    shifter32 : entity work.shifter32 port map(data_in=>operand_a, direction=>dir_sig, arithmetic=>arith_sig, shamt=>operand_b(4 downto 0), data_out=>res_shifter_sig);
    and32     : entity work.and32     port map(x1=>operand_a, x2=>operand_b, y=>res_and_sig); 
    or32      : entity work.or32      port map(x1=>operand_a, x2=>operand_b, y=>res_or_sig); 
    xor32     : entity work.xor32     port map(x1=>operand_a, x2=>operand_b, y=>res_xor_sig);    
    --mux32x5   : entity work.mux       port map(in_1=>res_addsub_sig, in_2=>res_shifter_sig, in_3=>res_and_sig in_4=>res_or_sig, in_5=>res_xor_sig, out=>result, sel=>operation);
    process(operation, operand_a, operand_b)
    begin
        case operation is    
        when "000" =>   --xor(i)
            o_mode_sig <= '0';  -- prevent latches 
            dir_sig    <= '0';  -- prevent latches
            arith_sig  <= '0';  -- prevent latches                
        when "001" =>   --or(i)
            o_mode_sig <= '0';  -- prevent latches 
            dir_sig    <= '0';  -- prevent latches
            arith_sig  <= '0';  -- prevent latches        
        when "010" =>   --and(i)
            o_mode_sig <= '0';  -- prevent latches 
            dir_sig    <= '0';  -- prevent latches
            arith_sig  <= '0';  -- prevent latches                
        when "011" =>   --add(i)
            o_mode_sig <= '0';
            dir_sig    <= '0';  -- prevent latches
            arith_sig  <= '0';  -- prevent latches        
        when "100" =>   --sub
            o_mode_sig <= '1';
            dir_sig    <= '0';  -- prevent latches
            arith_sig  <= '0';  -- prevent latches        
        when "101" =>   --sll(i)
            o_mode_sig <= '0';  -- prevent latches
            dir_sig    <= '0'; 
            arith_sig  <= '0';        
        when "110" =>   --srl(i)
            o_mode_sig <= '0';  -- prevent latches
            dir_sig    <= '1';
            arith_sig  <= '0';         
        when "111" =>   --sra(i)
            o_mode_sig <= '0';  -- prevent latches
            dir_sig    <= '1';
            arith_sig  <= '1';
        end case;
    end process; 
end rtl;