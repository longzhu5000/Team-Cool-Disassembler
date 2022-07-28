*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


*------Use D3 to store original data
*------Use D4 to copy and modify D3 data

*------Jump to different Isolate methods
*------keep returning and jumping untill you find the correct Method
*------Print out OPCode message, and then return to main loop
CHECK_OPCODES:

        JSR     ISOLATE_15_6
        JSR     ISOLATE_15_8
        JSR     ISOLATE_15_12

        RTS
        
ISOLATE_15_6:
        
        MOVE.L      D3,     D4
        MOVE.L      #6,     D2
        LSR.L       D2,     D4
        
        CMP.W       #$13A,  D4
        BEQ         OP_CODE_JSR
        
        RTS


ISOLATE_15_8:
        *SIMHALT
        MOVE.L      D3,     D4
        MOVE.L      #8,     D2
        LSR.L       D2,     D4
        
        CMP.B       #$46,   D4
        BEQ         OP_CODE_NOT
        CMP.B       #$60,   D4
        BEQ         OP_CODE_BRA

        RTS
        
ISOLATE_15_12:
        MOVE.L      D3,     D4
        MOVE.L      #12,    D2
        LSR.L       D2,     D4
        
        CMP.B       #$7,    D4
        BEQ         OP_CODE_MOVEQ
        CMP.B       #$8,    D4
        BEQ         OP_CODE_OR      *may get confused with DIVU + any other opcodes that start with 1000 (ones that we are not required to cover)
        CMP.B       #$C,    D4
        BEQ         OP_CODE_AND
        
        RTS



*----------------
OP_CODE_NOT:
        LEA         NOT_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS 
OP_CODE_BRA:
        LEA         BRA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS 
OP_CODE_JSR:
        LEA         JSR_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
OP_CODE_MOVEQ:
        LEA         MOVEQ_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
OP_CODE_AND:
        LEA         AND_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
OP_CODE_OR:
        *check for divu/other opcodes that start with 1000
        *isolate bits 8-6 to check for DIVU
        MOVE.L      D3,     D4
        MOVE.L      #7,     D2
        LSL.W       D2,     D4
        MOVE.L      #13,    D2
        LSR.W       D2,     D4
        
        CMP.B       #$3,    D4
        BEQ         OP_CODE_DATA
        
        LEA         OR_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
OP_CODE_DATA:
        LEA         DATA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS        


NOT_MSG:        DC.B        'NOT',0
BRA_MSG:        DC.B        'BRA',0
JSR_MSG:        DC.B        'JSR',0
MOVEQ_MSG:      DC.B        'MOVEQ',0
AND_MSG:        DC.B        'AND',0
OR_MSG:         DC.B        'OR',0
DATA_MSG:       DC.B        'DATA',0






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
