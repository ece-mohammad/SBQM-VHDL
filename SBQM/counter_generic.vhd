LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

ENTITY counter_generic IS 
    GENERIC (   size    : positive  := 2 );
    PORT
    (
        -- Input
        counter_in_rst, counter_in_en, counter_in_updown, couter_in_clk : IN    std_logic := '0';
        -- Output
        counter_out                                                     : OUT   std_logic_vector ((size -1) DOWNTO 0)
    );
END ENTITY counter_generic;

ARCHITECTURE counter_generic_behav OF counter_generic IS

-- Counter current count
SIGNAL  counter_sig_current_count   :   unsigned ((size - 1) DOWNTO 0) := to_unsigned(0, size);
BEGIN

    -- Counter process
    COUNTER_PROC    : PROCESS (counter_in_rst, couter_in_clk) IS
    BEGIN

        -- Check reset signal
        IF counter_in_rst = '1' THEN
            -- reset counter value   
            counter_sig_current_count <= to_unsigned(0, size);
    
        ELSE

            -- check clock rising edge and enable
            IF rising_edge (couter_in_clk) AND counter_in_en = '1' THEN
    
                -- check counting direction
                IF counter_in_updown = '0' THEN
                   
                    -- count up (increment)
                    counter_sig_current_count <= counter_sig_current_count + 1;
        
                ELSE
    
                    -- count down (decrement)
                    counter_sig_current_count <= counter_sig_current_count - 1;
              
                END IF; -- end if ( count direction )
        
            END IF; -- end if (clock and enable)
    
        END IF; -- end if ( reset signal )
    
    END PROCESS COUNTER_PROC;
    
    -- update counter output 
    counter_out <= std_logic_vector(counter_sig_current_count);

END ARCHITECTURE counter_generic_behav;