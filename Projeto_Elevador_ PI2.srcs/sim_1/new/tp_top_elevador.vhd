library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top_elevador is
end tb_top_elevador;

architecture sim of tb_top_elevador is
    signal clk, rst : STD_LOGIC := '0';

    signal B0, B1, B2, B3 : STD_LOGIC := '1';
    signal S0, S1, S2, S3 : STD_LOGIC := '1';

    signal door : STD_LOGIC;
    signal andar : STD_LOGIC_VECTOR(1 downto 0);
    signal motor_out : STD_LOGIC_VECTOR(3 downto 0);
    signal servo_pwm : STD_LOGIC;
begin
    clk <= not clk after 5 ns;

    uut: entity work.top_elevador
        port map(
            clk => clk,
            rst => rst,
            B0 => B0,
            B1 => B1,
            B2 => B2,
            B3 => B3,
            S0 => S0,
            S1 => S1,
            S2 => S2,
            S3 => S3,
            door => door,
            andar => andar,
            motor_out => motor_out,
            servo_pwm => servo_pwm
        );

    process
    begin
        rst <= '1'; wait for 50 ns;
        rst <= '0'; wait for 50 ns;

        -- Entradas físicas com pull-up:
        -- solto = '1', acionado = '0'

        S0 <= '0'; wait for 100 ns;
        S0 <= '1';

        B3 <= '0'; wait for 50 ns;
        B3 <= '1';

        S1 <= '0'; wait for 100 ns;
        S1 <= '1';

        S2 <= '0'; wait for 100 ns;
        S2 <= '1';

        S3 <= '0'; wait for 100 ns;
        S3 <= '1';

        wait;
    end process;
end sim;