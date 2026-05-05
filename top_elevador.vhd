library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_elevador is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        B0, B1, B2, B3 : in  STD_LOGIC;
        door     : out STD_LOGIC;      -- sinal da porta (LED)
        andar    : out STD_LOGIC_VECTOR(1 downto 0)  -- display do andar
    );
end top_elevador;

architecture Structural of top_elevador is
    signal pedidos : STD_LOGIC_VECTOR(3 downto 0);
    signal clear   : STD_LOGIC_VECTOR(3 downto 0);
    signal arrive  : STD_LOGIC;
    signal busy    : STD_LOGIC;
    signal andar_s : STD_LOGIC_VECTOR(1 downto 0);
begin
    -- Instância da memória de pedidos (Miguel)
    mem: entity work.memoria_pedidos
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
    
    -- Instância do controle de movimento (Sthefany)
    ctrl: entity work.controle_elevador
        port map (
            clk      => clk,
            rst      => rst,
            pedidos  => pedidos,
            busy     => busy,
            andar_atual => andar_s,
            arrive   => arrive,
            clear    => clear
        );
    
    -- Instância do controlador de porta (João)
    porta: entity work.door_controller
        generic map ( TIMER_MAX => 10 )  -- depois ajuste para 50_000_000
        port map (
            clk    => clk,
            reset  => rst,
            arrive => arrive,
            door   => door,
            busy   => busy
        );
    
    -- Saída do andar atual
    andar <= andar_s;
    
end Structural;
