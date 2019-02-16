LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY rising_edge_detector IS
    PORT 
    (
        -- Input
        ed_in                       : IN    std_logic := '0';
        clk                         : IN    std_logic := '0';
        -- Output
        ed_out_rising               : OUT   std_logic := '0'
    );
END ENTITY rising_edge_detector;

ARCHITECTURE rising_edge_detector_behav OF rising_edge_detector IS

    -- A signal that holds last input value
    SIGNAL ed_last_input_sig        : std_logic := '0';

BEGIN

    -- edge detector process
    edge_detector_proc :   PROCESS (clk)   IS BEGIN

        -- check for rising edge on clock
        IF rising_edge(clk) THEN

            -- check for rising edge in ed_in
            IF ed_last_input_sig = '0' AND ed_in = '1' THEN

                ed_out_rising <= '1';           -- set ed_out_rising_edge

            -- otherwise
            ELSE
                
                ed_out_rising <= '0';

            END IF; -- end if rising_edge(ed_in)

            ed_last_input_sig <= ed_in;     -- save current input in ed_last_input_sig

        END IF; -- end if rising_edge(clk)

    END PROCESS edge_detector_proc;

END ARCHITECTURE rising_edge_detector_behav;