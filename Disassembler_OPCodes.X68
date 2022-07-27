*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


*------Use D3 to store original data
*------Use D4 to copy and modify D3 data

*------Jump to different Isolate methods
*------keep returning and jumping until you find the correct Method
*------Print out OPCode message, and then return to main loop
CHECK_OPCODES:

        JSR     ISOLATE_15_12
        JSR     ISOLATE_16

        RTS


ISOLATE_15_12:
        MOVE.L      D3,     D4
        MOVE.L      #12,     D2
        LSR.L       D2,     D4
        
        CMP.B       #$D,   D4
        BEQ         ADD_ADDA            ;OP_CODE_ADD
       ;CMP.W       #$D,   D4
       ;BEQ         OP_CODE_ADDA
        CMP.B       #$5,   D4
        BEQ         OP_CODE_ADDQ
        CMP.B       #$9,   D4
        BEQ         OP_CODE_SUB

        RTS
        
ISOLATE_16:
        CMP.W       #$4E71, D3
        BEQ         OP_CODE_NOP
        CMP.W       #$4E75, D3
        BEQ         OP_CODE_RTS

        RTS
        
ADD_ADDA:
        MOVE.L      D3,     D4
        MOVE.L      #6,     D2      
        MOVE.L      #13,    D5
        LSR.L       D2,     D4          
        LSL.L       D5,     D4          ;isolates bit 3-6
        
        CMP.B       #%011,  D4          ;compares OP_Mode field, (ADDA: 011, 111)
        BEQ         OP_CODE_ADDA
        CMP.B       #%111,  D4
        BEQ         OP_CODE_ADDA
        BNE         OP_CODE_ADD
        
        RTS
*------------------------
OP_CODE_ADD:
        LEA         ADD_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
        
OP_CODE_ADDA:
        LEA         ADDA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
        
OP_CODE_ADDQ:
        LEA         ADDQ_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS

OP_CODE_SUB:
        LEA         SUB_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
        
OP_CODE_RTS:
        LEA         RTS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
        
OP_CODE_NOP:
        LEA         NOP_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS

ADD_MSG:        DC.B        'ADD',0
ADDA_MSG:       DC.B        'ADDA',0
ADDQ_MSG:       DC.B        'ADDQ',0
SUB_MSG:        DC.B        'SUB',0
RTS_MSG:        DC.B        'RTS',0
NOP_MSG:        DC.B        'NOP',0










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
