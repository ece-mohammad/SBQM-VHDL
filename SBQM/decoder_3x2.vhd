LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY decoder_3x2 IS
    PORT
    (
        -- Input
        p   : IN    std_logic_vector(2 DOWNTO 0)    := "000";
        -- Output
        q   : OUT   std_logic_vector (1 DOWNTO 0)   := "00"
    );
END ENTITY decoder_3x2;

ARCHITECTURE decoder_3x2_behav OF decoder_3x2 IS
BEGIN

    -- Decosder process
    decode_proc : PROCESS (p) IS
    BEGIN

        CASE p IS

        --  no tellers are there
        WHEN "000" =>
            q <= "00";

        --  1 teller
        WHEN "100" | "010" | "001" =>
            q <= "01";

        --  2 tellers
        WHEN "110" | "011" | "101" =>
            q <= "10";

        -- 3 tellers
        WHEN "111" =>
            q <= "11";
        
        -- Other cases
        WHEN OTHERS =>
            q <= "00";

        END CASE;   -- end case p

    END PROCESS;

END ARCHITECTURE decoder_3x2_behav;
