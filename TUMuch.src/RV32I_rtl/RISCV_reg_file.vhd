-- created by Josip Pepic
library IEEE;
use ieee.numeric_bit.all;
library work;
use work.defs_pack.all;

entity reg_file is
    port ( 
        clk         : in bit;
        rst         : in bit;
        
        we          : in bit;
        w_addr      : in RegAddrType;
        w_data      : in RegDataType;
        
        -- The register file with both versions of read (only one and two read ports) were shown in the lecture
        -- -> not sure which version we should use 
        
        -- implemented now: two read ports
        
        re_1        : in bit;
        re_addr_1   : in RegAddrType;
        r_data_1    : out RegDataType;
  
        re_2        : in bit;
        re_addr_2   : in RegAddrType;
        r_data_2    : out RegDataType        
        );
end reg_file;

architecture RTL of reg_file is
    signal en_vec       : ENType;
    signal mux_input    : bit_vector(RegSize * RegDataSize - 1 downto 0);
begin
    decoder :   entity work.reg_decoder(RTL)
                    port map(we => we, w_addr => w_addr, en => en_vec);

    regs    :   for i in 0 to RegSize - 1 generate
            reg  :   entity work.reg(RTL)                 
                            port map(
                                en => en_vec(i), 
                                clk => clk, 
                                rst => rst, 
                                d => w_data,
                                q => mux_input(i*RegDataSize + RegDataSize - 1 downto i * RegDataSize) 
                                );
    end generate;
    
    mux_1       :   entity work.mux(RTL)
                    generic map(
                        data_width  => RegDataSize,
                        ports       => RegSize
                            )
                    port map(
                        input       => mux_input,
                        sel         => re_addr_1,
                        output      => r_data_1                  
                    );
                    
    mux_2       :   entity work.mux(RTL)
                    generic map(
                        data_width  => RegDataSize,
                        ports       => RegSize
                            )
                    port map(
                        input       => mux_input,
                        sel         => re_addr_2,
                        output      => r_data_2                  
                    );

end RTL;
