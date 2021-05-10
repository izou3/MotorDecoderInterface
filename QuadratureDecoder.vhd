-- QuadratureDecoder.vhd (a peripheral module for SCOMP)
-- This device increments/decrements a count
-- depending on the rotation of the motor.

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY QuadratureDecoder IS
	PORT(
		-- At least IO_DATA and a chip select are needed.  Even though
		-- this device will only respond to IN, IO_WRITE is included so
		-- that this device doesn't drive the bus during an OUT.
		A           : IN    STD_LOGIC;
		B				: IN    STD_LOGIC;
		CLK         : IN    STD_LOGIC;
		RESETN      : IN    STD_LOGIC;
		CS          : IN    STD_LOGIC;
		IO_WRITE    : IN    STD_LOGIC;
		Counter		: OUT	  STD_LOGIC_VECTOR(15 downto 0);
		IO_DATA     : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END QuadratureDecoder;

ARCHITECTURE a OF QuadratureDecoder IS
	SIGNAL AB0 : STD_LOGIC_VECTOR(1 downto 0); -- vectors for motor
	SIGNAL AB1 : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL AB : STD_LOGIC_VECTOR(1 downto 0); 
	SIGNAL count : STD_LOGIC_VECTOR(15 downto 0);
	
	--SIGNAL count : STD_LOGIC_VECTOR(15 downto 0);
	SIGNAL tri_enable : STD_LOGIC; -- enable signal for the tri-state driver
	
	TYPE state_type is (init, AB_00, AB_10, AB_11, AB_01);
	SIGNAL state : state_type;
	
	BEGIN
	AB0 <= A & B;
	tri_enable <= CS and (not IO_WRITE); -- only drive IO_DATA during IN
	
	-- Use LPM function to create tri-state driver for IO_DATA
	IO_BUS: lpm_bustri
	GENERIC MAP (
		lpm_width => 16
	)
	PORT MAP (
		data     => count,   -- Put the value on IO_DATA during IN
		enabledt => tri_enable,
		tridata  => IO_DATA
	);
	
	PROCESS (RESETN, CLK)
	BEGIN
	
		IF RESETN = '0' THEN
			count <= x"0000";
			Count <= x"0000";
			Counter <= x"0000"; 
			state <= init;
			
		ELSIF RISING_EDGE(CLK) THEN
		
			AB <= AB1;
			AB1 <= AB0;
		
			CASE state IS
			
				WHEN init =>
					IF AB = "00" THEN
						state <= AB_00;
					ELSIF AB = "01" THEN
						state <= AB_01;	
					ELSIF AB = "10" THEN
						state <= AB_10;	
					ELSIF AB = "11" THEN
						state <= AB_11;
					END IF;
			
				WHEN AB_00 =>
					IF AB = "10" THEN
						state <= AB_10;
						count <= count - 1;
						Counter <= count;
					ELSIF AB = "01" THEN
						state <= AB_01;
						count <= count + 1;
						Counter <= count;
					END IF;
					
				WHEN AB_10 =>
					IF AB = "00" THEN
						state <= AB_00;
						count <= count + 1;
						Counter <= count;
					ELSIF AB = "11" THEN
						state <= AB_11;
						count <= count - 1;
						Counter <= count;
					END IF;
					
				WHEN AB_11 =>
					IF AB = "10" THEN
						state <= AB_10;
						count <= count + 1;
						Counter <= count;
					ELSIF AB = "01" THEN
						state <= AB_01;
						count <= count - 1;
						Counter <= count;
					END IF;
					
				WHEN AB_01 =>
					IF AB = "00" THEN
						state <= AB_00;
						count <= count - 1;
						Counter <= count;
					ELSIF AB = "11" THEN
						state <= AB_11;
						count <= count + 1;
						Counter <= count;
					END IF;
	
				WHEN OTHERs =>
					
					
			END CASE;
					
		END IF;
	END PROCESS;

END a;

