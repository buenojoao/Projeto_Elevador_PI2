library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_controle_elevador is
end tb_controle_elevador;

architecture sim of tb_controle_elevador is
    signal clk, rst : STD_LOGIC := '0';
    signal pedidos : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal busy : STD_LOGIC := '0';
    signal S0, S1, S2, S3 : STD_LOGIC := '0';
    signal andar_atual : STD_LOGIC_VECTOR(1 downto 0);
    signal arrive : STD_LOGIC;
    signal clear : STD_LOGIC_VECTOR(3 downto 0);
    signal move_up, move_down : STD_LOGIC;
begin
    clk <= not clk after 5 ns;

    uut: entity work.controle_elevador
        port map(clk, rst, pedidos, busy, S0, S1, S2, S3,
                 andar_atual, arrive, clear, move_up, move_down);

    process
    begin
        rst <= '1'; wait for 20 ns;
        rst <= '0'; wait for 20 ns;

        S0 <= '1'; wait for 20 ns;
        S0 <= '0';

        pedidos <= "1000"; wait for 50 ns;

        S1 <= '1'; wait for 20 ns; S1 <= '0';
        S2 <= '1'; wait for 20 ns; S2 <= '0';
        S3 <= '1'; wait for 40 ns; S3 <= '0';

        pedidos <= "0000"; wait for 50 ns;

        wait;
    end process;
end sim;