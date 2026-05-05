library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controle_elevador is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        pedidos  : in  STD_LOGIC_VECTOR(3 downto 0);
        busy     : in  STD_LOGIC;                       -- vindo do door_controller
        andar_atual : out STD_LOGIC_VECTOR(1 downto 0); -- para display e para a porta
        arrive   : out STD_LOGIC;                       -- pulso para door_controller
        clear    : out STD_LOGIC_VECTOR(3 downto 0)     -- limpeza de pedido atendido
    );
end controle_elevador;

architecture Behavioral of controle_elevador is
    signal estado : unsigned(1 downto 0) := "00";
    signal dir    : integer range -1 to 1 := 0;   -- -1 = descendo, 0 = parado, 1 = subindo
    signal arrive_int : STD_LOGIC;
begin
    andar_atual <= std_logic_vector(estado);
    
    -- Geração de arrive e clear (combinacional)
    process(estado, pedidos)
        variable idx : integer;
    begin
        idx := to_integer(estado);
        if pedidos(idx) = '1' then
            arrive_int <= '1';
            clear <= (others => '0');
            clear(idx) <= '1';
        else
            arrive_int <= '0';
            clear <= (others => '0');
        end if;
    end process;
    arrive <= arrive_int;
    
    -- Lógica de decisão da próxima direção (com memória)
    process(estado, pedidos, dir, busy)
        variable tem_pedido_acima, tem_pedido_abaixo : boolean;
    begin
        -- Verifica se há pedido em andar superior
        tem_pedido_acima := false;
        for i in to_integer(estado)+1 to 3 loop
            if pedidos(i) = '1' then
                tem_pedido_acima := true;
            end if;
        end loop;
        
        -- Verifica se há pedido em andar inferior
        tem_pedido_abaixo := false;
        for i in 0 to to_integer(estado)-1 loop
            if pedidos(i) = '1' then
                tem_pedido_abaixo := true;
            end if;
        end loop;
        
        -- Atualiza direção (somente se não estiver ocupado pela porta)
        if busy = '0' then
            if dir = 1 and tem_pedido_acima then
                -- continua subindo
                null;
            elsif dir = -1 and tem_pedido_abaixo then
                -- continua descendo
                null;
            elsif tem_pedido_acima then
                dir <= 1;
            elsif tem_pedido_abaixo then
                dir <= -1;
            else
                dir <= 0;
            end if;
        end if;
    end process;
    
    -- Movimentação síncrona (atualiza estado)
    process(clk, rst)
    begin
        if rst = '1' then
            estado <= "00";
            dir <= 0;
        elsif rising_edge(clk) then
            -- Se há pedido no andar atual e a porta ainda não está ocupada (busy=0),
            -- geramos arrive e não movemos neste ciclo (o door_controller vai ativar busy)
            if pedidos(to_integer(estado)) = '1' then
                -- Não se move, aguarda o door_controller
                null;
            elsif busy = '0' then
                if dir = 1 then
                    estado <= estado + 1;
                elsif dir = -1 then
                    estado <= estado - 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
