LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fsm IS
	PORT
	(
		-- Inputs
		fsm_in_clk, fsm_in_reset	: IN std_logic := '0';
		fsm_in_sensors				: IN std_logic_vector (1 DOWNTO 0) := "00";
		fsm_in_pcount				: IN std_logic_vector (2 downto 0) := "000";
		
		-- Outputs
		fsm_out_updown				: OUT std_logic	:= '0';
		fsm_out_en					: OUT std_logic	:= '0';
		fsm_out_empty_flag			: OUT std_logic	:= '1';
		fsm_out_full_flag			: OUT std_logic	:= '0'
	);
		
END ENTITY fsm;

ARCHITECTURE fsm_behav OF fsm IS

-- Type to represent current FSM state
	TYPE fsm_state_type IS
	(
			fsm_empty_state,
			fsm_inc_dec_state,
			fsm_full_state
	);
	
	-- A signal that holds current fsm state
	SIGNAL fsm_current_state	:	fsm_state_type := fsm_empty_state;

	BEGIN

		-- FSM main process
		fsm_process	: PROCESS (fsm_in_clk, fsm_in_reset, fsm_in_sensors, fsm_current_state) IS
		BEGIN

			-- if reset is '1', change FSM state to `fsm_init_state`
			IF fsm_in_reset = '1' THEN

				fsm_current_state <= fsm_empty_state;					-- set current state to fsm_init_state
				fsm_out_empty_flag <= '1';								-- set empty flag
				fsm_out_full_flag <= '0';								-- reset full flag
				fsm_out_updown <= '0';									-- default value counting up
				fsm_out_en <= '0'; 										-- default enable OF counter IS zero
			
			-- check for rising edge in the clock signal 
			ELSIF rising_edge(fsm_in_clk) THEN	
				
				-- check current fsm state
				CASE fsm_current_state IS
						
					-- `fsm_empty_state` : Queue is empty --
					WHEN fsm_empty_state =>
						
						-- someone entered the queue
						IF  fsm_in_sensors = "01" THEN

							fsm_current_state <= fsm_inc_dec_state;		-- change state to fsm_inc_dec_state

							fsm_out_en <= '1';							-- enable counter
							fsm_out_updown <= '0';						-- counter will count up
						
							fsm_out_empty_flag <= '0';					-- reset the empty flag
							fsm_out_full_flag <= '0';					-- reset the full flag

						-- someone leaved the queue (probably a bug or a ghost)
						ELSIF fsm_in_sensors = "10" THEN
							
							fsm_current_state <= fsm_empty_state; 		-- stay in the same state

							fsm_out_en <= '0';							-- disable counter
							fsm_out_updown <= '0';						-- counter will count up

							fsm_out_empty_flag <= '1';					-- set the empty flag
							fsm_out_full_flag <= '0';					-- reset the full flag

							ASSERT fsm_in_sensors = "01" REPORT "Received a signal from exit sensor, but the queue is empty!" SEVERITY ERROR;
						
						ELSE 	-- when input IS or '11'
							
							fsm_current_state <= fsm_empty_state; 		-- stay in the same state

							fsm_out_en <= '0';							-- disable counter
							fsm_out_updown <= '0';						-- counter will count up

							fsm_out_empty_flag <= '1';					-- set the empty flag
							fsm_out_full_flag <= '0';					-- reset the full flag
						
						END IF;		-- END IF (someone entered the queue)
					
					-- `fsm_inc_dec_state` : Increment/Decrement state --
					-- Since FSM controls the counter operation, the counter is 1 cycle behind the FSM
					-- and the FSM needs the counter output to make dcisions, so the FSM takes decisions
					-- on `early counts`, or in other words, before the counter reaches that count, the FSM
					-- will take the decision EX:
					-- FSM will take decision 'A' when counter reaches '0', so the FSM will check counter for '1'
					-- If the counter is currently at '1' and it will count down to '0', then the FSM will make
					-- the decisiong 'A' even though the current value in the counter is '1'
					WHEN fsm_inc_dec_state =>
						
						-- someone entered the queue
						IF fsm_in_sensors = "01" THEN 
							
							-- if pcount is 6 or 7, change state to fsm_full_state
							-- case 7 is when someone enters, someone leaves then someone enters the queue in successive cycles
							-- since the counter is 1 cycle behind the fsm, its feedback is 2 cycles late
							-- 1st clock : the fsm senses the changes in its inputs
							-- 2nd clock : fsm senses changes in inputs, goes into full state, sends en/up signals to counter, counter is still at 6
							-- 3rd clock** : fsm senses changes in inputs, goes into inc_dec state, sends en/dwn signal to counter, counter is at 7
							-- 4th clock : inputs are 0, fsm goes into full state, sends en/up signal to counter, counter is at 6
							-- 5th clock : fsm doesn't change its state, disables counter, counter is at 7
							-- A corner case happens at clock 3, as the counter feedback to fsm is lagging. So the condition must check for both
							-- 6 or 7 feedback values from the counter
							-- The same case happens around empty state, so the fsm checks for 0 and 1 values from the counter feedback
							IF fsm_in_pcount = "110" OR fsm_in_pcount = "111" THEN

								-- change current state to full
								fsm_current_state <= fsm_full_state;	-- chage current state to full
								
								fsm_out_en <= '1';						-- enable counter
								fsm_out_updown <= '0';					-- counter will count up

								fsm_out_empty_flag <= '0';				-- reset fsm_empty_state flag
								fsm_out_full_flag <= '1';				-- set fsm_full_state flag		

							ELSE
								
								fsm_current_state <= fsm_inc_dec_state;	-- keep current state	
								
								fsm_out_en <= '1';						-- enable counter
								fsm_out_updown <= '0';					-- counter will count up
								
								fsm_out_empty_flag <= '0';				-- reset fsm_empty_state flag
								fsm_out_full_flag <= '0';				-- reset fsm_full_state flag
							
							END IF;		-- end if fsm_in_pcount = "110" (6)
						
						-- Somone left the queue
						ELSIF fsm_in_sensors = "10" THEN 
							
							-- If pcount is 1, change state to fsm_empty_state
							IF fsm_in_pcount = "001" OR fsm_in_pcount = "000" THEN
								
								fsm_current_state <= fsm_empty_state;	-- change state to empty

								fsm_out_en <= '1';						-- enable counter
								fsm_out_updown <= '1';					-- counter will count down

								fsm_out_empty_flag <= '1';				-- set fsm_empty_state flag
								fsm_out_full_flag <= '0';				-- reset fsm_full_state flag

							ELSE 
								
								fsm_current_state <= fsm_inc_dec_state;	-- keep current state

								fsm_out_en <= '1';						-- enable counter
								fsm_out_updown <= '1';					-- counter will count down

								fsm_out_empty_flag <= '0';				-- reset fsm_empty_state flag
								fsm_out_full_flag <= '0';				-- reset fsm_full_state flag
							
							END IF;		-- END IF fsm_in_pcount = "001" (1)
						
						-- either "00" (no one entered and no one left) 
						-- or "11" (someone entered and someopne left at the same moment)
						-- don't change anything
						ELSE
						
							fsm_current_state <= fsm_inc_dec_state;		-- keep current state

							fsm_out_en <= '0';							-- disable counter
							fsm_out_updown <= '0';						-- counter will count up

							fsm_out_empty_flag <= '0';					-- reset fsm_empty_state flag
							fsm_out_full_flag <= '0';					-- reset fsm_full_state flag
						
						END IF;	-- end if fsm_in_sensors(1) = 1
						
					-- `fsm_full_state` : FULL --	
					WHEN fsm_full_state =>
						
						-- if someone left the queue
						IF fsm_in_sensors = "10" THEN
							
							-- change current state
							fsm_current_state <= fsm_inc_dec_state;		-- change current state to fsm_inc_dec_state
							
							fsm_out_en <= '1'; 							-- enable counter 
							fsm_out_updown <= '1';						-- counter will count down

							fsm_out_empty_flag <= '0';					-- reset empty flag
							fsm_out_full_flag <= '0';					-- reset full flag 
						
						ELSIF fsm_in_sensors = "01" THEN

							fsm_current_state <= fsm_full_state;		-- keep current state fsm_inc_dec_state
							
							fsm_out_en <= '0'; 							-- disable counter 
							fsm_out_updown <= '0';						-- counter will count up

							fsm_out_empty_flag <= '0';					-- reset empty flag
							fsm_out_full_flag <= '1';					-- set full flag
						
							ASSERT fsm_in_sensors = "10" REPORT "Received a signal from enter sensor, but the queue is full!" SEVERITY ERROR;

						ELSE

							fsm_current_state <= fsm_full_state;		-- keep current state fsm_inc_dec_state
							
							fsm_out_en <= '0'; 							-- disable counter 
							fsm_out_updown <= '0';						-- counter will count up

							fsm_out_empty_flag <= '0';					-- reset empty flag
							fsm_out_full_flag <= '1';					-- set full flag 		
						
						END IF; -- end if fsm_in_sensors(1) = 1
				
				END CASE;	-- end case fsm_current_state

			END IF;	-- end if fsm_in_reset is 1

		END PROCESS fsm_process;	-- end fsm_process

END ARCHITECTURE fsm_behav;	-- end fsm_architecture