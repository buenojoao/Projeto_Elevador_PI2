library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity motor_controller is
    generic (
        STEP_DELAY : integer := 200000
    );
    port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        move_up   : in  STD_LOGIC;
        move_down : in  STD_LOGIC;
        motor_out : out STD_LOGIC_VECTOR(3 downto 0)
    );
end motor_controller;

architecture Behavioral of motor_controller is

    signal step_index : integer range 0 to 7 := 0;
    signal counter    : integer range 0 to STEP_DELAY := 0;

begin

    process(clk, rst)
    begin
        if rst = '1' then
            step_index <= 0;
            counter    <= 0;
            motor_out  <= "0000";

        elsif rising_edge(clk) then

            if move_up = '1' and move_down = '0' then

                if counter < STEP_DELAY then
                    counter <= counter + 1;
                else
                    counter <= 0;

                    -- SUBIR = sentido anti-horario
                    if step_index = 0 then
                        step_index <= 7;
                    else
                        step_index <= step_index - 1;
                    end if;
                end if;

            elsif move_down = '1' and move_up = '0' then

                if counter < STEP_DELAY then
                    counter <= counter + 1;
                else
                    counter <= 0;

                    -- DESCER = sentido horario
                    if step_index = 7 then
                        step_index <= 0;
                    else
                        step_index <= step_index + 1;
                    end if;
                end if;

            else
                counter <= 0;
            end if;

            if move_up = '1' or move_down = '1' then
                case step_index is
                    when 0 =>
                        motor_out <= "1000";
                    when 1 =>
                        motor_out <= "1100";
                    when 2 =>
                        motor_out <= "0100";
                    when 3 =>
                        motor_out <= "0110";
                    when 4 =>
                        motor_out <= "0010";
                    when 5 =>
                        motor_out <= "0011";
                    when 6 =>
                        motor_out <= "0001";
                    when 7 =>
                        motor_out <= "1001";
                    when others =>
                        motor_out <= "0000";
                end case;
            else
                motor_out <= "0000";
            end if;

        end if;
    end process;

end Behavioral;