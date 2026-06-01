library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_controle_elevador is
end tb_controle_elevador;

architecture Behavioral of tb_controle_elevador is

    signal clk          : STD_LOGIC := '0';
    signal rst          : STD_LOGIC := '0';
    signal pedidos      : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal busy         : STD_LOGIC := '0';

    signal andar_atual  : STD_LOGIC_VECTOR(1 downto 0);
    signal arrive       : STD_LOGIC;
    signal clear        : STD_LOGIC_VECTOR(3 downto 0);

begin

    uut : entity work.controle_elevador
        port map (
            clk         => clk,
            rst         => rst,
            pedidos     => pedidos,
            busy        => busy,
            andar_atual => andar_atual,
            arrive      => arrive,
            clear       => clear
        );

    clk <= not clk after 5 ns;

    process
    begin

        -- Reset inicial
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        wait for 20 ns;

        -- Cenário 1: pedido no andar 2
        -- Esperado: elevador sai do andar 0, vai para 1, depois 2.
        pedidos <= "0100";
        wait for 80 ns;

        -- Simula a porta ocupada após chegada
        busy <= '1';
        wait for 40 ns;

        -- Pedido é limpo externamente após atendimento
        pedidos <= "0000";
        busy <= '0';
        wait for 40 ns;

        -- Cenário 2: pedido no andar 0
        -- Esperado: elevador desce até o andar 0.
        pedidos <= "0001";
        wait for 100 ns;

        pedidos <= "0000";
        wait for 40 ns;

        wait;

    end process;

end Behavioral;