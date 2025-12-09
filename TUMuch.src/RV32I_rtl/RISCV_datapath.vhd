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
        comp_res  : out bit_vector(1 downto 0);
        sel_mux_1 : in  bit;
        sel_mux_2 : in  bit;
        sel_mux_3 : in  bit; 
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
    
    signal rs_1 : BusDataType;
    signal rs_2 : BusDataType;
    
    signal out_mux1 : BusDataType;
    signal out_mux2 : BusDataType;
    
    signal alu_result : BusDataType;
    
    signal out_mux3 : BusDataType;
    
begin
    MUX_1 : entity work.mux2x1 port map (
        in_0 => rs_1,
        in_1 => const_1,
        sel => sel_mux_1,
        output => out_mux1
    );
    
    MUX_2 : entity work.mux2x1 port map (
        in_0 => rs_2,
        in_1 => const_2,
        sel => sel_mux_2,
        output => out_mux2
    );
    
    ALU : entity work.alu32 port map(
        operand_a => out_mux1,      -- rs1/const1
        operand_b => out_mux2,      -- rs2/const2
        
        operation => operation,
        
        result => alu_result
    );
    
    MUX_3 : entity work.mux2x1 port map (
        in_0 => alu_result,
        in_1 => const_2,
        sel => sel_mux_3,
        output => out_mux3
    );
    
    rf : entity work.reg_file port map(
        clk => clk,
        rst => rst,
        
        we => reg_en,
        w_addr => sel_in,
        w_data => out_mux3,
        
        re_addr_1 => sel_out_a,
        r_data_1 => rs_1,           --rs1
        re_addr_2 => sel_out_b,
        r_data_2 => rs_2            --rs2 
    );
    
    data_out <= rs_1;
    addr_in <= alu_result(AddrSize-1 downto 0);
end RTL;
