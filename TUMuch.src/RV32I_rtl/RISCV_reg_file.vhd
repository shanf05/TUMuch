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
        w_addr      : in bit_vector(4 downto 0);
        w_data      : in RegDataType;
        
        -- two read ports
        
        -- re_1        : in bit;        -> currently not used
        re_addr_1   : in bit_vector(4 downto 0);
        r_data_1    : out RegDataType;
  
        -- re_2        : in bit;        -> currently not used
        re_addr_2   : in bit_vector(4 downto 0);
        r_data_2    : out RegDataType        
        );
end reg_file;

architecture RTL of reg_file is
    signal en_vec       : ENType;
    signal mux_input    : RegType;
begin
    decoder :   entity work.reg_decoder(RTL)
                    port map(we => we, w_addr => w_addr, en => en_vec);

    regs    : for i in 0 to RegSize - 1 generate
                reg_zero    :   if i = 0 generate
                                    mux_input(i) <= (others=>'0');
                                end generate reg_zero;
                reg_nat     :   if i > 0 generate                 
                                    reg  :   entity work.D_FFG(RTL)
                                                    port map(
                                                        en => en_vec(i), 
                                                        clk => clk, 
                                                        rst => rst, 
                                                        d   => w_data,
                                                        q   => mux_input(i) 
                                                        );
                                end generate reg_nat;
    end generate;
    
    mux1_32x1    :  entity work.mux32x1(RTL)
                    generic map(
                        data_width  => RegDataSize
                            )
                    port map(
                        in_0        => mux_input(0),
                        in_1        => mux_input(1),
                        in_2        => mux_input(2),
                        in_3        => mux_input(3),
                        in_4        => mux_input(4),
                        in_5        => mux_input(5),
                        in_6        => mux_input(6),
                        in_7        => mux_input(7),
                        in_8        => mux_input(8),
                        in_9        => mux_input(9),
                        in_10       => mux_input(10),
                        in_11       => mux_input(11),
                        in_12       => mux_input(12),
                        in_13       => mux_input(13),
                        in_14       => mux_input(14),
                        in_15       => mux_input(15),
                        in_16       => mux_input(16),
                        in_17       => mux_input(17),
                        in_18       => mux_input(18),
                        in_19       => mux_input(19),
                        in_20       => mux_input(20),
                        in_21       => mux_input(21),
                        in_22       => mux_input(22),
                        in_23       => mux_input(23),
                        in_24       => mux_input(24),
                        in_25       => mux_input(25),
                        in_26       => mux_input(26),
                        in_27       => mux_input(27),
                        in_28       => mux_input(28),
                        in_29       => mux_input(29),
                        in_30       => mux_input(30),
                        in_31       => mux_input(31),
                        sel         => re_addr_1,
                        output      => r_data_1                  
                    );
                    
    mux2_32x1    :  entity work.mux32x1(RTL)
                    generic map(
                        data_width  => RegDataSize
                            )
                    port map(
                        in_0        => mux_input(0),
                        in_1        => mux_input(1),
                        in_2        => mux_input(2),
                        in_3        => mux_input(3),
                        in_4        => mux_input(4),
                        in_5        => mux_input(5),
                        in_6        => mux_input(6),
                        in_7        => mux_input(7),
                        in_8        => mux_input(8),
                        in_9        => mux_input(9),
                        in_10       => mux_input(10),
                        in_11       => mux_input(11),
                        in_12       => mux_input(12),
                        in_13       => mux_input(13),
                        in_14       => mux_input(14),
                        in_15       => mux_input(15),
                        in_16       => mux_input(16),
                        in_17       => mux_input(17),
                        in_18       => mux_input(18),
                        in_19       => mux_input(19),
                        in_20       => mux_input(20),
                        in_21       => mux_input(21),
                        in_22       => mux_input(22),
                        in_23       => mux_input(23),
                        in_24       => mux_input(24),
                        in_25       => mux_input(25),
                        in_26       => mux_input(26),
                        in_27       => mux_input(27),
                        in_28       => mux_input(28),
                        in_29       => mux_input(29),
                        in_30       => mux_input(30),
                        in_31       => mux_input(31),
                        sel         => re_addr_2,
                        output      => r_data_2                  
                    );

end RTL;
