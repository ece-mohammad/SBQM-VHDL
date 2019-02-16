LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE std.textio.ALL;
USE ieee.std_logic_textio.ALL;

ENTITY rom IS 
	GENERIC
	(
		n	: integer	:= 5;
		m	: integer	:= 8
	);
			
	PORT
	(
		-- Input
		addr_in_rom		: IN 	std_logic_vector (n-1 DOWNTO 0);
		enable_in_rom	: IN 	std_logic	:= '1';
		-- Output
		data_out_rom	: OUT	std_logic_vector (m-1 DOWNTO 0)
	);
		
END ENTITY rom;

ARCHITECTURE ROM_function_arch OF rom IS

	TYPE rm IS
	ARRAY (0 TO 2**n-1) OF std_logic_vector (m-1 DOWNTO 0);
	
	IMPURE FUNCTION rom_fill RETURN rm IS
		
		VARIABLE	memory	:	rm;
		FILE 	f	: text	OPEN	READ_MODE	IS	"rom.txt";
		VARIABLE l	: line;

		BEGIN

			FOR index IN memory'RANGE LOOP

				readline (f, l);
				read (l, memory(index));
				
			END LOOP;

			RETURN memory;
	
	END FUNCTION rom_fill;

	CONSTANT word	:	rm	:= rom_fill;

BEGIN

	memory: PROCESS (enable_in_rom, addr_in_rom) IS BEGIN

		IF enable_in_rom = '1' THEN

			data_out_rom <= word(conv_integer(addr_in_rom));
		
		ELSE
	
			data_out_rom <= (OTHERS => 'Z');
		
		END IF;
	
	END PROCESS memory;

END ARCHITECTURE ROM_function_arch;