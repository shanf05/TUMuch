--created by Max Biricz
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;

-- clock signal generator
entity clk_gen is
    generic(init_value : bit := '1';
            init_delay : time := 1 ns;
            T_high, T_low : time := 1 ns;
            T_active : time := 200 ns
                                    );
     port (clk : buffer bit := init_value);                               
end clk_gen;

architecture dataflow of clk_gen is
begin
    clk <= not init_value, init_value after init_delay
           when now = 0 ns else
       '1' after T_low
           when clk = '0' and now > 0 ns and now < T_active else
       '0' after T_high
           when clk = '1' and now > 0 ns and now < T_active else
           clk;
    
end architecture dataflow;

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

-- Testbench for D-FlipFlop with Reset and Enable
entity D_FFRE_Testbench is
    Port (D : out bit;
          EN : out bit);
end D_FFRE_Testbench;

architecture behavioral of D_FFRE_Testbench is
begin
    process
    begin
        D <= '1';
        EN <= '1';
        wait for 4 ns;
        D <= '0';
        wait for 5 ns;
        EN <= '0';
        D <= '1';
        wait for 5 ns;
        EN <= '1';
    end process;

end behavioral;

------------D_FFRE Top Level Entity
entity D_FFRE_TLE is
end D_FFRE_TLE;


architecture Behavioral of D_FFRE_TLE is
    component clk_gen is
    port(clk : out bit);
    end component;
    
    component rst_gen is
    port(rst : out bit);
    end component;
    
    component D_FFRE is
    port (D : in bit;
          EN : in bit;
          CLK : in bit;
          RST : in bit;
          Q : out bit  );
    end component;
    
    component D_FFRE_Testbench is
    port(D  : out bit;
         EN : out bit  );
    end component;

signal D_sig, EN_sig, CLK_sig, RST_sig : bit;
signal Q_sig : bit;
    
begin
    TB : entity work.D_FFRE_Testbench(Behavioral)
         port map(en => EN_sig, D => D_sig);
         
    CLK : entity work.clk_gen(dataflow)
          port map(clk => clk_sig);
          
    RST : entity work.rst_gen(dataflow)
          port map(rst => rst_sig);
    
    UUT : entity work.D_FFRE(RTL) 
          port map(D => D_sig, EN => EN_sig, CLK => clk_sig, rst => rst_sig, Q => Q_sig);

end Behavioral;

