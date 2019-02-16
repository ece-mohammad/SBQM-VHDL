LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY clock_generic IS
    GENERIC
    (   
        clock_half_period_time   : time  := 25 ps
    );
    
    PORT
    (
        -- Input
        -- Output
        clk     : OUT   std_logic := '0'
    );
END ENTITY clock_generic;

ARCHITECTURE clock_behav OF clock_generic IS
BEGIN
    
CLOCK_PROC   :   PROCESS IS
    
    BEGIN
    
        clk <= '0';
        WAIT FOR clock_half_period_time;
        clk <= '1';
        WAIT FOR clock_half_period_time;
    
    END PROCESS CLOCK_PROC;
END ARCHITECTURE clock_behav;