-- created by JEONGJOO LIM
library IEEE;
use IEEE.numeric_bit.all;
library work; 
use work.defs_pack.all; 

entity ALU32_Testbench is
    port(
        operand_a, operand_b : out BusDataType; 
        operation            : out bit_vector(3 downto 0) 
--        result               : in  BusDataType; 
--        comp_result          : in  bit_vector(2 downto 0)   
    );
end ALU32_Testbench;

architecture stimul of ALU32_Testbench is
    type operand_array is array (natural range <>) of bit_vector(31 downto 0);

    constant test_operands_a : operand_array := (
        X"00000000",
        X"00000000",
        X"FFFFFFFF",
        X"FFFFFFFF"
    );

    constant test_operands_b : operand_array := (
        X"00000000",
        X"FFFFFFFF",
        X"00000000",
        X"00000001"
    );

begin

    --------------------------------------------------------------------------
    -- INPUT STIMULUS PROCESS
    --------------------------------------------------------------------------
    inputgen : process
    begin
        
        -- Loop through test operand pairs
        for i in test_operands_a'range loop
            
            operand_a <= test_operands_a(i);
            operand_b <= test_operands_b(i);
            wait for clkCycle;

            -- Test all 8 ALU operations
            for op in 0 to 15 loop
                operation <= bit_vector(to_unsigned(op, 4));
                wait for clkCycle;
            end loop;

        end loop;

        -- End simulation
        wait;
    end process;

end stimul;


------------------------ testbench TLE ---------------------------


library work; 
use work.defs_pack.all; 

entity ALU32_TLE is
end ALU32_TLE;

architecture Behavioral of ALU32_TLE is
    signal operand_a_sig, operand_b_sig, result_sig : BusDataType;
    signal operation_sig : bit_vector(3 downto 0);
    signal branch_condition_sig : bit;
begin

    TB   : entity work.ALU32_Testbench(stimul)
            port map (
                operand_a => operand_a_sig, 
                operand_b => operand_b_sig, 
                operation => operation_sig
            );

    UUT1 : entity work.alu32(rtl)
            port map(
                operand_a => operand_a_sig, 
                operand_b => operand_b_sig, 
                operation => operation_sig, 
                
                result => result_sig, 
                branch_condition => branch_condition_sig
            );

end;
