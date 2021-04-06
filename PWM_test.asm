; Starting code with basic constants and simple subroutine
; random comment

ORG 0
Start:
	IN    Switches
	OUT   PWM
	JUMP  Start

; IO address constants
Switches:  EQU &H000
PWM:       EQU &H021

