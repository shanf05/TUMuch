--created by Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;
library work;
use work.defs_pack.all;

-- reset signal generator
entity rst_gen is 
    generic(rst_level : bit := '1';
            init_delay : time := 1 ns;
            T_rst : time := 1 ns );
    port(rst : out bit);
end rst_gen;

architecture dataflow of rst_gen is
begin
    rst <= not rst_level,
           rst_level after init_delay,
           not rst_level after init_delay + T_rst,
           rst_level after init_delay + 3*T_rst,
           not rst_level after init_delay + 4 * T_rst;
end dataflow;

library work;
use work.defs_pack.all;

-- Testbench for D-FlipFlop with Reset and Enable
entity D_FFG_Testbench is
    Port (D : out bit_vector(RegDatasize-1 downto 0);
          EN : out bit);
end D_FFG_Testbench;

architecture behavioral of D_FFG_Testbench is
begin
    process
    begin
        D <= X"AAAAAAAA";
        EN <= '1';
        wait for 4 ns;
        D <= X"DEADBEEF";
        wait for 5 ns;
        EN <= '0';
        D <= X"11223344";
        wait for 5 ns;
        EN <= '1';
        D <= X"01010101";
        EN <= '1';
        wait for 4 ns;
        D <= X"FFFFFFFF";
        wait for 5 ns;
        EN <= '0';
        D <= X"12345678";
        wait for 5 ns;
        EN <= '1';
    end process;

end behavioral;

------------D_FFRE Top Level Entity
library work;
use work.defs_pack.all;

entity D_FFG_TLE is
end D_FFG_TLE;

architecture Behavioral of D_FFG_TLE is
    component clk_gen is
    port(clk : out bit);
    end component;
    
    component rst_gen is
    port(rst : out bit);
    end component;
    
    component D_FFG is
    port (D : in bit;
          EN : in bit;
          CLK : in bit;
          RST : in bit;
          Q : out bit  );
    end component;
    
    component D_FFG_Testbench is
    port(D  : out bit;
         EN : out bit  );
    end component;

signal EN_sig, CLK_sig, RST_sig : bit;
signal D_sig, Q_sig1, Q_sig2, Q_sig3 : bit_vector(RegDataSize-1 downto 0);
    
begin
    TB : entity work.D_FFG_Testbench(Behavioral)
         port map(en => EN_sig, D => D_sig);
         
    CLK : entity work.clk_gen(dataflow)
          generic map(T_high =>  1ns, T_low => 1 ns, T_active => 2000 ns)
          port map(clk => clk_sig);
          
    RST : entity work.rst_gen(dataflow)
          port map(rst => rst_sig);
    
    DFF_SR : entity work.D_FFG(RTL)
          generic map(has_rst => '1', sync_rst => '1') 
          port map(D => D_sig, EN => EN_sig, CLK => clk_sig, rst => rst_sig, Q => Q_sig1);
    
    DFF_AR : entity work.D_FFG(RTL)
          generic map(has_rst => '1', sync_rst => '0') 
          port map(D => D_sig, EN => EN_sig, CLK => clk_sig, rst => rst_sig, Q => Q_sig2);
          
    DFF_NR : entity work.D_FFG(RTL)
          generic map(has_rst => '0')
          port map (D => D_sig, EN => EN_sig, clk => clk_sig, rst => rst_sig, Q => Q_sig3);
end Behavioral;

