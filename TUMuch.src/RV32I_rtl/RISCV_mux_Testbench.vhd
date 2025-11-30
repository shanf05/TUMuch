-- created by Josip Pepic

-- this testbench is currently just validating if a 4x1 mux works
-- test for Yx1 mux is coming 

-- an example of how to instantiate the mux with the generics can be seen in the TLE


library IEEE;
use ieee.numeric_bit.all;

entity mux_tb is
    generic(
        data_width      : integer := 32;
        data_lines      : integer := 4
    );
    port(
        data_out        : out bit_vector (data_lines * data_width -1 downto 0);
        sel             : out integer range 0 to data_lines - 1; 
        data_in         : in bit_vector (data_width - 1 downto 0)
    );
end mux_tb;

architecture Behavioral of mux_tb is

begin
    process
        begin
            for i in 0 to data_lines - 1 loop
                data_out((data_lines - i) * data_width - 1 downto (data_lines - i - 1) * data_width) <=  bit_vector(to_unsigned(i, 32));
                wait for 5 ns;
            end loop;
            
            for i in 0 to data_lines - 1 loop
                sel     <= i;
                wait for 2 ns;
                assert data_in = bit_vector(to_unsigned(i,32)) report "wrong input" severity error;
            end loop;
    end process;
end Behavioral;

------------------------ testbench TLE ---------------------------

entity mux_TLE is
end mux_TLE;

architecture Behavioral of mux_TLE is
    signal sel      : integer :=4;
    signal data_in  : bit_vector(127 downto 0);
    signal data_out : bit_vector(31 downto 0);
begin
    MUX : entity work.mux(RTL)
            generic map(
                data_width  => 32,
                ports       => 4
            )
            port map(
                input       => data_in,
                sel         => sel,
                output      => data_out           
            );
            
     TB : entity work.mux_tb(Behavioral)
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