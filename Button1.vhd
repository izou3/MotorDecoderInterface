-- button1R.VHD (a peripheral module for SCOMP)
-- 2021.03.20
--

LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY button1 IS
    PORT(CLK,
        RESETN,
        CS       : IN STD_LOGIC;
		  BUTTON   : IN STD_LOGIC;
		  IO_WRITE : IN STD_LOGIC;
        IO_DATA  : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END button1;

ARCHITECTURE a OF button1 IS

	SIGNAL count : STD_LOGIC_VECTOR(15 downto 0);
   SIGNAL tri_enable : STD_LOGIC; -- enable signal for the tri-state driver
	 
	BEGIN 	
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
	
		ELSIF RISING_EDGE(CLK) THEN
		
			IF BUTTON = '1' THEN
				count <= "0000000000000001";
			ELSE
				count <= "0000000000000000";
			END IF;
		
		END IF;
	END PROCESS;
	
	
END a;