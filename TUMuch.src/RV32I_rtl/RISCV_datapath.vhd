-- ERSTELLT VON JEONGJOO LIM

library IEEE;
use IEEE.NUMERIC_STD.ALL;
use work.defs_pack.all;

entity Datapath is
    port ( 
        -- clock, reset
        clk : in bit;
        rst : in bit;
        
        -- data output
        data_out  : out BusDataType; -- requires buffer, to Memory
        
        -- from datapath:        
        addr_in   : out bit_vector(AddrSize-1 downto 0); -- requires buffer
        bra_cond  : out bit;
        sel_mux_1 : in  bit;
        sel_mux_2 : in  bit;
        sel_mux_4 : in  bit; 
        
        reg_en    : in  bit;
        sel_in    : in  bit_vector(4 downto 0);
        sel_out_a : in  bit_vector(4 downto 0);
        sel_out_b : in  bit_vector(4 downto 0);
        operation : in  bit_vector(3 downto 0);        
        
        const_1   : in  BusDataType;
        const_2   : in  BusDataType;
        const_reg : in  BusDataType        
    );
end Datapath;

architecture RTL of Datapath is    
    signal rs_1       : BusDataType := (others=>'0');
    signal rs_2       : BusDataType := (others=>'0');    
    signal out_mux1   : BusDataType := (others=>'0');
    signal out_mux2   : BusDataType := (others=>'0');
    signal out_mux4   : BusDataType := (others=>'0');    
    signal alu_result : BusDataType := (others=>'0');    
begin
    MUX_1 : entity work.mux2x1 port map (
        in_0 => rs_2,
        in_1 => const_1,
        sel => sel_mux_1,
        output => out_mux1
    );
    
    MUX_2 : entity work.mux2x1 port map (
        in_0 => alu_result,
        in_1 => const_reg,        
        sel => sel_mux_2,
        output => out_mux2
    );
    
    MUX_4 : entity work.mux2x1 port map (
        in_0 => const_2,
        in_1 => rs_1,        
        sel => sel_mux_4,
        output => out_mux4
    );
    
    ALU : entity work.alu32 port map(
        operand_a => out_mux4,      -- rs1/const2
        operand_b => out_mux1,      -- rs2/const1
        
        operation => operation,
        branch_condition=>bra_cond,    
        result => alu_result
    );    
    
    rf : entity work.reg_file port map(
        clk => clk,
        rst => rst,
        
        we => reg_en,
        w_addr => sel_in,           --rd
        w_data => out_mux2,
        
        re_addr_1 => sel_out_a,     --rs1
        r_data_1 => rs_1,           --reg(rs1)
        re_addr_2 => sel_out_b,     --rs2
        r_data_2 => rs_2            --reg(rs2) 
    );
    
    data_out <= rs_2;
    addr_in <= rs_1(15 downto 0);
end RTL;
