; Starting code with basic constants and simple subroutine
; random comment

ORG 0
Start:
	; LOADI 1       ; forward directon 
	; OUT   Direct
	; IN   Switches
	; LOAD  PWMSpeed
	; OUT   PWM
	
	; if 30 rpm or 270 cps, need to jump start it 
	LOADI 1
	OUT Direct 
	LOAD  PWMSpeed
	OUT   PWM 
	
	; JUMP  Start 
	
	CALL  ReadVelocity
	LOAD  CurrVel
	JZERO Start
	
	SUB   DesiredVel
	OUT   Hex0 
	JNEG  IncPWM
	JPOS  DecPWM 
	JZERO Constant
	JUMP Start 
	
IncPWM: 
	LOADI 2
	OUT  Hex1 
	LOAD  PWMSpeed
	ADDI  1 
	STORE PWMSpeed
	OUT   Hex0
	OUT   PWM 
	LOADI 1
	OUT   Direct 
	JUMP  Reloop
	
DecPWM: 
	LOADI 5
	OUT  Hex1 
	LOAD PWMSpeed
	ADDI -1 
	STORE PWMSpeed
	OUT   Hex0
	OUT   PWM 
	LOADI 1
	OUT   Direct 
	JUMP  Reloop
	
	
Reloop: 
	JUMP Start 
	
Constant: 
	LOAD PWMSpeed
	OUT  Hex0
	; LOADI 0 
	OUT  PWM
	JUMP Start 
	
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