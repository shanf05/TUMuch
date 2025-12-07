--created by Max Biricz and Josip Pepic
library IEEE;
use IEEE.STD_LOGIC_1164.all;
library work;
use work.defs_pack.all;

--Generic/Flexible D-FlipFlop with enable function
entity D_FFG is 
    generic(clk_edge, rst_level, has_rst, sync_rst : bit := '1';
            size : integer := RegDataSize);
    Port (D : in bit_vector(size-1 downto 0);
          RST : in bit;
          CLK : in bit;
          EN : in bit;
          Q: out bit_vector(size-1 downto 0));
end D_FFG;

architecture RTL of D_FFG is
begin
    sr: if has_rst = '1' and sync_rst = '1' generate --synchronous read FlipFlop
        process(clk, rst)
        begin
            if clk = clk_edge and CLK'event and en ='1' then
                if RST = rst_level then
                    Q <= (others => '0');
                else
                    Q <= D;
                end if;
            end if;
         end process;
     end generate;
     
     ar: if has_rst = '1' and sync_rst = '0' generate
        process(clk, rst)
        begin
            if RST = rst_level and en = '1' then
                Q <= (others => '0');
            elsif CLK = clk_edge and CLK'event and en = '1' then
                Q <= D;
            end if;
        end process;
     end generate; 
     
     nr: if has_rst = '0' generate
     process
     begin
        wait until CLK = clk_edge;
            Q <= D;
     end process;
     end generate;
    
end RTL;

