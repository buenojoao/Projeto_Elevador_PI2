library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm_servo is
    generic (
        CLK_FREQ    : integer := 100000000; -- 100 MHz Nexys
        PWM_FREQ    : integer := 50;        -- 50 Hz servo
        PULSE_CLOSED: integer := 100000;    -- 1 ms em ciclos de 100 MHz
        PULSE_OPEN  : integer := 200000     -- 2 ms em ciclos de 100 MHz
    );
    port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        open_cmd  : in  STD_LOGIC;
        servo_pwm : out STD_LOGIC
    );
end pwm_servo;

architecture Behavioral of pwm_servo is

    constant PERIOD_COUNT : integer := CLK_FREQ / PWM_FREQ; -- 2.000.000 ciclos = 20 ms

    signal counter : integer range 0 to PERIOD_COUNT := 0;
    signal pulse_width : integer range 0 to PERIOD_COUNT := PULSE_CLOSED;

begin

    process(clk, rst)
    begin
        if rst = '1' then
            counter <= 0;
            pulse_width <= PULSE_CLOSED;
            servo_pwm <= '0';

        elsif rising_edge(clk) then

            if open_cmd = '1' then
                pulse_width <= PULSE_OPEN;
            else
                pulse_width <= PULSE_CLOSED;
            end if;

            if counter < PERIOD_COUNT - 1 then
                counter <= counter + 1;
            else
                counter <= 0;
            end if;

            if counter < pulse_width then
                servo_pwm <= '1';
            else
                servo_pwm <= '0';
            end if;

        end if;
    end process;

end Behavioral;