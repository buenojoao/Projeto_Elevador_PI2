library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_pwm_servo is
end tb_pwm_servo;

architecture sim of tb_pwm_servo is
    signal clk, rst, open_cmd : STD_LOGIC := '0';
    signal servo_pwm : STD_LOGIC;
begin
    clk <= not clk after 5 ns;

    uut: entity work.pwm_servo
        generic map(
            CLK_FREQ => 1000,
            PWM_FREQ => 50,
            PULSE_CLOSED => 1,
            PULSE_OPEN => 2
        )
        port map(clk, rst, open_cmd, servo_pwm);

    process
    begin
        rst <= '1'; wait for 20 ns;
        rst <= '0'; wait for 100 ns;

        open_cmd <= '1'; wait for 300 ns;
        open_cmd <= '0'; wait for 300 ns;

        wait;
    end process;
end sim;