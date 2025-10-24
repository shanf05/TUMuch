----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2025 11:22:39 PM
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
        Y : out Bit );
end NOR2;
architecture timed_dataflow
    of NOR2 is
begin
    Y <= '1' after Tr
        when (A OR B)= '0' else
        '0' after Tf;
end timed_dataflow;

entity NOR2TEST is
end NOR2TEST;
architecture TB of NOR2TEST is
    component NOR2
    generic( Tr: Time;
    Tf: Time );
    port( A, B : in Bit;
    Y : out Bit );
    end component;
signal A,B,Y : bit;
begin
UUT: NOR2 generic map( 0.6 ns, 0.8 ns)
port map( A,B,Y);
A <= '1' after 5 ns, '0' after 10 ns;
B <= '1' after 7 ns;
end TB;

configuration NOR2TESTCONF of
NOR2TEST -- Top Level Entity
is
for TB -- Architecture of TLE
for -- Instantiated Component
UUT: NOR2
use -- Bound Entity
entity WORK.NOR2
-- Bound Arch.
( TIMED_DATAFLOW );
end for;
end for;
end NOR2TESTCONF;