----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2025 15:18:53
-- Design Name: 
-- Module Name: NOR2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NOR2 is
    generic( Tr: Time := 0.5 ns;
             Tf: Time := 0.7ns );
    port( A, B : in Bit;
          O : out Bit );
end NOR2;

architecture timed_dataflow of NOR2 is
    begin     
    O <= '1' after Tr
    when (A OR B) = '0' else
    '0' after Tf;
end timed_dataflow;