library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity door_controller is
    generic (
        SAFETY_MAX : integer := 100000000; -- delay antes de abrir
        TIMER_MAX  : integer := 300000000  -- tempo com porta aberta
    );
    port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        arrive : in  STD_LOGIC;
        door   : out STD_LOGIC;
        busy   : out STD_LOGIC
    );
end door_controller;

architecture Behavioral of door_controller is

    type state_type is (IDLE, SAFETY_DELAY, OPENING);
    signal state : state_type := IDLE;

    signal counter : integer range 0 to TIMER_MAX := 0;

begin

    process(clk, rst)
    begin
        if rst = '1' then
            state   <= IDLE;
            counter <= 0;
            door    <= '0';
            busy    <= '0';

        elsif rising_edge(clk) then

            case state is

                when IDLE =>
                    door <= '0';
                    busy <= '0';
                    counter <= 0;

                    if arrive = '1' then
                        state   <= SAFETY_DELAY;
                        counter <= SAFETY_MAX;
                        busy    <= '1';
                    end if;

                when SAFETY_DELAY =>
                    door <= '0';
                    busy <= '1';

                    if counter > 0 then
                        counter <= counter - 1;
                    else
                        state   <= OPENING;
                        counter <= TIMER_MAX;
                        door    <= '1';
                        busy    <= '1';
                    end if;

                when OPENING =>
                    door <= '1';
                    busy <= '1';

                    if counter > 0 then
                        counter <= counter - 1;
                    else
                        state   <= IDLE;
                        counter <= 0;
                        door    <= '0';
                        busy    <= '0';
                    end if;

            end case;

        end if;
    end process;

end Behavioral;