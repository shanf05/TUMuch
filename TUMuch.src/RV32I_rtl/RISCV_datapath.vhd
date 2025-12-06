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
        addr_in   : out BusDataType; -- requires buffer
        sel_mux_1 : in  bit;
        sel_mux_2 : in  bit;
        sel_mux_3 : in  bit; 
        
        reg_en    : in  bit;
        sel_in    : in  bit_vector(4 downto 0);
        sel_out_a : in  bit_vector(4 downto 0);
        sel_out_b : in  bit_vector(4 downto 0);
        operation : in  bit_vector(2 downto 0);        
        
        const_1   : in  BusDataType;
        const_2   : in  BusDataType
    );
end Datapath;

architecture RTL of Datapath is
    
    signal rs_1 : BusDataType;
    signal rs_2 : BusDataType;
    
    signal in_mux1  : bit_vector(2*BusDataSize-1 downto 0);
    signal out_mux1 : BusDataType;
    
    signal in_mux2  : bit_vector(2*BusDataSize-1 downto 0);
    signal out_mux2 : BusDataType;
    
    signal alu_result : BusDataType;
    
    signal in_mux3  : bit_vector(2*BusDataSize-1 downto 0);
    signal out_mux3 : BusDataType;
    
begin
    in_mux1 <= rs_1 & const_1;
    MUX1 : entity work.mux generic map (ports => 2) port map (
        input => in_mux1,
        sel => sel_mux_1,            -- should be fixed when mux sel is bit_vector
        output => out_mux1
    );
    
    in_mux2 <= rs_2 & const_2;
    MUX2 : entity work.mux generic map (ports => 2) port map (
        input => in_mux2,
        sel => sel_mux_2,            -- should be fixed when mux sel is bit_vector
        output => out_mux2
    );
    
    ALU : entity work.alu32 port map(
        operand_a => out_mux1,      -- rs1/const1
        operand_b => out_mux2,      -- rs2/const2
        
        operation => operation,     -- should be fixed when mux sel is bit_vector
        
        result => alu_result
    );
    
    in_mux3 <= alu_result & const_2;
    MUX3 : entity work.mux generic map (ports => 2) port map (
        input => in_mux3,
        sel => sel_mux_3,            -- should be fixed when mux sel is bit_vector
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
    addr_in <= alu_result;
end RTL;
