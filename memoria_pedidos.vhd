library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memoria_pedidos is
    Port (
        clk     : in  STD_LOGIC;
        rst     : in  STD_LOGIC;
        B0, B1, B2, B3 : in  STD_LOGIC;          -- botões individuais
        clear   : in  STD_LOGIC_VECTOR(3 downto 0); -- clear(andar) = 1 apaga pedido
        pedidos : out STD_LOGIC_VECTOR(3 downto 0)  -- vetor de pedidos pendentes
    );
end memoria_pedidos;

architecture Behavioral of memoria_pedidos is
    signal pedidos_reg : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin
    process(clk, rst)
    begin
        if rst = '1' then
            pedidos_reg <= (others => '0');
        elsif rising_edge(clk) then
            -- Equação: novo_pedido = (antigo OR botao) AND NOT clear
            pedidos_reg(0) <= (pedidos_reg(0) or B0) and (not clear(0));
            pedidos_reg(1) <= (pedidos_reg(1) or B1) and (not clear(1));
            pedidos_reg(2) <= (pedidos_reg(2) or B2) and (not clear(2));
            pedidos_reg(3) <= (pedidos_reg(3) or B3) and (not clear(3));
        end if;
    end process;
    
    pedidos <= pedidos_reg;
end Behavioral;
