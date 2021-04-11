; Starting code with basic constants and simple subroutine
; random comment

ORG 0
Start:
	LOAD PosControlOn
	JPOS Position
	
Position:

	IN 	  Quad
	CALL  Abs
	OUT   Hex0
	SUB   PosControl
	JZERO End
	
	; IN   Switches
	LOAD  PosControlSpeed
	OUT   PWM
	
	JUMP  Position

End:
	LOAD  Zero
	OUT   PWM
	
	; IN Quad
	; CALL Abs
	; OUT Hex1
	
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
Hex1:      EQU &H005
PWM:       EQU &H021
Quad:      EQU &H0F1

; constants
Zero:      DW 0
NegOne:    DW -1

VelControlOn:    DW 0
PosControlOn:	 DW 1
PosControlSpeed: DW &B10000

VelControl:      DW &B01111
PosControl:      DW 1080
; DirControl:		 DW 
