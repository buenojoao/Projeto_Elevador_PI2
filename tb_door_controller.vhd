library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_door_controller is
end tb_door_controller;

architecture Behavioral of tb_door_controller is

    signal clk    : STD_LOGIC := '0';
    signal rst    : STD_LOGIC := '0';
    signal arrive : STD_LOGIC := '0';

    signal door   : STD_LOGIC;
    signal busy   : STD_LOGIC;

begin

    uut : entity work.door_controller
        generic map (
            TIMER_MAX => 10
        )
        port map (
            clk    => clk,
            rst    => rst,
            arrive => arrive,
            door   => door,
            busy   => busy
        );

    clk <= not clk after 5 ns;

    process
    begin

        rst <= '1';
        wait for 20 ns;
        rst <= '0';

        wait for 20 ns;

        arrive <= '1';
        wait for 10 ns;
        arrive <= '0';

        wait for 200 ns;

        wait;

    end process;

end Behavioral;