LIBRARY IEEE;
LIBRARY LPM;

USE IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.ALL;
USE LPM.LPM_COMPONENTS.ALL;

ENTITY Display IS
	PORT(
		Count       : IN    STD_LOGIC_VECTOR(15 downto 0);
		RESETN		: IN	  STD_LOGIC;
		CLK		   : IN	  STD_LOGIC;
		LED0			: OUT   STD_LOGIC;
		LED1        : OUT   STD_LOGIC;
		LED2        : OUT   STD_LOGIC;
		LED3        : OUT   STD_LOGIC;
		LED4        : OUT   STD_LOGIC;
		LED5        : OUT   STD_LOGIC;
		LED6			: OUT   STD_LOGIC;
		LED7        : OUT   STD_LOGIC;
		LED8        : OUT   STD_LOGIC;		
		LED9        : OUT   STD_LOGIC		
	);
END Display;

ARCHITECTURE a OF Display IS
	SIGNAL Counter    : integer;
	TYPE state_type is (zero, one, two, three, four, five, six, seven, eight, nine, ten);
	SIGNAL state : state_type;
	
	BEGIN

	Counter <= to_integer(unsigned(Count));

	PROCESS (RESETN, CLK)
	BEGIN
	
		IF RESETN = '0' THEN
			state <= zero;
			LED0 <= '0';
			LED1 <= '0';
			LED2 <= '0';
			LED3 <= '0';
			LED4 <= '0';
			LED5 <= '0';
			LED6 <= '0';
			LED7 <= '0';
			LED8 <= '0';
			LED9 <= '0';	
			
		ELSIF RISING_EDGE(CLK) THEN

			CASE state IS

				WHEN zero =>
					IF Counter < 540 THEN
						state <= zero;
					ELSE
						state <= one;
						LED0<='1';
					END IF;
			
				WHEN one =>
					IF Counter < 540 THEN
						state <= zero;
						LED0<='0';
					ELSE IF Counter < 1080 THEN
						state <= one;
					ELSE
						state <= two;
						LED1<='1';
					END IF;
					END IF;
					
				WHEN two =>
					IF Counter < 1080 THEN
						state <= one;
						LED1<='0';
					ELSE IF Counter < 1620  THEN
						state <= two;
					ELSE
						state <= three;
						LED2<='1';
					END IF;
					END IF;
					
				WHEN three =>
					IF Counter < 1620 THEN
						state <= two;
						LED2<='0';
					ELSE IF Counter < 2160  THEN
						state <= three;
					ELSE
						state <= four;
						LED3<='1';
					END IF;
					END IF;
					
				WHEN four =>
					IF Counter < 2160 THEN
						state <= three;
						LED3<='0';
					ELSE IF Counter < 2700  THEN
						state <= four;
					ELSE
						state <= five;
						LED4<='1';
					END IF;
					END IF;
					
				WHEN five =>
					IF Counter < 2700 THEN
						state <= four;
						LED4<='0';
					ELSE IF Counter < 3240  THEN
						state <= five;
					ELSE
						state <= six;
						LED5<='1';
					END IF;
					END IF;
			
				WHEN six =>
					IF Counter < 3240 THEN
						state <= five;
						LED5<='0';
					ELSE IF Counter < 3780  THEN
						state <= six;
					ELSE
						state <= seven;
						LED6<='1';
					END IF;
					END IF;
					
				WHEN seven =>
					IF Counter < 3780 THEN
						state <= six;
						LED6<='0';
					ELSE IF Counter < 4320  THEN
						state <= seven;
					ELSE
						state <= eight;
						LED7<='1';
					END IF;
					END IF;
					
				WHEN eight =>
					IF Counter < 4320 THEN
						state <= seven;
						LED7<='0';
					ELSE IF Counter < 4860  THEN
						state <= eight;
					ELSE
						state <= nine;
						LED8<='1';
					END IF;
					END IF;
					
				WHEN nine =>
					IF Counter < 5400 THEN
						state <= eight;
						LED8<='0';
					ELSE IF Counter < 5940  THEN
						state <= nine;
					ELSE
						state <= ten;
						LED9<='1';
					END IF;
					END IF;
					
				WHEN ten =>
					IF Counter < 5940 THEN
						state <= nine;
						LED9<='0';
					ELSE
						state <= ten;
					END IF;	
				WHEN OTHERs =>
					
					
			END CASE;
					
		END IF;
	END PROCESS;

END a;
