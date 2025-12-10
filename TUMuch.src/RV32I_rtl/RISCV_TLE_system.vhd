library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.all;

--Top Level Entity between System and clk & rst generator
entity TLE_system is
end TLE_system;

architecture RTL of TLE_system is
signal clk_sig, rst_sig, active_sig : bit;

begin
    system : entity work.system
             port map(clk => clk_sig, rst => rst_sig, active => active_sig);
            
    rst_gen : entity work.rst_gen
              port map (rst => rst_sig);
              
    clk_gen : entity work.clk_gen
              port map (clk => clk_sig);

end RTL;
