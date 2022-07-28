*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


*------Use D3 to store original data
*------Use D4 to copy and modify D3 data
*------Use D6 as a boolean to know wether we have printed or not

*------Jump to different Isolate methods
*------keep returning and jumping untill you find the correct Method
*------Print out OPCode message, and then return to main loop
CHECK_OPCODES:
        CLR.L   D6

        JSR     ISOLATE_15_8
        CMP.B   #$1,    D6
        
        BEQ     RETURN
        JSR     ISOLATE_15_11
        
        CMP.B   #$1,    D6
        BEQ     RETURN
        
        JSR     ISOLATE_8_6
        CMP.B   #$1,    D6
        
        BEQ     RETURN
        JSR     ISOLATE_15_14
        
        CMP.B   #$1,    D6
        BEQ     RETURN
        

        RTS
RETURN:
        RTS

ISOLATE_15_8:
        MOVE.W      D3,     D4
        MOVE.W      #8,     D2
        LSR.W       D2,     D4
        
        CMP.B       #$46,   D4
        BEQ         OP_CODE_NOT
        CMP.B       #$60,   D4
        BEQ         OP_CODE_BRA

        RTS
        
ISOLATE_15_11:
        MOVE.W      D3,     D4
        MOVE.W      #11,    D2
        LSR.W       D2,     D4
        
        CMP.B       #$9,    D4
        BEQ         OP_CODE_MOVEM
        
        RTS
        
ISOLATE_15_14:
        MOVE.W      D3,     D4
        MOVE.W      #14,    D2
        LSR.W       D2,     D4
        
        CMP.B       #$0,    D4
        BEQ         OP_CODE_MOVE
        
        RTS
        
ISOLATE_8_6:
        MOVE.W      D3,     D4
        MOVE.W      #7,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        CMP.B       #$1,    D4
        BEQ         OP_CODE_MOVEA
        CMP.B       #$7,    D4
        BEQ         OP_CODE_LEA

        RTS



*----------------
OP_CODE_NOT:
        LEA         NOT_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.B      #1,      D6
        
        RTS 
OP_CODE_BRA:
        LEA         BRA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.B      #1,      D6
        *MOVE.W      (A3)+,   D7
        
        RTS
        
OP_CODE_LEA:
        LEA         LEA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15

        MOVE.B      #1,      D6

        RTS        
*-----------------
OP_CODE_MOVE:

        LEA         MOVE_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15

        MOVE.B      #1,      D6

        RTS
        
OP_CODE_MOVEA:
        LEA         MOVEA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15

        MOVE.B      #1,      D6

        RTS

OP_CODE_MOVEM:
        LEA         MOVEM_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15

        MOVE.B      #1,      D6

        RTS

NOT_MSG:        DC.B        'NOT',0
BRA_MSG:        DC.B        'BRA',0

MOVE_MSG:       DC.B        'MOVE',0
MOVEM_MSG:      DC.B        'MOVEM',0
MOVEA_MSG:      DC.B        'MOVEA',0
LEA_MSG:        DC.B        'LEA',0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
