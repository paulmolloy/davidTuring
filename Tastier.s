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
