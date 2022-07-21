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

        JSR     ISOLATE_15_8

        RTS


ISOLATE_15_8:
        SIMHALT
        MOVE.L      D3,     D4
        MOVE.L      #8,     D2
        LSR.L       D2,     D4
        
        CMP.B       #$46,   D4
        BEQ         OP_CODE_NOT
        CMP.B       #$60,   D4
        BEQ         OP_CODE_BRA

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


NOT_MSG:        DC.B        'NOT',0
BRA_MSG:        DC.B        'BRA',0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
