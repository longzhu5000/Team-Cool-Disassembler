*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


*------Use D3 to store original data
*------Use D4 to copy and modify D3 data
*------A3 points to current address in memory
*------Jump to different Isolate methods
*------keep returning and jumping untill you find the correct Method
*------Print out OPCode message, and then return to main loop
CHECK_OPCODES:

        MOVE.L   #0, D6
        JSR     ISOLATE_15_6
        JSR     ISOLATE_15_8
        JSR     ISOLATE_15_12
        CMP.L   #1, D6
        BNE     TOTAL_DECODE_FAILURE
        RTS
        

TOTAL_DECODE_FAILURE
        MOVE.W  D3, D4
        LEA DATA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        LEA SPACE_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        LEA DOLLAR_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR PRINT_WORD_VALUE
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
        *If the 15-12 are 1110, then it is a shift(LSL, LSR, ROR, ROL, ASR, ASL)
        CMP.B       #14,   D4
        BEQ         OP_CODE_SHIFT_ROTATE
        CMP.B       #4,     D4
        BEQ         OP_CODE_LEA
        CMP.B       #%1101, D4
        BEQ         OP_CODE_ADDA
        CMP.B       #%0101, D4
        BEQ         OP_CODE_ADDQ
        CMP.B       #%1101, D4
        BEQ         OP_CODE_ADD
        CMP.B       #%1001, D4
        BEQ         OP_CODE_SUB
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
        JSR         BR_EA_SIZE_AND_DISPLACEMENT
        MOVE.L      #1, D6
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

OP_CODE_LEA:
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #6, D5
        MOVE.L     #8, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #7, D4
        BNE        INSTRUCTION_DECODE_FAILURE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #0, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%111001, D4
        BEQ        OP_CODE_LEA_PRINT
        CMP.L      #%111000, D4
        BEQ        OP_CODE_LEA_PRINT
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #3, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%010, D4
        BEQ        OP_CODE_LEA_PRINT
        BRA        INSTRUCTION_DECODE_FAILURE
        *Unreachable
        RTS
OP_CODE_LEA_PRINT
        LEA         LEA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        LEA         SPACE_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR         LEA_EA
        MOVE.L      #1, D6
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
        BRA        INSTRUCTION_DECODE_FAILURE
        RTS


OP_CODE_BLE
        LEA         BLE_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR         BR_EA_SIZE_AND_DISPLACEMENT
        MOVE.L      #1, D6
        RTS

OP_CODE_BGT
        LEA         BGT_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR         BR_EA_SIZE_AND_DISPLACEMENT
        MOVE.L      #1, D6
        RTS


OP_CODE_BEQ
        LEA         BEQ_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR         BR_EA_SIZE_AND_DISPLACEMENT
        MOVE.L      #1, D6
        RTS


OP_CODE_ADDA
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #6, D5
        MOVE.L     #8, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%010, D4
        BLE        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%100, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%101, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%110, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #0, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%111010, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%111011, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%111100, D4
        BGT        INSTRUCTION_DECODE_FAILURE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #3, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%101, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%110, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        LEA        ADDA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR        ADDA_EA_SIZE_AND_EA  
        MOVE.L      #1, D6
        RTS

OP_CODE_ADDQ
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #6, D5
        MOVE.L     #7, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%11, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #0, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%111001, D4
        BGT        INSTRUCTION_DECODE_FAILURE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #3, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%101, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%110, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        LEA        ADDQ_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR        ADDQ_EA_SIZE_AND_EA
        MOVE.L      #1, D6
        RTS

OP_CODE_ADD
        BRA     OP_CODE_ADD_SUB

OP_CODE_SUB  
        BRA     OP_CODE_ADD_SUB

OP_CODE_ADD_SUB
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #6, D5
        MOVE.L     #8, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%010, D4
        BGT        OP_CODE_ADD_SUB_SOURCE_REG
        BRA        OP_CODE_ADD_SUB_DEST_REG


OP_CODE_ADD_SUB_SOURCE_REG      
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #0, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%111001, D4
        BGT        INSTRUCTION_DECODE_FAILURE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #3, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%101, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%110, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%000, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%001, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #6, D5
        MOVE.L     #8, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%111, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%011, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        LEA        SUB_MSG, A1
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #12, D5
        MOVE.L     #15, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        SUBI.L      #%1001, D4
        ADDA.L     D4, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR        ADD_SUB_EA_SIZE

        LEA         SPACE_MSG,   A1
        MOVE.B      #14,   D0    
        TRAP        #15

        JSR        ADD_SUB_EA_REG

        LEA         COMMA_MSG,   A1
        MOVE.B      #14,   D0    
        TRAP        #15
        JSR        ADD_SUB_EA_EA
        MOVE.L      #1, D6
        RTS


OP_CODE_ADD_SUB_DEST_REG
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #0, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%111010, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%111011, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #3, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%101, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%110, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #6, D5
        MOVE.L     #8, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%111, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #%011, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        LEA        SUB_MSG, A1
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #12, D5
        MOVE.L     #15, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        SUBI.L      #%1001, D4
        ADDA.L     D4, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR        ADD_SUB_EA_SIZE

        LEA         SPACE_MSG,   A1
        MOVE.B      #14,   D0    
        TRAP        #15
        
        JSR        ADD_SUB_EA_EA

        LEA         COMMA_MSG,   A1
        MOVE.B      #14,   D0    
        TRAP        #15
        JSR        ADD_SUB_EA_REG
        MOVE.L      #1, D6
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


OP_CODE_SHIFT_ROTATE
        *Now check whether it is register shift or memory shift
        *If the 6-7 bit is 11, then it is a memory else register shift
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #6, D5
        MOVE.L     #7, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #3, D4
        BEQ        OP_CODE_MEMORY_SHIFT_ROTATE
        BRA        OP_CODE_REGISTER_SHIFT_ROTATE


OP_CODE_REGISTER_SHIFT_ROTATE
        *Messages are loaded in the order of -ASR, ASL, LSR, LSL, RORX, RORL, ROR, ROL where
        *each message is of 4 bytes. Essentially using a combination of (9-11) bit + dr(8th bit) we
        *can index the appropriate message. Mathy and unreadable code but prevents lot of rebudency
        LEA        ASR_MSG, A1
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #8, D5
        MOVE.L     #8, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        MULU         #4,            D4
        ADDA.L       D4,            A1
        *Check (3, 11) bit 
        *000->ASR/ASL, 001->LSR/LSL, 011->ROR/ROL
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #3, D5
        MOVE.L     #4, D6
        JSR        GET_BIT
        CMP.L      #2, D4
        MOVEM.L    (A7)+, D5-D6
        MULU        #8,      D4
        ADDA.L       D4,            A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR         SHIFT_ROTATE_EA_SIZE
        JSR         SHIFT_ROTATE_EA_REGISTER
        MOVE.L      #1, D6
        RTS


OP_CODE_MEMORY_SHIFT_ROTATE
        *If mode bits are less than 010, then invalid instruction so just RTS
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #3, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #2, D4
        BMI        INSTRUCTION_DECODE_FAILURE
        *If mode bits are 101 or 110, then it is dispacement address register EA which is invalid
        *for the current scope
        CMP.L      #5, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        CMP.L      #6, D4
        BEQ        INSTRUCTION_DECODE_FAILURE
        *If mode bits+register bits are greater than 111001, then invalid instruction
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #0, D5
        MOVE.L     #5, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%111001, D4
        BGT        INSTRUCTION_DECODE_FAILURE
        MOVE.L     #9, D5
        MOVE.L     #11, D6
        JSR        GET_BIT
        CMP.L      #2, D4
        BEQ        INSTRUCTION_DECODE_FAILURE *If the 9-11 are 010(RORX, ROLX), instruction decode error.
        *Messages are loaded in the order of -ASR, ASL, LSR, LSL, RORX, RORL, ROR, ROL where
        *each message is of 4 bytes. Essentially using a combination of (9-11) bit + dr(8th bit) we
        *can index the appropriate message. Mathy and unreadable code but prevents lot of rebudency
        LEA        ASR_MSG, A1
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #8, D5
        MOVE.L     #8, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        MULU         #4,            D4
        ADDA.L       D4,            A1
        *Check (9, 11) bit 
        *000->ASR/ASL, 001->LSR/LSL, 011->ROR/ROL
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #9, D5
        MOVE.L     #11, D6
        JSR        GET_BIT
        CMP.L      #2, D4
        MOVEM.L    (A7)+, D5-D6
        MULU        #8,      D4
        ADDA.L       D4,            A1
        MOVE.B      #14, D0
        TRAP        #15
        LEA        WORD_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        LEA         SPACE_MSG,      A1
        MOVE.B      #14,            D0    
        TRAP        #15
        JSR         SHIFT_ROTATE_EA_MEMORY
        MOVE.L      #1, D6
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
        ADD.L   D6, D5
        LSL.W   D6, D4
        LSR.W   D5, D4
        RTS

*Just RTS, useful to use with a condition
INSTRUCTION_DECODE_FAILURE
        RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
