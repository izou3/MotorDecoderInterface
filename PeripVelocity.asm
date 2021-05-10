; Starting code with basic constants and simple subroutine
; random comment

ORG 0
Start:
	LOADI 15
	OUT Hex1
	LOAD DesiredPos       ; load in count value forward directon 
	OUT   Direct
	
ActualStart: 
	IN    Switches
	OUT   PWM
	; ; 
	
	CALL ReadVelocity
	LOAD  CurrVel
	OUT Hex0
	; CALL Delay
	;IN Direct 
	; SHIFT 5 
	;OUT Hex0 
		
	JUMP  ActualStart 
	
	
ReadVelocity:
	CALL	Delay
	IN		Quad
	SUB		OldPos
	SHIFT	5	
	OUT		Hex0
	STORE	CurrVel
	IN 		Quad 
	STORE	OldPos
	RETURN
	
Delay:
	OUT	Timer ; writing something to timer resets it to 0 

WaitingLoop:
	IN	Timer		; time counts up to 10 in 1 sec or at 10 Hz 
	ADDI	-1 		; waiting 1/32 of a second 
	JNEG	WaitingLoop
	RETURN


; IO address constants
Switches:  EQU &H000
Hex0:      EQU &H004
Hex1:	   EQU &H005
PWM:       EQU &H021
Direct:    EQU &H022
BTN:    EQU &H023
Quad:      EQU &H0F1
Timer:	   EQU &H002


; constants
Zero:      DW 0
NegOne:    DW -1

VelControlOn:    DW 1
PosControlOn:	 DW 0
VelControl:      DW &B01111
PosControlSpeed: DW &B11001
PosControl:      DW 540
Countprev:	 	 DW 0
OldPos: 		 DW 0 
DesiredVel: 	 DW 270 ; 360 = 1 rev in 1.5 seconds
CurrVel: 		 DW 0 
PWMSpeed: 	     DW 20
DesiredPos:      DW 5400
Velocity: 		 DW 0 