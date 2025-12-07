-- created by Josip Pepic
library IEEE;
use IEEE.numeric_bit.ALL;
library work;
use work.defs_pack.all;

entity reg_file_TB is
    port (
        we          : out bit;
        w_addr      : out bit_vector(4 downto 0);
        w_data      : out RegDataType;
        
        -- two read ports
        
        -- re_1        : in bit;        -> currently not used
        re_addr_1   : out bit_vector(4 downto 0);
        r_data_1    : in RegDataType;
  
        -- re_2        : in bit;        -> currently not used
        re_addr_2   : out bit_vector(4 downto 0);
        r_data_2    : in RegDataType        
         
         
         
         );
end reg_file_TB;

architecture Behavioral of reg_file_TB is

begin
    process
        variable exp_val    : bit_vector(31 downto 0);
    begin
        -- one clkCycle is 10 ns
        ---------------TEST1---------------
        -- write value x in reg_x, read it and compare it to the expected value
        we <= '1';
        for i in 0 to 31 loop
            w_addr <= bit_vector(to_unsigned(i, 5));
            wait for 10 ns;
            w_data <= bit_vector(to_unsigned(i, 32));
            wait for 10 ns;
        end loop;
        we <= '0';
        
        for i in 0 to 31 loop
            exp_val := bit_vector(to_unsigned(i, 32));
            re_addr_1 <= bit_vector(to_unsigned(i, 5));
            re_addr_2 <= bit_vector(to_unsigned(i, 5));
            wait for 5 ns;
            assert r_data_1 = exp_val and r_data_2 = exp_val
            report "unexpected values read"
            severity error;
        end loop;
        
        ---------------TEST2---------------
        -- test if we = 0 prevents writing to the registers
        we <= '1';
        w_addr <= bit_vector(to_unsigned(1, 5));
        w_data <= x"00000001";
        wait for 20 ns;
        we <= '0';
        wait for 5 ns;
        w_data <= x"00000002";
        re_addr_1 <= bit_vector(to_unsigned(1, 5));
        wait for 20 ns;
        
        assert r_data_1 = x"00000001"
        report "wrong data stored in memory - write enable"
        severity error;
        
        ---------------TEST3---------------
        -- test if register 0 is hardwired to zero
        we <= '1';
        w_addr <= bit_vector(to_unsigned(5, 5));
        w_data <= x"12345678";
        re_addr_1 <= bit_vector(to_unsigned(0, 5));
        wait for 20 ns;
        assert r_data_1 = x"00000000"
        report "register zero is not hardwired to the value zero"
        severity error;
        
    end process;
end Behavioral;

------------------------ testbench TLE ---------------------------
library work;
use work.defs_pack.all;

entity reg_file_TLE is
end entity;

architecture Behavioral of reg_file_TLE is
    signal clk, we : bit;
    signal w_addr_s, re_addr_1_s, re_addr_2_s   : bit_vector(4 downto 0);
    signal w_data_s, r_data_1_s, r_data_2_s           : RegDataType;
begin
    clk_gen     : entity work.clk_gen(dataflow)
                    port map(
                            clk => clk);
                            
    TB          : entity work.reg_file_TB(Behavioral)
                    port map(        
                            we          => we,
                            w_addr      => w_addr_s,
                            w_data      => w_data_s,
                            
                            re_addr_1   => re_addr_1_s,
                            r_data_1    => r_data_1_s,
                            re_addr_2   => re_addr_2_s,
                            r_data_2    => r_data_2_s
                            );
                            
    reg_file    : entity work.reg_file(RTL)
                    port map(
                            clk => clk,
                            rst => '0',
                            
                            we          => we,
                            w_addr      => w_addr_s,
                            w_data      => w_data_s,
                            
                            re_addr_1   => re_addr_1_s,
                            r_data_1    => r_data_1_s,
                            re_addr_2   => re_addr_2_s,
                            r_data_2    => r_data_2_s
                             );
end architecture;
