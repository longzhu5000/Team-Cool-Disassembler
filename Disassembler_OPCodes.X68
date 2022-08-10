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

        JSR     ISOLATE_16
        CMP.B   #$1,    D6
        BEQ     RETURN
        
        JSR     ISOLATE_15_6
        CMP.B   #$1,    D6
        BEQ     RETURN

        JSR     ISOLATE_15_8
        CMP.B   #$1,    D6
        BEQ     RETURN
        
        JSR     ISOLATE_15_11
        CMP.B   #$1,    D6
        BEQ     RETURN
        
        JSR     ISOLATE_15_12
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

ISOLATE_15_12:
        MOVE.W      D3,     D4
        MOVE.W      #12,     D2
        LSR.W       D2,     D4
        
        CMP.B       #$D,   D4
        BEQ         OP_CODE_ADD
       ;CMP.W       #$D,   D4
       ;BEQ         OP_CODE_ADDA
        CMP.B       #$5,   D4
        BEQ         OP_CODE_ADDQ
        CMP.B       #$9,   D4
        BEQ         OP_CODE_SUB
        
        CMP.B       #$7,    D4
        BEQ         OP_CODE_MOVEQ
        CMP.B       #$8,    D4
        BEQ         OP_CODE_OR      *may get confused with DIVU + any other opcodes that start with 1000 (ones that we are not required to cover)
        CMP.B       #$C,    D4
        BEQ         OP_CODE_AND

        RTS
        
ISOLATE_16:

        CMP.W       #$4E71, D3
        BEQ         OP_CODE_NOP
        CMP.W       #$4E75, D3
        BEQ         OP_CODE_RTS

        RTS

ISOLATE_15_6:
        
        MOVE.W      D3,     D4
        MOVE.W      #6,     D2
        LSR.W       D2,     D4
        
        CMP.W       #$13A,  D4
        BEQ         OP_CODE_JSR
        
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
*------------------------
OP_CODE_ADD:
        LEA         ADD_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR         ADD_EA_SIZE_AND_EA
        MOVE.B      #1,     D6
        
        RTS
        
OP_CODE_ADDA:
        LEA         ADDA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.B      #1,      D6
        
        RTS
        
OP_CODE_ADDQ:
        LEA         ADDQ_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
                
        MOVE.B      #1,      D6
        
        RTS

OP_CODE_SUB:
        LEA         SUB_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         SUB_EA_SIZE_AND_EA
        MOVE.B      #1,      D6

        RTS
        
*------------------------        
OP_CODE_RTS:
        LEA         RTS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.B      #1,      D6
        
        RTS
        
OP_CODE_NOP:
        LEA         NOP_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.B      #1,      D6
        
        RTS
        
*------------------------  
OP_CODE_MOVEQ:
        LEA         MOVEQ_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.B      #1,      D6
        
        RTS
        
OP_CODE_AND:
        LEA         AND_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        

        
        MOVE.B      #1,      D6
        
        RTS
        
OP_CODE_OR:
        LEA         OR_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        

        
        MOVE.B      #1,      D6
        
        RTS

OP_CODE_JSR:
        LEA         JSR_MSG, A1
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

ADD_MSG:        DC.B        'ADD',0
ADDA_MSG:       DC.B        'ADDA',0
ADDQ_MSG:       DC.B        'ADDQ',0
SUB_MSG:        DC.B        'SUB',0
RTS_MSG:        DC.B        'RTS',0
NOP_MSG:        DC.B        'NOP',0

MOVEQ_MSG:      DC.B        'MOVEQ',0
AND_MSG:        DC.B        'AND',0
OR_MSG:         DC.B        'OR',0
JSR_MSG:        DC.B        'JSR',0

*------------ Helpful Subroutines ------------
GET_BIT
        CLR.L   D4
        MOVE.W  D3, D4   
        *Shift it to left by 15-y to get rid of all the bits to the left of yth bit 
        *and then shift the bits such that the xth bit is the 0th bit
        NEG.L   D6
        ADDI.L  #15, D6
        ADD.L   D6, D5
        LSL.W   D6, D4
        LSR.W   D5, D4
        RTS

        






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
