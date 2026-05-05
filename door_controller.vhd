library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity door_controller is
    generic ( TIMER_MAX : integer := 10 );
    port (
        clk    : in  STD_LOGIC;
        rst  : in  STD_LOGIC;
        arrive : in  STD_LOGIC;
        door   : out STD_LOGIC;
        busy   : out STD_LOGIC
    );
end door_controller;

architecture Behavioral of door_controller is
    type state_type is (IDLE, OPENING);
    signal state   : state_type;
    signal counter : integer range 0 to TIMER_MAX;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state   <= IDLE;
            counter <= 0;
            door    <= '0';
            busy    <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if arrive = '1' then
                        state   <= OPENING;
                        counter <= TIMER_MAX;
                        door    <= '1';
                        busy    <= '1';
                    end if;
                when OPENING =>
                    if counter > 0 then
                        counter <= counter - 1;
                    else
                        state   <= IDLE;
                        door    <= '0';
                        busy    <= '0';
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
