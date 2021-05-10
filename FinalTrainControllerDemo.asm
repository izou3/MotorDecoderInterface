; Starting code with basic constants and simple subroutine
; random comment

ORG 0
Start:
	CALL SetupArrays
	
StationIteration: 
	CALL Delay 
	
	; if switch then go to next iteration
	LOADI 40 
	STORE PWMSpeed
	
	IN Switches 
	AND Bit0
	OUT Hex1
	JPOS But
	JUMP StationIteration
	
VelStart:
		
	; ERROR HANDLING
	IN Quad 
	AND Only1
	JNEG ErrorHandling
	; ERROR HANDLING 
	
	LOAD  PWMSpeed
	OUT   PWM 
	
	ILOAD PosArrIndex 
	OUT   Direct
	OUT Hex0 
	
	ILOAD VelArrIndex
	STORE  DesiredVel
	
	CALL  Delay2 
	CALL  Delay2 
	CALL  Delay2 
	CALL  Delay2 
	
	IN    Direct
	OUT   Hex1 
	JPOS  StationIteration
	 
	CALL  ReadVelocity
	LOAD  CurrVel
	OUT   Hex0 
	JZERO VelStart
	
	SUB   DesiredVel
	JNEG  IncPWM
	JPOS  DecPWM 
	JZERO Constant
	JUMP  VelStart 
	
IncPWM: 
	LOADI 2
	OUT   Hex1 
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
	JUMP VelStart 
	
Constant: 
	LOAD PWMSpeed
	OUT  Hex0
	; LOADI 0 
	OUT  PWM
	JUMP VelStart 
	
ReadVelocity:
	CALL	Delay2
	IN		Quad
	SUB		OldPos
	CALL    Abs 
	SHIFT	5	
	OUT		Hex0
	STORE	CurrVel
	IN 		Quad 
	STORE	OldPos
	RETURN

SetupArrays:
	; index 0
	LOAD Vel1
	ISTORE VelArrIndex
	LOAD Pos1
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADDI  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADDI  1
	STORE VelArrIndex
	
	; index 1
	LOAD Vel2
	ISTORE VelArrIndex
	LOAD Pos2
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADDI  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADDI  1
	STORE VelArrIndex
	
	; index 2
	LOAD Vel3
	ISTORE VelArrIndex
	LOAD Pos3
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADDI  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADDI  1
	STORE VelArrIndex
	
	; index 3
	LOAD Vel4
	ISTORE VelArrIndex
	LOAD Pos4
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADDI  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADDI  1
	STORE VelArrIndex
	
	; index 4
	LOAD Vel5
	ISTORE VelArrIndex
	LOAD Pos5
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADDI  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADDI  1
	STORE VelArrIndex
	
	; index 5
	LOAD Vel6
	ISTORE VelArrIndex
	LOAD Pos6
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADDI  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADDI  1
	STORE VelArrIndex
	
	; index 6
	LOAD Vel7
	ISTORE VelArrIndex
	LOAD Pos7
	ISTORE PosArrIndex
	
	LOAD PosArrIndex
	ADDI  1
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADDI  1
	STORE VelArrIndex
	
	; reset pos and vel indices to start
	LOAD PosArrIndex
	ADDI  -7
	STORE PosArrIndex
	
	LOAD VelArrIndex
	ADDI  -7
	STORE VelArrIndex
	
	RETURN
	
Delay:
	OUT	    Timer ; writing something to timer resets it to 0 
WaitingLoop:
	IN	    Timer		; time counts up to 32 in 1 sec or at 32 Hz 
	ADDI	-64 		; waiting 1/32 of a second 
	JNEG	WaitingLoop
	RETURN
	
Delay2:
	OUT	Timer2 ; writing something to timer resets it to 0 
WaitingLoop2:
	IN	Timer2		; time counts up to 10 in 1 sec or at 10 Hz 
	ADDI	-1 		; waiting 1/32 of a second 
	JNEG	WaitingLoop2
	RETURN
	
;Here, this is the error handling code 
ErrorHandling:
	LOAD  Zero
	OUT   PWM
	LOAD Error404Hex1
	OUT  Hex1
	;LOAD Error404Hex0
	;OUT Hex0
	JUMP ErrorHandling ;this is an infinite loop
	
But:
	LOAD VelArrIndex
	ADDI 1
	STORE VelArrIndex
	
	LOAD PosArrIndex
	ADDI 1
	STORE PosArrIndex
	
	JUMP  VelStart
	
Abs:
	JPOS   Abs_r        ; If already positive, return

Negate:
    OR    NegOne       ; Flip all bits
    ADDI   1            ; Add one

Abs_r:
	RETURN
	
; IO address constants
Switches:  EQU &H000
Hex0:      EQU &H004
Hex1:	   EQU &H005
PWM:       EQU &H021
Direct:    EQU &H022
Timer2:    EQU &H024
Quad:      EQU &H0F1
Timer:	   EQU &H002
Button:    EQU &H023

; constants
Zero:      DW 0
NegOne:    DW -1

; beginning incides of the position and velocity arrays
PosArrIndex:  DW &H0100
VelArrIndex:  DW &H0200

; velocity values in cps
Vel1: DW 540  ; not in use 
Vel2: DW 540
Vel3: DW 360
Vel4: DW 540
Vel5: DW 600
Vel6: DW 270
Vel7: DW 400
Vel8: DW 600

; position values in counts
Pos1: DW 1080 ; not in use 
Pos2: DW 2700
Pos3: DW 540
Pos4: DW 1080
Pos5: DW 3240
Pos6: DW 4320
Pos7: DW 540
Pso8: DW 540 

; values for velocity control
Countprev:	 	 DW 0
OldPos: 		 DW 0 
DesiredVel: 	 DW 0 ; 360 = 1 rev in 1.5 seconds
CurrVel: 		 DW 0 
PWMSpeed: 	     DW 40

;error handling variables

Only1:			 DW &B1111111111111111
Bit0:            DW &B0000000001
Error404Hex1:	 DW &H00FF 
Error404Hex0:    DW &HFFFF