--------------------------------------------------------------------------------
-- Pulse Width Modulator Testbench
--
-- Copyright (c) 2019, Matthieu Michon matthieu.michon@gmail.com
--------------------------------------------------------------------------------

-- VHDL 2008
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

library pwm_lib;

entity tb_pwm is generic(runner_cfg: string); end entity;

architecture tb_cdcfifo_arch of tb_pwm is
    constant data_width: positive := 8;
    subtype data_t is std_ulogic_vector(data_width-1 downto 0);

    signal clk: std_ulogic := '0';
    signal duty: data_t;
    signal dout: std_ulogic;
begin
    main : process is begin
        test_runner_setup(runner, runner_cfg);
        while test_suite loop
            reset_checker_stat;
            if run("test_duty_zero") then
                duty <= (others=>'0');
                for i in 0 to 3 loop wait until rising_edge(clk); end loop;
                wait until (dout = '1') for 10 us;
                check_equal(dout, '0');
                test_runner_cleanup(runner);
            elsif run("test_duty_one") then
                duty <= (others=>'1');
                for i in 0 to 3 loop wait until rising_edge(clk); end loop;
                wait until (dout = '0') for 10 us;
                check_equal(dout, '1');
                test_runner_cleanup(runner);
            elsif run("test_duty_half") then
                duty <= X"7F";
                for i in 0 to 3 loop wait until rising_edge(clk); end loop;
                wait until (dout = '0') for 10 us;
                check_equal(dout, '0');
                wait until (dout = '1') for 10 us;
                check_equal(dout, '1');
                test_runner_cleanup(runner);
            end if;
        end loop;
    end process;

    i_pwm: entity pwm_lib.pwm
        generic map (data_width => data_width)
        port map (
            clk => clk,
            duty => duty,
            dout => dout
        );

    clk <= not clk after (1000.0 ns / 100);
end architecture;
