library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_memoria_pedidos is
end tb_memoria_pedidos;

architecture sim of tb_memoria_pedidos is
    signal clk, rst : STD_LOGIC := '0';
    signal B0, B1, B2, B3 : STD_LOGIC := '0';
    signal clear : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal pedidos : STD_LOGIC_VECTOR(3 downto 0);
begin
    clk <= not clk after 5 ns;

    uut: entity work.memoria_pedidos
        port map(clk, rst, B0, B1, B2, B3, clear, pedidos);

    process
    begin
        rst <= '1'; wait for 20 ns;
        rst <= '0'; wait for 20 ns;

        B2 <= '1'; wait for 10 ns;
        B2 <= '0'; wait for 30 ns;

        clear <= "0100"; wait for 10 ns;
        clear <= "0000"; wait for 30 ns;

        wait;
    end process;
end sim;