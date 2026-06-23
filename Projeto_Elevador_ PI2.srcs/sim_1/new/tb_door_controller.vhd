library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_door_controller is
end tb_door_controller;

architecture sim of tb_door_controller is
    signal clk, rst, arrive : STD_LOGIC := '0';
    signal door, busy : STD_LOGIC;
begin
    clk <= not clk after 5 ns;

    uut: entity work.door_controller
        generic map(SAFETY_MAX => 5, TIMER_MAX => 10)
        port map(clk, rst, arrive, door, busy);

    process
    begin
        rst <= '1'; wait for 20 ns;
        rst <= '0'; wait for 20 ns;

        arrive <= '1'; wait for 10 ns;
        arrive <= '0'; wait for 300 ns;

        wait;
    end process;
end sim;