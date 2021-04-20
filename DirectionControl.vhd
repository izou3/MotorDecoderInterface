-- PWM_GEN.VHD (a peripheral module for SCOMP)
-- 2021.03.20
--
-- Generates a square wave with duty cycle dependant on value
-- sent from SCOMP.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY DirectionControl IS
    PORT(CLK,
        RESETN,
        CS       : IN STD_LOGIC;
        IO_DATA  : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  Counter  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  IO_WRITE : IN STD_LOGIC;
        Foward   : OUT STD_LOGIC;
		  Reverse  : OUT StD_LOGIC 
    );
END DirectionControl;

ARCHITECTURE a OF DirectionControl IS

	 -- desired postion value entered by user from IO_Bus 
	 SIGNAL DesiredPos: STD_LOGIC_VECTOR(15 DOWNTO 0); 
	 
	 SIGNAL OldPos   : STD_LOGIC_VECTOR(15 DOWNTO 0);
	 SIGNAL CurrPos  : STD_LOGIC_VECTOR(15 DOWNTO 0);

	 SIGNAL Velocity : STD_LOGIC_VECTOR(15 DOWNTO 0);
	 SIGNAL IO_OUT    : STD_LOGIC;
	 
	 SIGNAL Quad    : integer;

    BEGIN
	 IO_OUT <= (CS AND NOT(IO_WRITE));

	 -- Use LPM function to create bidirection I/O data bus
	 IO_BUS: lpm_bustri
	 GENERIC MAP (
		lpm_width => 16
	 )
	 PORT MAP (
		data     => Velocity, -- latch Velocity signal into IO_DATA during IN 
		enabledt => IO_OUT,
		tridata  => IO_DATA
	 );
	 
	 IO_Handler: PROCESS (RESETN, CS)
    BEGIN
        -- Create a register to store the data sent from SCOMP
        IF (RESETN = '0') THEN
            DesiredPos <= x"0000";
        ELSIF rising_edge(CS) THEN
            -- When written to during OUT, latch IO_DATA into the DesiredPos signal.
				-- latch IO-Data here using DesiredPos signal
				
        END IF;

    END PROCESS;
	 

    Position_Control: PROCESS (RESETN, CS, CLK)
    BEGIN
			IF (RESETN = '0') THEN
				Foward <= '0'; 
				Reverse <= '0'; 
				
			-- position control 	
			ELSIF rising_edge(CLK) THEN 
				Quad <= to_integer(unsigned(Counter)); 
				Velocity <= Counter; 
				
				-- convert DesiredPos into unsigned and then to integer
				-- +/- 10 counts as the margin of error 
				-- Quad >= DesiredPos - 10 AND Quad <= DesiredPos + 10 
				
				IF Quad >= 1070 AND Quad <= 1090 THEN 
					Foward <= '0'; 
					Reverse <= '0'; 
					Velocity <= "0000000000000011"; -- velocity is just the output 
				ELSIF Quad > 1090 THEN 
					Foward <= '0'; 
					Reverse <= '1'; 
				ELSE 
					Foward <= '1'; 
					Reverse <= '0'; 
				END IF; 
					
        END IF;

    END PROCESS;
	 
--	 Read_Velocity: PROCESS (RESETN, CLK, CS) 
--	 BEGIN
--		IF (RESETN = '0') THEN 
--			Velocity <= x"0000";
--			
--		ELSIF rising_edge(CLK) AND CS = '0' THEN 
--			Quad <= to_integer(unsigned(Counter)); 
--				IF Quad > 1080 THEN 
--					Foward <= '0'; 
--					Reverse <= '0'; 
--					Velocity <= "0000000000000011"; 
--				END IF; 
--				
--		END IF; 
--	END PROCESS; 
	 
END a;