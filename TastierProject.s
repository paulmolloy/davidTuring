	AREA	TastierProject, CODE, READONLY

    IMPORT  TastierDiv
	IMPORT	TastierMod
	IMPORT	TastierReadInt
	IMPORT	TastierPrintInt
	IMPORT	TastierPrintIntLf
	IMPORT	TastierPrintTrue
	IMPORT	TastierPrintTrueLf
	IMPORT	TastierPrintFalse
    IMPORT	TastierPrintFalseLf
    IMPORT  TastierPrintString
    
; Entry point called from C runtime __main
	EXPORT	main

; Preserve 8-byte stack alignment for external routines
	PRESERVE8

; Register names
BP  RN 10	; pointer to stack base
TOP RN 11	; pointer to top of stack

main
; Initialization
	LDR		R4, =globals
	LDR 	BP, =stack		; address of stack base
	LDR 	TOP, =stack+16	; address of top of stack frame
	B		Main
; Procedure SumUp
SumUpBody
    LDR     R5, =1
 LDR R2, =0
 ADD R2, R4, R2, LSL #2
 STR R5, [R2] ; i
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L1
    DCB     "Printing a test value", 0
    ALIGN
L1
    MOV     TOP, BP         ; reset top of stack
    LDR     BP, [TOP,#12]   ; and stack base pointers
    LDR     PC, [TOP]       ; return from SumUp
SumUp
    LDR     R0, =1          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       SumUpBody
MainBody
    LDR     R5, =0
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; b
    LDR     R5, =4
    ADD     R2, BP, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; c
; Start Struct person
; Member surname
; Member age
; Member isrighthanded
; End Struct
    LDR     R5, =1
    ADD     R2, BP, #16
    LDR     R1, =3
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; surname
    ADD     R2, BP, #16
    LDR     R1, =3
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; person
; .surname
    LDR     R6, =10
    ADD     R5, R5, R6
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; b
    LDR     R5, =0
    ADD     R2, BP, #16
    LDR     R1, =6
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; i
; For
L2
    ADD     R2, BP, #16
    LDR     R1, =6
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; i
    ADD     R2, BP, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    LDR     R6, [R2]        ; c
    CMP     R5, R6
    MOVLT   R5, #1
    MOVGE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
; Condition:
    BEQ     L3              ; jump on condition false
    LDR     R5, =1
    ADD     R2, BP, #16
    LDR     R1, =6
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; i
; Inside For:
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; b
    LDR     R6, =1
    ADD     R5, R5, R6
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; b
    B       L2
L3
; End For
StopTest
    B       StopTest
Main
    LDR     R0, =1          ; current lexic level
    LDR     R1, =7          ; number of local variables
    BL      enter           ; build new stack frame
    B       MainBody
; Local variables:
; 	b Type: integer Address: 0
; 	c Type: integer Address: 1
; 	person Type: undef Address: 2
; 	surname Type: integer Address: 3
; 	age Type: integer Address: 4
; 	isrighthanded Type: boolean Address: 5
; 	i Type: integer Address: 6
; Procedures:
; Global variables:
; 	i Type: integer Address: 0
; Procedures:
; 	SumUp Type: proc Address: 0
; 	main Type: proc Address: 0

; Subroutine enter
; Construct stack frame for procedure
; Input: R0 - lexic level (LL)
;		 R1 - number of local variables
; Output: new stack frame

enter
	STR		R0, [TOP,#4]			; set lexic level
	STR		BP, [TOP,#12]			; and dynamic link
	; if called procedure is at the same lexic level as
	; calling procedure then its static link is a copy of
	; the calling procedure's static link, otherwise called
 	; procedure's static link is a copy of the static link 
	; found LL delta levels down the static link chain
    LDR		R2, [BP,#4]				; check if called LL (R0) and
	SUBS	R0, R2					; calling LL (R2) are the same
	BGT		enter1
	LDR		R0, [BP,#8]				; store calling procedure's static
	STR		R0, [TOP,#8]			; link in called procedure's frame
	B		enter2
enter1
	MOV		R3, BP					; load current base pointer
	SUBS	R0, R0, #1				; and step down static link chain
    BEQ     enter2-4                ; until LL delta has been reduced
	LDR		R3, [R3,#8]				; to zero
	B		enter1+4				;
	STR		R3, [TOP,#8]			; store computed static link
enter2
	MOV		BP, TOP					; reset base and top registers to
	ADD		TOP, TOP, #16			; point to new stack frame adding
	ADD		TOP, TOP, R1, LSL #2	; four bytes per local variable
	BX		LR						; return
	
	AREA	Memory, DATA, READWRITE
globals     SPACE 4096
stack      	SPACE 16384

	END