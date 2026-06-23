library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controle_elevador is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;

        pedidos  : in  STD_LOGIC_VECTOR(3 downto 0);
        busy     : in  STD_LOGIC;

        S0       : in  STD_LOGIC;
        S1       : in  STD_LOGIC;
        S2       : in  STD_LOGIC;
        S3       : in  STD_LOGIC;

        andar_atual : out STD_LOGIC_VECTOR(1 downto 0);
        arrive      : out STD_LOGIC;
        clear       : out STD_LOGIC_VECTOR(3 downto 0);

        move_up     : out STD_LOGIC;
        move_down   : out STD_LOGIC
    );
end controle_elevador;

architecture Behavioral of controle_elevador is

    signal estado : unsigned(1 downto 0) := "00";
    signal dir    : integer range -1 to 1 := 0;

    signal arrive_int : STD_LOGIC := '0';
    signal clear_int  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');

begin

    andar_atual <= std_logic_vector(estado);
    arrive      <= arrive_int;
    clear       <= clear_int;

    process(clk, rst)
        variable tem_pedido_acima  : boolean;
        variable tem_pedido_abaixo : boolean;
        variable idx               : integer;
        variable estado_sensor     : unsigned(1 downto 0);
    begin
        if rst = '1' then
            estado     <= "00";
            dir        <= 0;
            arrive_int <= '0';
            clear_int  <= (others => '0');
            move_up    <= '0';
            move_down  <= '0';

        elsif rising_edge(clk) then

            arrive_int <= '0';
            clear_int  <= (others => '0');
            move_up    <= '0';
            move_down  <= '0';

            estado_sensor := estado;

            -- Atualiza o andar atual a partir dos sensores físicos
            if S0 = '1' then
                estado_sensor := "00";
            elsif S1 = '1' then
                estado_sensor := "01";
            elsif S2 = '1' then
                estado_sensor := "10";
            elsif S3 = '1' then
                estado_sensor := "11";
            end if;

            estado <= estado_sensor;
            idx := to_integer(estado_sensor);

            -- Verifica pedidos acima e abaixo do andar atual
            tem_pedido_acima  := false;
            tem_pedido_abaixo := false;

            case idx is
                when 0 =>
                    if pedidos(1) = '1' or pedidos(2) = '1' or pedidos(3) = '1' then
                        tem_pedido_acima := true;
                    end if;

                when 1 =>
                    if pedidos(2) = '1' or pedidos(3) = '1' then
                        tem_pedido_acima := true;
                    end if;

                    if pedidos(0) = '1' then
                        tem_pedido_abaixo := true;
                    end if;

                when 2 =>
                    if pedidos(3) = '1' then
                        tem_pedido_acima := true;
                    end if;

                    if pedidos(0) = '1' or pedidos(1) = '1' then
                        tem_pedido_abaixo := true;
                    end if;

                when 3 =>
                    if pedidos(0) = '1' or pedidos(1) = '1' or pedidos(2) = '1' then
                        tem_pedido_abaixo := true;
                    end if;

                when others =>
                    null;
            end case;

            if busy = '0' then

                -- Se existe pedido no andar atual, atende
                if pedidos(idx) = '1' then
                    arrive_int <= '1';
                    clear_int(idx) <= '1';
                    dir <= 0;
                    move_up <= '0';
                    move_down <= '0';

                elsif dir = 1 and tem_pedido_acima then
                    dir <= 1;
                    move_up <= '1';

                elsif dir = -1 and tem_pedido_abaixo then
                    dir <= -1;
                    move_down <= '1';

                elsif tem_pedido_acima then
                    dir <= 1;
                    move_up <= '1';

                elsif tem_pedido_abaixo then
                    dir <= -1;
                    move_down <= '1';

                else
                    dir <= 0;
                    move_up <= '0';
                    move_down <= '0';
                end if;

            else
                move_up <= '0';
                move_down <= '0';
            end if;

        end if;
    end process;

end Behavioral;