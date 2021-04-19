; Starting code with basic constants and simple subroutine
; random comment

ORG 0
Start:
	CALL SetupArrays


SetupArrays:
	; index 0
	LOAD Vel1
	ISTORE VelArrIndex
	LOAD Pos1
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADD  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADD  1
	STORE VelArrIndex
	
	; index 1
	LOAD Vel2
	ISTORE VelArrIndex
	LOAD Pos2
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADD  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADD  1
	STORE VelArrIndex
	
	; index 2
	LOAD Vel3
	ISTORE VelArrIndex
	LOAD Pos3
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADD  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADD  1
	STORE VelArrIndex
	
	; index 3
	LOAD Vel4
	ISTORE VelArrIndex
	LOAD Pos4
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADD  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADD  1
	STORE VelArrIndex
	
	; index 4
	LOAD Vel5
	ISTORE VelArrIndex
	LOAD Pos5
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADD  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADD  1
	STORE VelArrIndex
	
	; index 5
	LOAD Vel6
	ISTORE VelArrIndex
	LOAD Pos6
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADD  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADD  1
	STORE VelArrIndex
	
	; index 6
	LOAD Vel7
	ISTORE VelArrIndex
	LOAD Pos7
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADD  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADD  1
	STORE VelArrIndex
	
	; reset pos and vel indices to start
	LOAD PosArrIndex
	ADD  -6
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADD  -6
	STORE VelArrIndex
	
	RETURN
	
Delay:
	OUT	    Timer ; writing something to timer resets it to 0 
WaitingLoop:
	IN	    Timer		; time counts up to 32 in 1 sec or at 32 Hz 
	ADDI	-32 		; waiting 1 of a second 
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
Zero:	DW 0

; beginning incides of the position and velocity arrays
PosArrIndex:  DW &H0100
VelArrIndex:  DW &H0200

; velocity values in rpm
Vel1: DW 60
Vel2: DW 50
Vel3: DW 2
Vel4: DW 60
Vel5: DW 50
Vel6: DW 2
Vel7: DW 60

; position values in counts
Pos1: DW 540
Pos2: DW 1080
Pos3: DW 540
Pos4: DW 1080
Pos5: DW 540
Pos6: DW 1080
Pos7: DW 540