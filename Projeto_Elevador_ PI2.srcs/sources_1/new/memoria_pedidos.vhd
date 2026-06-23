library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memoria_pedidos is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        B0, B1, B2, B3 : in  STD_LOGIC;
        clear   : in  STD_LOGIC_VECTOR(3 downto 0);
        pedidos : out STD_LOGIC_VECTOR(3 downto 0)
    );
end memoria_pedidos;

architecture Behavioral of memoria_pedidos is
    signal pedidos_reg : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal botoes_ant  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal botoes_atual: STD_LOGIC_VECTOR(3 downto 0);
    signal novos_pedidos : STD_LOGIC_VECTOR(3 downto 0);
begin

    botoes_atual <= B3 & B2 & B1 & B0;

    novos_pedidos <= botoes_atual and (not botoes_ant);

    process(clk, rst)
    begin
        if rst = '1' then
            pedidos_reg <= (others => '0');
            botoes_ant  <= (others => '0');

        elsif rising_edge(clk) then
            pedidos_reg <= (pedidos_reg or novos_pedidos) and (not clear);
            botoes_ant  <= botoes_atual;
        end if;
    end process;

    pedidos <= pedidos_reg;

end Behavioral;