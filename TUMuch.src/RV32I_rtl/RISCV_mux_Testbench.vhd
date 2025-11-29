--erstellt von Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.defs_pack.all;

--Testbench for mux with 3 32 bit inputs
entity mux32_3x1_Testbench is
    Port (select_input : in bit_vector(1 downto 0);
          d_in_a, d_in_b : in bit_vector(RegDataSize-1 downto 0);
          d_in_c : in bit_vector(RegDataSize-1 downto 0);
          d_out : out bit_vector(RegDataSize-1 downto 0)
          );
end mux32_3x1_Testbench;

architecture RTL of mux32_3x1_Testbench is
begin


end RTL;


--Testbench for mux with 4 32 bit inputs
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.defs_pack.all;

entity mux32_4x1_Testbench is
    Port (select_input : in bit_vector (1 downto 0);
          d_in_a, d_in_b : in bit_vector(RegDataSize-1 downto 0);
          d_in_c, d_in_d : in bit_vector(RegDataSize-1 downto 0);
          d_out : out bit_vector(RegDataSize-1 downto 0));
end mux32_4x1_Testbench;

architecture RTL of mux32_4x1_Testbench is
begin


end RTL;
