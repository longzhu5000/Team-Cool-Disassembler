*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


*------Use D3 to store original data
*------Use D4 to copy and modify D3 data
*------
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
        *If the 15-12 are 0110
        CMP.B       #6,     D4
        BEQ         OP_CODE_BCC
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

OP_CODE_BCC
        *Get bits from 8-11 to get the condition
        *Only checking for (BGT, BLE, BEQ). Rest are considered
        *invalid
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #8, D5
        MOVE.L     #11, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #15, D4
        BEQ        OP_CODE_BLE
        CMP.L      #14, D4
        BEQ        OP_CODE_BGT
        CMP.L      #7,  D4
        BEQ        OP_CODE_BEQ
        *Invalid instruction for the scope
        RTS


OP_CODE_BLE
        LEA         BLE_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        BRA PRINT_BCC_SIZE_ATTR

OP_CODE_BGT
        LEA         BGT_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        BRA PRINT_BCC_SIZE_ATTR


OP_CODE_BEQ
        LEA         BEQ_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        BRA PRINT_BCC_SIZE_ATTR


PRINT_BCC_SIZE_ATTR
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #8, D5
        MOVE.L     #11, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #0, D4
        BEQ        PRINT_WORD_SIZE_ATTR
PRINT_BYTE_SIZE_ATTR
        LEA         BYTE_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        LEA         SPACE_MSG,      A1
        MOVE.B      #14,            D0    
        TRAP        #15
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #0, D5
        MOVE.L     #7, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6


        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #8, D6
BYTE_DISPLACEMENT_PRINT_LOOP
        *Gets the most significant bit basically
        *Could use GET_BIT subroutine but it is 
        *costly in terms of registers used
        MOVE.B     D4, D5
        ANDI.B     #$80, D5
        LSR.B      #7, D5
        LEA        ZERO_MSG,      A1
        * load the address of Zero_msg
        * because all of the msgs are stored next to each other in order
        * we can simply take the value isolated from the number, multiply it by 2 (msg's take up 2 bytes)
        * and then add it to the address starting at zero_msg
        MULU         #2,            D5
        ADDA.L       D5,            A1
        MOVE.B      #14, D0
        TRAP        #15
        SUBI.L      #1, D6
        CMP.B        #0, D6
        BNE         BYTE_DISPLACEMENT_PRINT_LOOP
        
        LEA         NEW_LINE,       A1
        MOVE.B      #14,            D0    
        TRAP        #15
        MOVEM.L    (A7)+, D5-D6
        RTS
        
PRINT_WORD_SIZE_ATTR
        LEA         WORD_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        LEA         SPACE_MSG,      A1
        MOVE.B      #14,            D0    
        TRAP        #15
        MOVE.W      (A3)+,  D3
        

        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #16, D6
WORD_DISPLACEMENT_PRINT_LOOP
        *Gets the most significant bit basically
        *Could use GET_BIT subroutine but it is 
        *costly in terms of registers used
        MOVE.B     D4, D5
        ANDI.B     #$80, D5
        LSR.B      #7, D5
        LEA        ZERO_MSG,      A1
        * load the address of Zero_msg
        * because all of the msgs are stored next to each other in order
        * we can simply take the value isolated from the number, multiply it by 2 (msg's take up 2 bytes)
        * and then add it to the address starting at zero_msg
        MULU         #2,            D5
        ADDA.L       D5,            A1
        MOVE.B      #14, D0
        TRAP        #15
        SUBI.L      #1, D6
        CMP.B       #0, D6
        BNE         WORD_DISPLACEMENT_PRINT_LOOP
        
        LEA         NEW_LINE,       A1
        MOVE.B      #14,            D0    
        TRAP        #15
        MOVEM.L    (A7)+, D5-D6
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

*----------------Some helpful subroutines------------*


*Gets the (x, y) bit. Note-0th bit is assumed to be the rightmost bit
*For example, "0101011111100101" and (3, 4) equals "00"
*D3 holds the word of which we get the (x, y) bits of
*D5 holds the x, D6 holds the y
*Result returned in D4
GET_BIT
        CLR.L   D4
        MOVE.W  D3, D4   
        *Shift it to left by 15-y to get rid of all the bits to the left of yth bit 
        *and then shift the bits such that the xth bit is the 0th bit
        NEG.L   D6
        ADDI.L  #15, D6
        LSL.W   D6, D4 
        LSR.W   D5, D4
        RTS




NOT_MSG:        DC.B        'NOT',0
BRA_MSG:        DC.B        'BRA',0
JSR_MSG:        DC.B        'JSR',0
MOVEQ_MSG:      DC.B        'MOVEQ',0
AND_MSG:        DC.B        'AND',0
OR_MSG:         DC.B        'OR',0
DATA_MSG:       DC.B        'DATA',0
BCC_MSG         DC.B        'B', 0
BYTE_MSG        DC.B        '.B', 0
WORD_MSG        DC.B        '.W', 0



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
