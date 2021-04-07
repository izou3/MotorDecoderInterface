; Starting code with basic constants and simple subroutine
; random comment

ORG 0
Start:
	LOAD VelControlOn
	JPOS Velocity
	LOAD PosControlOn
	JPOS Position
	
Velocity:	
	; IN   Switches
	LOAD  VelControl 
	OUT   PWM
	
	IN    Quad
	OUT   Hex0
	
	JUMP  Velocity
	
Position:
	IN   Switches
	; LOAD  PosControlSpeed
	OUT   PWM
	
	IN 	  Quad
	CALL  Abs
	OUT   Hex0
	SUB   PosControl
	JZERO End
	
	JUMP  Position

End:
	LOAD  Zero
	OUT   PWM
	JUMP  End
	
Abs:
	JPOS   Abs_r        ; If already positive, return
Negate:
	XOR    NegOne       ; Flip all bits
	ADDI   1            ; Add one
Abs_r:
	RETURN


; IO address constants
Switches:  EQU &H000
Hex0:      EQU &H004
PWM:       EQU &H021
Quad:      EQU &H0F1

; constants
Zero:      DW 0
NegOne:    DW -1

VelControlOn:    DW 0
PosControlOn:	 DW 1
VelControl:      DW &B01111
PosControlSpeed: DW &B11001
PosControl:      DW 540
