library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_memoria_pedidos is
end tb_memoria_pedidos;

architecture Behavioral of tb_memoria_pedidos is

    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';

    signal B0, B1, B2, B3 : STD_LOGIC := '0';

    signal clear   : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal pedidos : STD_LOGIC_VECTOR(3 downto 0);

begin

    uut : entity work.memoria_pedidos
        port map (
            clk     => clk,
            rst     => rst,
            B0      => B0,
            B1      => B1,
            B2      => B2,
            B3      => B3,
            clear   => clear,
            pedidos => pedidos
        );

    clk <= not clk after 5 ns;

    process
    begin

        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        wait for 20 ns;

        -- Pedido andar 0
        B0 <= '1';
        wait for 10 ns;
        B0 <= '0';

        wait for 20 ns;

        -- Pedido andar 2
        B2 <= '1';
        wait for 10 ns;
        B2 <= '0';

        wait for 20 ns;

        -- Limpa pedido andar 0
        clear(0) <= '1';
        wait for 10 ns;
        clear(0) <= '0';

        wait for 20 ns;

        -- Limpa pedido andar 2
        clear(2) <= '1';
        wait for 10 ns;
        clear(2) <= '0';

        wait for 50 ns;

        wait;

    end process;

end Behavioral;