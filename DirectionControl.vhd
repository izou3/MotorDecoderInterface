-- PWM_GEN.VHD (a peripheral module for SCOMP)
-- 2021.03.20
--
-- Generates a square wave with duty cycle dependant on value
-- sent from SCOMP.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY DirectionControl IS
    PORT(CLK,
      RESETN,
      CS       : IN STD_LOGIC;
		  VELCLK   : IN STD_LOGIC; 
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
	 
	 SIGNAL Velocity : STD_LOGIC_VECTOR(15 DOWNTO 0);
	 SIGNAL StableVel : STD_LOGIC_VECTOR(15 DOWNTO 0);
	 
	 SIGNAL IO_OUT    : STD_LOGIC;
	 
	 SIGNAL Quad    : integer;
	 SIGNAL VelQuad   : integer; 
	 SIGNAL DesPosVar : integer;
	 SIGNAL OldPos	   : integer; 
	 SIGNAL VelInt    : integer; 

    BEGIN
	 IO_OUT <= (CS AND NOT(IO_WRITE));

	 -- Use LPM function to create bidirection I/O data bus
	 IO_BUS: lpm_bustri
	 GENERIC MAP (
		lpm_width => 16
	 )
	 PORT MAP (
		data     => StableVel, -- latch Stable Velocity signal into IO_DATA during IN 
		enabledt => IO_OUT,
		tridata  => IO_DATA
	 );
	 
	 IO_Handler: PROCESS (RESETN, CS)
    BEGIN
        -- Create a register to store the data sent from SCOMP
        IF (RESETN = '0') THEN
            DesiredPos <= x"0000";
        ELSIF (CS AND IO_WRITE) = '1' THEN
            -- When written to during OUT, latch IO_DATA into the DesiredPos signal.
				-- latch IO-Data here using DesiredPos signal
				DesiredPos <= IO_DATA(15 DOWNTO 0);
				-- StableVel <= x"0000";
        END IF;

    END PROCESS;
	 

    Position_Control: PROCESS (RESETN, CS, CLK)
    BEGIN
			IF (RESETN = '0') THEN
				Foward <= '0'; 
				Reverse <= '0'; 
				StableVel <= x"0000"; 
			-- position control 	
			ELSIF rising_edge(CLK) THEN 
				Quad <= to_integer(unsigned(Counter)); 
				
				-- Velocity <= DesiredPos; 
				
				DesPosVar <= to_integer(unsigned(DesiredPos));
				
				-- convert DesiredPos into unsigned and then to integer
				-- +/- 10 counts as the margin of error 
				-- Quad >= DesiredPos - 10 AND Quad <= DesiredPos + 10 
				
--				IF Quad >= 1070 AND Quad <= 1090 THEN 
				IF Quad >= (DesPosVar - 10) AND Quad <= (DesPosVar + 10) THEN 
					Foward <= '0'; 
					Reverse <= '0'; 
					StableVel <= "0000000000000011"; -- StableVel is just the output 
				ELSIF Quad > (DesPosVar +10) THEN 
					Foward <= '0'; 
					Reverse <= '1';
					StableVel <= x"0000"; 	
				ELSE 
					Foward <= '1'; 
					Reverse <= '0'; 
					StableVel <= x"0000";
				END IF; 
					
    END IF;

    END PROCESS;
	 
Read_Velocity: PROCESS (RESETN, VELCLK, CS) 
   BEGIN
      IF (RESETN = '0') THEN 
        Velocity <= x"0000";
        VelQuad <= 0; 
        StableVel <= x"0000"; 

      ELSIF rising_edge(VELCLK) AND CS = '0' THEN 
        VelQuad <= to_integer(signed(Counter)); -- quad count

        VelInt <= abs(VelQuad - OldPos); 

        Velocity <= std_logic_vector(to_signed(VelInt, 16)); 

        OldPos <= VelQuad; 
        StableVel <= Velocity; 

      ELSIF CS = '1' THEN 
        StableVel <= StableVel; 

      END IF; 
  END PROCESS; 
	 
END a;