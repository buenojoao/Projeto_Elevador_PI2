library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_motor_controller is
end tb_motor_controller;

architecture sim of tb_motor_controller is
    signal clk, rst : STD_LOGIC := '0';
    signal move_up, move_down : STD_LOGIC := '0';
    signal motor_out : STD_LOGIC_VECTOR(3 downto 0);
begin
    clk <= not clk after 5 ns;

    uut: entity work.motor_controller
        generic map(STEP_DELAY => 3)
        port map(clk, rst, move_up, move_down, motor_out);

    process
    begin
        rst <= '1'; wait for 20 ns;
        rst <= '0'; wait for 20 ns;

        move_up <= '1'; wait for 200 ns;
        move_up <= '0'; wait for 50 ns;

        move_down <= '1'; wait for 200 ns;
        move_down <= '0'; wait for 50 ns;

        wait;
    end process;
end sim;