LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


ENTITY BCD_7segment IS

	PORT
	(
		BCD_in_sevensegment				: IN	std_logic_vector (3 DOWNTO 0) := "0000";
		sevensegment_out_BCD_7segment	: OUT	std_logic_vector (6 DOWNTO 0) := "0000000"
	);

END ENTITY BCD_7segment;

ARCHITECTURE behav_7segment OF BCD_7segment IS 

	BEGIN
	
	BCD_sevensegment_proc	:	PROCESS(BCD_in_sevensegment) IS
	BEGIN

				CASE BCD_in_sevensegment IS
					
					WHEN "0000" =>	-- digit 0 
					sevensegment_out_BCD_7segment <= "0000001";

					WHEN "0001" =>	-- digit 1
					sevensegment_out_BCD_7segment <= "1001111";
					
					WHEN "0010" =>	-- digit 2
					sevensegment_out_BCD_7segment <= "0010010";
					
					WHEN "0011" =>	-- digit 3
					sevensegment_out_BCD_7segment <= "0000110";
					
					WHEN "0100" =>	-- digit 4
					sevensegment_out_BCD_7segment <= "1001100";
					
					WHEN "0101" =>	-- digit 5
					sevensegment_out_BCD_7segment <= "0100100";
					
					WHEN "0110" => 	-- digit 6
					sevensegment_out_BCD_7segment <= "0100000";
					
					WHEN "0111" =>	-- digit 7
					sevensegment_out_BCD_7segment <= "0001111";
					
					WHEN "1000" =>	-- digit 8
					sevensegment_out_BCD_7segment <= "0000000";
					
					WHEN "1001" =>	-- digit 9
					sevensegment_out_BCD_7segment <= "0000100";
					
					WHEN OTHERS => 	-- others
					sevensegment_out_BCD_7segment <= "1111110";
				
				END CASE;	-- end case BCD_in_sevensegment
		
		END PROCESS BCD_sevensegment_proc;	-- end process BCD_sevensegment_proc 

END ARCHITECTURE behav_7segment;	-- end architecture behav_7segment
				
				