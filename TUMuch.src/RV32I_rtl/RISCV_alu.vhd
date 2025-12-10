-- erstellt von Severin Hanf und JEONGJOO LIM
library work; 
use work.defs_pack.all; 

entity alu32 is
    Port( 
        operand_a, operand_b : in  BusDataType; 
        operation            : in  bit_vector(3 downto 0);
         
        result               : out BusDataType;
        branch_condition     : out bit
    );
end alu32;

-- Operation codes coming from instruction decoder: 
--      xor(i)      0000     0
--      or(i)       0001     1
--      and(i)      0010     2

--      add(i)      0011     3
--      sub(i)      0100     4

--      sll(i)      0101     5
--      srl(i)      0110     6
--      sra(i)      0111     7

--      slt(i)/blt  1000     8
--      slt(i)u/bltu1001     9
--      BEQ         1010     A
--      BNE         1011     B
--      ---         1100     C
--      BGE         1101     D
--      ----        1110     E
--      BGEU        1111     F

architecture rtl of alu32 is
    -- adder: 
    signal o_mode_sig : bit := '0';     -- 0 <=> add, 1 <=> sub
    signal res_addsub_sig : BusDataType := (others=>'0'); 
    
    --shifter: 
    signal dir_sig         : bit := '0'; -- 0 <=> left, 1 <=> right
    signal arith_sig       : bit := '0'; -- 0 <=> off, 1 <=> on
    signal res_shifter_sig : BusDataType := (others=>'0');
    
    --logic         
    signal res_and_sig     : BusDataType := (others=>'0');
    signal res_or_sig      : BusDataType := (others=>'0');
    signal res_xor_sig     : BusDataType := (others=>'0');
    
    --comparator:
    signal res_comp_sig        : BusDataType := (others=>'0');
    signal comp_is_signed_sig  : bit := '0';
    signal equal_out_sig       : bit := '0';
    
    --mux: 
    signal zero_sig         : BusDataType := (others=>'0'); 
    signal mux_sel_sig      : bit_vector(4 downto 0);
        
begin    
    addsub32  : entity work.addsub    port map(o_mode=>o_mode_sig, a=>operand_a, b=>operand_b, d_out=>res_addsub_sig);
    shifter32 : entity work.shifter32 port map(data_in=>operand_a, direction=>dir_sig, arithmetic=>arith_sig, shamt=>operand_b(4 downto 0), data_out=>res_shifter_sig);
    and32     : entity work.and32     port map(x1=>operand_a, x2=>operand_b, y=>res_and_sig); 
    or32      : entity work.or32      port map(x1=>operand_a, x2=>operand_b, y=>res_or_sig); 
    xor32     : entity work.xor32     port map(x1=>operand_a, x2=>operand_b, y=>res_xor_sig);
    comp32    : entity work.cmp       port map(a =>operand_a, b =>operand_b, is_signed=>comp_is_signed_sig, lt_out=>res_comp_sig, equal_out=>equal_out_sig);
        
    mux32x5   : entity work.mux32x1       
    port map(
        in_0 => res_xor_sig,
        in_1 => res_or_sig,
        in_2 => res_and_sig,
        in_3 => res_addsub_sig,
        in_4 => res_addsub_sig,
        in_5 => res_shifter_sig,
        in_6 => res_shifter_sig,
        in_7 => res_shifter_sig,
        in_8 => res_comp_sig,
        in_9 => res_comp_sig,
        in_10 => res_comp_sig,
        in_11 => res_comp_sig,
        in_12 => zero_sig,
        in_13 => res_comp_sig,
        in_14 => zero_sig,
        in_15 => res_comp_sig,
        in_16 => zero_sig,
        in_17 => zero_sig,
        in_18 => zero_sig,
        in_19 => zero_sig,
        in_20 => zero_sig,
        in_21 => zero_sig,
        in_22 => zero_sig,
        in_23 => zero_sig,
        in_24 => zero_sig,
        in_25 => zero_sig,
        in_26 => zero_sig,
        in_27 => zero_sig,
        in_28 => zero_sig,
        in_29 => zero_sig,
        in_30 => zero_sig,
        in_31 => zero_sig,
        
        output => result, 
        sel => mux_sel_sig
    );
    
    mux_sel_sig <= '0' & operation; --FIX
    
    process(operation, operand_a, operand_b)
    begin
        case operation is    
            when "0000" =>   --xor(i)
                o_mode_sig <= '0';          -- prevent latches 
                dir_sig    <= '0';          -- prevent latches
                arith_sig  <= '0';          -- prevent latches         
                comp_is_signed_sig <= '0';  -- prevent latches       
            when "0001" =>   --or(i)
                o_mode_sig <= '0';          -- prevent latches 
                dir_sig    <= '0';          -- prevent latches
                arith_sig  <= '0';          -- prevent latches        
                comp_is_signed_sig <= '0';  -- prevent latches
            when "0010" =>   --and(i)
                o_mode_sig <= '0';          -- prevent latches 
                dir_sig    <= '0';          -- prevent latches
                arith_sig  <= '0';          -- prevent latches         
                comp_is_signed_sig <= '0';  -- prevent latches       


            when "0011" =>   --add(i)
                o_mode_sig <= '0';
                dir_sig    <= '0';          -- prevent latches
                arith_sig  <= '0';          -- prevent latches        
                comp_is_signed_sig <= '0';  -- prevent latches
            when "0100" =>   --sub
                o_mode_sig <= '1';
                dir_sig    <= '0';          -- prevent latches
                arith_sig  <= '0';          -- prevent latches        
                comp_is_signed_sig <= '0';  -- prevent latches


            when "0101" =>   --sll(i)
                o_mode_sig <= '0';          -- prevent latches
                dir_sig    <= '0'; 
                arith_sig  <= '0';        
                comp_is_signed_sig <= '0';  -- prevent latches
            when "0110" =>   --srl(i)
                o_mode_sig <= '0';          -- prevent latches
                dir_sig    <= '1';
                arith_sig  <= '0';         
                comp_is_signed_sig <= '0';  -- prevent latches
            when "0111" =>   --sra(i)
                o_mode_sig <= '0';          -- prevent latches
                dir_sig    <= '1';          -- prevent latches
                arith_sig  <= '1';          -- prevent latches
                comp_is_signed_sig <= '0';  -- prevent latches


            when "1000" =>   --slt(i)
                o_mode_sig <= '0';          -- prevent latches
                dir_sig    <= '0';
                arith_sig  <= '0';
                comp_is_signed_sig <= '1';         
            when "1001" =>   --slt(i)u
                o_mode_sig <= '0';          -- prevent latches
                dir_sig    <= '0';          -- prevent latches
                arith_sig  <= '0';          -- prevent latches
                comp_is_signed_sig <= '0';
            when "1010" =>   --beq
                o_mode_sig <= '0';          -- prevent latches
                dir_sig    <= '0';
                arith_sig  <= '0';
                comp_is_signed_sig <= '0';         
            when "1011" =>   --bne
                o_mode_sig <= '0';          -- prevent latches
                dir_sig    <= '0';          -- prevent latches
                arith_sig  <= '0';          -- prevent latches
                comp_is_signed_sig <= '0';
            -- when "1100" =>   --blt
            --     o_mode_sig <= '0';          -- prevent latches
            --     dir_sig    <= '0';
            --     arith_sig  <= '0';
            --     comp_is_signed_sig <= '1';         
            when "1101" =>   --bge
                o_mode_sig <= '0';          -- prevent latches
                dir_sig    <= '0';          -- prevent latches
                arith_sig  <= '0';          -- prevent latches
                comp_is_signed_sig <= '1';
            -- when "1110" =>   --bltu
            --     o_mode_sig <= '0';          -- prevent latches
            --     dir_sig    <= '0';
            --     arith_sig  <= '0';
            --     comp_is_signed_sig <= '1';         
            when "1111" =>   -- bgeu
                o_mode_sig <= '0';          -- prevent latches
                dir_sig    <= '0';          -- prevent latches
                arith_sig  <= '0';          -- prevent latches
                comp_is_signed_sig <= '0';


            when others => 
                o_mode_sig <= '0';          -- prevent latches
                dir_sig    <= '0';          -- prevent latches
                arith_sig  <= '0';          -- prevent latches
                comp_is_signed_sig <= '0';  -- prevent latches
        end case;
    end process; 
    

    process (operation, equal_out_sig, res_comp_sig)
    begin
    -- equal_out_sig:   result for a==b
    -- res_comp_sig(0): result for a<b
        case operation is
            when "1010" => branch_condition <= equal_out_sig;                               --beq   
            when "1011" => branch_condition <= not equal_out_sig;                           --bne
            when "1100" => branch_condition <=     res_comp_sig(0)      and not equal_out_sig;       --blt
            when "1101" => branch_condition <= not res_comp_sig(0)  or      equal_out_sig;        --bge
            when "1110" => branch_condition <=     res_comp_sig(0)      and not equal_out_sig;       --bltu     
            when "1111" => branch_condition <= not res_comp_sig(0)  or      equal_out_sig;    -- bgeu
            when others => branch_condition <= '0';
        end case;
    end process;
end rtl;