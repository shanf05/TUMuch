--created by Jeongjoo Lim and Max Biricz
library work;
use work.defs_pack.all;

--Half adder with variable input length
entity halfadd is
    generic(Datasize : integer := BusDataSize);
    port (x1 : in bit;
          x2 : in bit;
          x1_xor_x2 : out bit;
          x1_and_x2 : out bit);
end halfadd;

architecture RTL of halfadd is
begin
    x1_xor_x2 <= x1 xor x2;
    x1_and_x2 <= x1 and x2;
end RTL;


library work;
use work.defs_pack.all;
--Adder Subber with flexible bit inputs/outputs
entity addsub is
    generic ( Datasize : integer := BusDataSize);
    port (o_mode : in bit;          --0 is adding, 1 is substracting
          a, b : in bit_vector(DataSize-1 downto 0);         
          d_out : out bit_vector(DataSize-1 downto 0)
         );                   
end addsub;


architecture RTL of addsub is 
    signal a_and_b, a_xor_b, abc, b_xor_o : bit_vector(DataSize-1 downto 0) := (others=>'0');
    signal c : bit_vector(DataSize downto 0) := (others=>'0');
begin 
    gen : for i in 0 to DataSize-1 generate
        b_xor_o(i) <= b(i) xor o_mode;    
        HA1 : entity work.halfadd port map(x1=>a(i),x2 => b_xor_o(i), x1_and_x2 => a_and_b(i), x1_xor_x2 => a_xor_b(i));
        
        gen2: if i = 0 generate
            HA2 : entity work.halfadd port map(x1=>a_xor_b(i),x2 => o_mode, x1_and_x2 => abc(i), x1_xor_x2 => d_out(i));
        end generate;
        
        gen3: if i /= 0 generate
            HA2 : entity work.halfadd port map(x1=>a_xor_b(i),x2 => c(i), x1_and_x2 => abc(i), x1_xor_x2 => d_out(i));
        end generate;
        
        c(i+1) <= abc(i) or a_and_b(i);
    end generate;
end RTL;


