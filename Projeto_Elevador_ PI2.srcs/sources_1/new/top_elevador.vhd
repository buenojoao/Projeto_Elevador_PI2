library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_elevador is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;

        -- Botões de chamada dos andares
        B0, B1, B2, B3 : in  STD_LOGIC;

        -- Sensores de fim de curso dos andares
        S0, S1, S2, S3 : in  STD_LOGIC;

        -- Saídas de visualização
        door     : out STD_LOGIC;
        andar    : out STD_LOGIC_VECTOR(1 downto 0);

        -- Controle do motor de passo
        motor_out : out STD_LOGIC_VECTOR(3 downto 0);

        -- Controle do servo da porta
        servo_pwm : out STD_LOGIC
    );
end top_elevador;

architecture Structural of top_elevador is

    signal pedidos : STD_LOGIC_VECTOR(3 downto 0);
    signal clear   : STD_LOGIC_VECTOR(3 downto 0);
    signal arrive  : STD_LOGIC;
    signal busy    : STD_LOGIC;
    signal andar_s : STD_LOGIC_VECTOR(1 downto 0);
    signal B0_i, B1_i, B2_i, B3_i : STD_LOGIC;
    signal S0_i, S1_i, S2_i, S3_i : STD_LOGIC;

    signal door_s    : STD_LOGIC;
    signal move_up_s : STD_LOGIC;
    signal move_down_s : STD_LOGIC;

begin

    B0_i <= not B0;
    B1_i <= not B1;
    B2_i <= not B2;
    B3_i <= not B3;

    S0_i <= not S0;
    S1_i <= not S1;
    S2_i <= not S2;
    S3_i <= not S3;

    mem : entity work.memoria_pedidos
        port map (
            clk     => clk,
            rst     => rst,
            B0 => B0_i,
            B1 => B1_i,
            B2 => B2_i,
            B3 => B3_i,
            clear   => clear,
            pedidos => pedidos
        );

    ctrl : entity work.controle_elevador
        port map (
            clk         => clk,
            rst         => rst,
            pedidos     => pedidos,
            busy        => busy,

            S0 => S0_i,
            S1 => S1_i,
            S2 => S2_i,
            S3 => S3_i,

            andar_atual => andar_s,
            arrive      => arrive,
            clear       => clear,

            move_up     => move_up_s,
            move_down   => move_down_s
        );

    porta : entity work.door_controller
        generic map (
            SAFETY_MAX => 100000000,
            TIMER_MAX  => 300000000
        )
        port map (
            clk    => clk,
            rst    => rst,
            arrive => arrive,
            door   => door_s,
            busy   => busy
        );

    motor : entity work.motor_controller
        generic map (
            STEP_DELAY => 350000
        )
        port map (
            clk       => clk,
            rst       => rst,
            move_up   => move_up_s,
            move_down => move_down_s,
            motor_out => motor_out
        );

    servo : entity work.pwm_servo
        port map (
            clk       => clk,
            rst       => rst,
            open_cmd  => door_s,
            servo_pwm => servo_pwm
        );

    door  <= door_s;
    andar <= andar_s;

end Structural;