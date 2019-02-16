LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY dff IS 
    PORT
    (
        -- Inputs
        clk, p      : IN    std_logic := '0';
        -- Outputs
        q           : OUT   std_logic
    );
END ENTITY dff;

ARCHITECTURE dff_behav OF dff IS 
BEGIN

    dff_proc    : PROCESS (clk) IS
    BEGIN

        IF rising_edge(clk) THEN
    
            q <= p;
    
        END IF; -- end IF rising_edge(clk)

    END PROCESS; -- end process dff_proc

END ARCHITECTURE dff_behav;