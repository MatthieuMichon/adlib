-- VHDL2008
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;

entity pwm is
    generic (data_width: positive);
    port (
        clk: in std_ulogic;
        -- Control
        duty: in std_ulogic_vector(data_width-1 downto 0);
        -- Output
        dout: out std_ulogic
    );
end entity;

architecture a_pwm of pwm is
    subtype data_t is std_ulogic_vector(data_width-1 downto 0);
    signal counter: data_t := (others=>'0');
begin
    counter <= counter + 1 when rising_edge(clk);
    dout <= '1' when (counter <= duty) and (0 < duty) else '0';
end architecture;
