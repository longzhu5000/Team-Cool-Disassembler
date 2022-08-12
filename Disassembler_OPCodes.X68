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
        
        
        BRA   TOTAL_DECODE_FAILURE
RETURN:
        RTS

ISOLATE_15_12:
        MOVE.W      D3,     D4
        MOVE.W      #12,     D2
        LSR.W       D2,     D4
        
        CMP.B       #$7,    D4
        BEQ         OP_CODE_MOVEQ
        CMP.B       #$8,    D4
        BEQ         OP_CODE_OR      *may get confused with DIVU + any other opcodes that start with 1000 (ones that we are not required to cover)
        CMP.B       #$C,    D4
        BEQ         OP_CODE_AND
        JSR         OP_CODE_BCC
        JSR         OP_CODE_SHIFT_ROTATE
        JSR         OP_CODE_ADDA
        JSR         OP_CODE_ADDQ
        JSR         OP_CODE_ADD
        JSR         OP_CODE_SUB
        JSR         OP_CODE_LEA

        RTS
        
ISOLATE_16:

        JSR       OP_CODE_NOP
        JSR       OP_CODE_RTS
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

        RTS



*----------------
OP_CODE_NOT:
        LEA         NOT_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         SIZE_7_6
        
        LEA         WHITESPACE, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         EFFECTIVEADD_5_0
        
        MOVE.B      #1,      D6
        
        RTS 
      
*-----------------
OP_CODE_MOVE:

        LEA         MOVE_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         SIZE_13_12
        
        LEA         WHITESPACE, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         EFFECTIVEADD_5_0
        
        LEA         WHITESPACE_COM, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         DESTINATION_11_6

        MOVE.B      #1,      D6

        RTS
        
OP_CODE_MOVEA:
        LEA         MOVEA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         SIZE_13_12
        
        LEA         WHITESPACE, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         EFFECTIVEADD_5_0
        
        LEA         WHITESPACE_COM, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         DESTINATION_11_6

        MOVE.B      #1,      D6

        RTS

OP_CODE_MOVEM:
        LEA         MOVEM_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         SIZE_6
        
        MOVE.W      D3,     D4
        
        MOVE.W      #5,     D2
        LSL.W       D2,     D4
        MOVE.W      #15,    D2
        LSR.W       D2,     D4
        
        CMP.B       #$0,    D4
        BEQ         REG_TO_MEM
        CMP.B       #$1,    D4
        BEQ         MEM_TO_REG
        
        RTS

REG_TO_MEM:

        MOVE.W      D3,     D4
        LEA         WHITESPACE, A1
        MOVE.B      #14,    D0
        TRAP        #15
        MOVE.W      #10,    D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        MOVEA.L     A3,     A5

        CLR.L       D0
        CLR.L       D1
        MOVE.W      #$FF,   D1
        CLR.L       D6
        MOVE.W      #$FF,   D6
        CLR.L       D0
        CMP.B       #$4,    D4
        BEQ         RTM_1_B
        
        MOVE.B      #$F,   D0
        BRA         RTM_1_A
 
        

RTM_1_A:
        MOVE.W      (A5)+,   D4    
        JSR         POST_INCR_MASK_FIELD
        BRA         RTM_2
RTM_1_B: 
        MOVE.W      (A5)+,   D4   
        JSR         PRE_DECR_MASK_FIELD
        BRA         RTM_2
RTM_2:

        LEA         WHITESPACE_COM, A1
        MOVE.B      #14,    D0
        TRAP        #15

        SUB.W       #4,     A5
        MOVE.W      (A5)+,  D3
        JSR         EFFECTIVEADD_5_0
        CLR.L       D6
        MOVE.W      (A3)+,  D3
        MOVE.B      #1,     D6
        RTS
    
    
MEM_TO_REG:

        MOVE.W      D3,     D4
        LEA         WHITESPACE, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         EFFECTIVEADD_5_0
        
        LEA         WHITESPACE_COM, A1
        MOVE.B      #14, D0
        TRAP        #15

        MOVE.W      D3,     D4
        MOVE.W      #10,    D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        CLR.L       D0
        CLR.L       D1
        MOVE.W      #$FF,   D1
        CLR.L       D6
        MOVE.W      #$FF,   D6
        
        CLR.L       D0
        CMP.B       #$4,    D4
        BEQ         MTR_1_B
        
        MOVE.B      #$F,   D0

        BRA         MTR_1_A
        


MTR_1_A: 
        MOVE.W      (A3)+,  D4   
        JSR         POST_INCR_MASK_FIELD
        CLR.L       D6
        MOVE.B      #1,     D6
        RTS
MTR_1_B:
        MOVE.W      (A3)+,  D4    
        JSR         PRE_DECR_MASK_FIELD
        CLR.L       D6
        MOVE.B      #1,     D6
        RTS

*------------------------


*****LEA***************************

OP_CODE_LEA:
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #12, D5
        MOVE.L     #15, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%0100, D4
        BNE        INSTRUCTION_DECODE_FAILURE
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

************LEA**************************



************LSL/LSR/ASL/ASR/ROL/ROR**************

OP_CODE_SHIFT_ROTATE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #12, D5
        MOVE.L     #15, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%1110, D4
        BNE        INSTRUCTION_DECODE_FAILURE
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
*******************LSL/LSR/ASL/ASR/ROL/ROR*********************



*******************NOP*******************************
OP_CODE_NOP:
        CMP.L    #%0100111001110001, D3
        BNE      INSTRUCTION_DECODE_FAILURE
        LEA      NOP_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15 
        MOVE.L      #1, D6
        RTS 


****************NOP****************************


**************RTS************************
OP_CODE_RTS:
        CMP.L    #%0100111001110101, D3
        BNE      INSTRUCTION_DECODE_FAILURE
        LEA      RTS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15 
        MOVE.L      #1, D6
        RTS 
        
************RTS*******************


***********BCC*******************
OP_CODE_BCC
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #12, D5
        MOVE.L     #15, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%0110, D4
        BNE        INSTRUCTION_DECODE_FAILURE
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

******************BCC************************


******************BRA***********************

OP_CODE_BRA:
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #12, D5
        MOVE.L     #15, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L       #%0110, D4
        BNE         INSTRUCTION_DECODE_FAILURE
        LEA         BRA_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        JSR         BR_EA_SIZE_AND_DISPLACEMENT
        MOVE.L      #1, D6
        RTS 
        
*******************BRA***********************


*******************ADDA*********************



OP_CODE_ADDA
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #12, D5
        MOVE.L     #15, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%1101, D4
        BNE        INSTRUCTION_DECODE_FAILURE
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

*****************ADDA********************

*****************ADDQ*******************


OP_CODE_ADDQ
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #12, D5
        MOVE.L     #15, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%0101, D4
        BNE        INSTRUCTION_DECODE_FAILURE
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

********************ADDQ******************

******************ADD/SUB***************

OP_CODE_ADD
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #12, D5
        MOVE.L     #15, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6
        CMP.L      #%1101, D4
        BNE        INSTRUCTION_DECODE_FAILURE
        BRA        OP_CODE_ADD_SUB

OP_CODE_SUB  
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #12, D5
        MOVE.L     #15, D6
        JSR        GET_BIT
        MOVEM.L    (A7)+, D5-D6 
        CMP.L       #%1001, D4
        BNE        INSTRUCTION_DECODE_FAILURE
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


****************ADD/SUB*****************


*------------------------  
OP_CODE_MOVEQ:
        *NOTE MOVEQ has static bit at index 8
        LEA         MOVEQ_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         WHITESPACE, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         HASH_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15

        LEA         DOLLAR_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
       
        JSR         DATA_7_0
        
        LEA         WHITESPACE_COM, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         DATA_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         REGISTER_11_9
        
        MOVE.B      #1,      D6
        
        RTS
        
OP_CODE_AND:
        LEA         AND_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        *check opmode
        *if starts with 1 do Dn ^ <ea> -> <ea>
        *OPMODE_8_6 will appent size next to opcode
        JSR         OPMODE_8_6
        ROL.W       #1, D4
        BCS         OP_CODE_AND2
        *else...
        
        LEA         WHITESPACE, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        *check ea and print
        JSR         EFFECTIVEADD_5_0
        
        LEA         WHITESPACE_COM, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        *print out data reg
        
        LEA         DATA_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         REGISTER_11_9
        
        
        MOVE.B      #1,      D6
        
        RTS

OP_CODE_AND2:
        LEA         WHITESPACE, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         DATA_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         REGISTER_11_9
        
        LEA         WHITESPACE_COM, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         EFFECTIVEADD_5_0
        
        MOVE.B      #1,      D6
        
        RTS
OP_CODE_OR:
        LEA         OR_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         OPMODE_8_6
        ROL.W       #1, D4
        BCS         OP_CODE_OR2
        
        LEA         WHITESPACE, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         EFFECTIVEADD_5_0
        
        LEA         WHITESPACE_COM, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         DATA_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         REGISTER_11_9
            
        MOVE.B      #1,      D6
        
        RTS
        
OP_CODE_OR2:
        LEA         WHITESPACE, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         DATA_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         REGISTER_11_9
        
        LEA         WHITESPACE_COM, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         EFFECTIVEADD_5_0
        
        MOVE.B      #1,      D6
        
        RTS
        
OP_CODE_JSR:
        LEA         JSR_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         WHITESPACE, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        JSR         EFFECTIVEADD_5_0
        
        MOVE.B      #1,      D6
        
        RTS

**************Some helpful subroutines************


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
        
****************************************************

*DATA_MSG:   DC.B    'DATA',0





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
