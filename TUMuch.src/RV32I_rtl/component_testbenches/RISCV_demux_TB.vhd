-- created by Jeongjoo LIM JOSIP PEPIC

library IEEE;
use ieee.numeric_bit.all;

entity demux_tb is
    generic(
        data_width      : integer := 32;
        data_lines      : integer := 4
    );
    port(
        data_out        : out bit_vector (data_width -1 downto 0);
        sel             : out integer range 0 to data_lines - 1; 
        data_in         : in bit_vector (data_lines*data_width - 1 downto 0)
    );
end demux_tb;

architecture Behavioral of demux_tb is

begin
    process
        begin
            for i in 0 to data_lines - 1 loop
                sel <= i;
                wait for 1 ns;
            end loop;
    end process;
    
    process
        begin
            wait for 0.5 ns;
            data_out <= x"12345678";
            wait for 1 ns;
            data_out <= x"bbbbbbbb";
            wait for 1 ns;
            data_out <= x"cccccccc";
            wait for 1 ns;
            data_out <= x"deadbeef";
            wait for 1 ns;
            wait;
    end process;
end Behavioral;

------------------------ testbench TLE ---------------------------

entity demux_TLE is
end demux_TLE;

architecture Behavioral of demux_TLE is
    signal sel      : integer := 4;
    signal data_in  : bit_vector(31 downto 0);
    signal data_out : bit_vector(127 downto 0);
begin
    demux : entity work.demux(RTL)
            generic map(
                data_width  => 32,
                ports       => 4
            )
            port map(
                input       => data_in,
                sel         => sel,
                output      => data_out           
            );
            
     TB : entity work.demux_tb(Behavioral)
            generic map(
                data_width  => 32,
                data_lines  => 4
            )
            port map(
                data_out    => data_in,
                sel         => sel,
                data_in     => data_out           
            );  

end Behavioral;