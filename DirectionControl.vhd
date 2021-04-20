-- PWM_GEN.VHD (a peripheral module for SCOMP)
-- 2021.03.20
--
-- Generates a square wave with duty cycle dependant on value
-- sent from SCOMP.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY DirectionControl IS
    PORT(CLK,
        RESETN,
        CS       : IN STD_LOGIC;
        IO_DATA  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Foward   : OUT STD_LOGIC;
		  Reverse  : OUT StD_LOGIC 
    );
END DirectionControl;

ARCHITECTURE a OF DirectionControl IS
    SIGNAL COUNT    : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL COMPARE  : STD_LOGIC_VECTOR(4 DOWNTO 0);

    BEGIN

    Direction_Decoder: PROCESS (RESETN, CS)
    BEGIN
        -- Create a register to store the data sent from SCOMP
        IF (RESETN = '0') THEN
            COUNT <= "00000";
        ELSIF rising_edge(CS) THEN
            -- When written to, latch IO_DATA into the compare register.
            COUNT <= IO_DATA(4 DOWNTO 0);
				
				IF (COUNT = "00001") THEN  
					Foward <= '1'; 
					Reverse <= '0'; 
					
				ELSIF (COUNT = "00010") THEN
					Foward <= '0'; 
					Reverse <= '1'; 
				
				ELSE 
					Foward <= '0'; 
					Reverse <= '0'; 
					
				END IF; 
					
        END IF;

    END PROCESS;

END a;