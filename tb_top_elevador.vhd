library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top_elevador is
end tb_top_elevador;

architecture Behavioral of tb_top_elevador is

    signal clk   : STD_LOGIC := '0';
    signal rst   : STD_LOGIC := '0';

    signal B0    : STD_LOGIC := '0';
    signal B1    : STD_LOGIC := '0';
    signal B2    : STD_LOGIC := '0';
    signal B3    : STD_LOGIC := '0';

    signal door  : STD_LOGIC;
    signal andar : STD_LOGIC_VECTOR(1 downto 0);

begin

    uut : entity work.top_elevador
        port map (
            clk   => clk,
            rst   => rst,
            B0    => B0,
            B1    => B1,
            B2    => B2,
            B3    => B3,
            door  => door,
            andar => andar
        );

    clk <= not clk after 5 ns;

    process
    begin

        -- Reset inicial
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        wait for 20 ns;

        -- Pedido para o andar 2
        B2 <= '1';
        wait for 10 ns;
        B2 <= '0';

        -- Aguarda movimentação e abertura da porta
        wait for 180 ns;

        -- Pedido para o andar 0
        B0 <= '1';
        wait for 10 ns;
        B0 <= '0';

        -- Aguarda retorno e abertura da porta
        wait for 220 ns;

        wait;

    end process;

end Behavioral;