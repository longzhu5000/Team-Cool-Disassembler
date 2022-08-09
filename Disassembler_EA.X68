*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


*------Use D3 to store original data
*------Use D4 to copy and modify D3 data
*------A3 points to current address in memory

******************************Start of shift/rotate EA functions***********************

SHIFT_ROTATE_EA_SIZE
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #6, D5
    MOVE.L     #7, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    LEA        BYTE_MSG, A1
    MULU       #3, D4
    ADDA.L       D4,  A1
    MOVE.B      #14, D0
    TRAP        #15
    LEA         SPACE_MSG,      A1
    MOVE.B      #14,            D0    
    TRAP        #15
    RTS




SHIFT_ROTATE_EA_REGISTER
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #5, D5
    MOVE.L     #5, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    CMP.L      #1,  D4
    BNE        SHIFT_ROTATE_IMM_SOURCE

SHIFT_ROTATE_REGISTER_SOURCE
    LEA        D_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #9, D5
    MOVE.L     #11, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    LEA       ZERO_MSG, A1
    MULU      #2, D4    
    ADDA.L    D4, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    BRA       SHIFT_ROTATE_REGISTER_DEST

SHIFT_ROTATE_REGISTER_DEST
    LEA        COMMA_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    LEA        SPACE_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    LEA        D_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #0, D5
    MOVE.L     #2, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    CMP.L      #0, D4
    BEQ       SHIFT_ROTATE_COUNT_8

SHIFT_ROTATE_COUNT_1_7
    LEA       ZERO_MSG, A1
    MULU      #2, D4    
    ADDA.L    D4, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    RTS

SHIFT_ROTATE_COUNT_8
    LEA       EIGHT_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    RTS



SHIFT_ROTATE_IMM_SOURCE
    LEA        HASH_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    LEA        DOLLAR_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #9, D5
    MOVE.L     #11, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    LEA       ZERO_MSG, A1
    MULU      #2, D4    
    ADDA.L    D4, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    BRA      SHIFT_ROTATE_REGISTER_DEST
 


SHIFT_ROTATE_EA_MEMORY
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #0, D5
    MOVE.L     #5, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    MOVEM.L    D3/D5-D6, -(A7)
    MOVE.L     D4, D3
    JSR        GET_EA
    MOVEM.L    (A7)+, D3/D5-D6
    LEA         NEW_LINE,       A1
    MOVE.B      #14,            D0    
    TRAP        #15
    RTS

********************************End of shift/rotate EA functions**************************


********************************Start of BR/BCC EA functions****************************
BR_EA_SIZE_AND_DISPLACEMENT
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #0, D5
    MOVE.L     #7, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    CMP.L      #0, D4
    BEQ        BR_WORD_DISPLACEMENT
BR_BYTE_DISPLACEMENT
    LEA         BYTE_MSG, A1
    MOVE.B      #14, D0
    TRAP        #15
    LEA         SPACE_MSG,   A1
    MOVE.B      #14,   D0    
    TRAP        #15
    JSR         PRINT_BYTE_VALUE
    RTS
BR_WORD_DISPLACEMENT
    LEA         WORD_MSG, A1
    MOVE.B      #14, D0
    TRAP        #15
    LEA         SPACE_MSG,   A1
    MOVE.B      #14,   D0    
    TRAP        #15
    CLR.L       D4
    MOVE.W      (A3)+, D4
    JSR         PRINT_WORD_VALUE
    RTS


********************************End of BR/BCC EA functions****************************

********************************Start of LEA EA functions*****************************


LEA_EA
    *Prints the source operand
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #0, D5
    MOVE.L     #5, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    MOVEM.L    D3/D5-D6, -(A7)
    MOVE.L     D4, D3
    JSR        GET_EA
    MOVEM.L    (A7)+, D3/D5-D6

    LEA        COMMA_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15

    *Prints the dest operand
    LEA        A_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #9, D5
    MOVE.L     #11, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    LEA       ZERO_MSG, A1
    MULU      #2, D4    
    ADDA.L    D4, A1
    MOVE.B      #14,   D0    
    TRAP        #15

    LEA         NEW_LINE,       A1
    MOVE.B      #14,            D0    
    TRAP        #15
    
    RTS


********************************End of LEA EA functions*******************************


*********************************Start of ADDQ EA functions**************************
ADDQ_EA_SIZE_AND_EA 
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #8, D5
    MOVE.L     #8, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    LEA        WORD_MSG, A1
    MULU       #2, D4
    ADDA.L     D4, A1
    MOVE.B      #14, D0
    TRAP        #15

    LEA         SPACE_MSG,   A1
    MOVE.B      #14,   D0    
    TRAP        #15

    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #0, D5
    MOVE.L     #5, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    CMP.L      #%111100, D4
    BEQ        ADDQ_EA_IMM_SOURCE
ADDQ_EA_NON_IMM_SOURCE
    MOVEM.L    D3/D5-D6, -(A7)
    MOVE.L     D4, D3     
    JSR        GET_EA
    MOVEM.L    (A7)+, D3/D5-D6
    BRA        ADDQ_EA_DEST
ADDQ_EA_IMM_SOURCE
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #6, D5
    MOVE.L     #8, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    CMP.L      #%011, D4
    BEQ        ADD_EA_IMM_WORD
ADDQ_EA_IMM_LONG
    MOVE.L     (A3)+, D4
    JSR        PRINT_LONG_VALUE

    LEA         COMMA_MSG,   A1
    MOVE.B      #14,   D0    
    TRAP        #15
    BRA         ADDQ_EA_DEST
ADDQ_EA_IMM_WORD
    MOVE.W     (A3)+, D4
    JSR        PRINT_WORD_VALUE

    LEA         COMMA_MSG,   A1
    MOVE.B      #14,   D0    
    TRAP        #15
    BRA         ADDQ_EA_DEST

ADDQ_EA_DEST   
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #9, D5
    MOVE.L     #11, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    LEA   A_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA    ZERO_MSG, A1
    MULU       #2, D4
    ADDA.L     D4, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA         NEW_LINE,       A1
    MOVE.B      #14,            D0    
    TRAP        #15
    RTS


*********************************End of ADDQ EA functions***************************
*D3 holds the mode+register bits
*A3 points to current address in memory which is being scanned
*D5, D6, D4 can be used as temporary storage registers
GET_EA
    MOVE.L     #3, D5
    MOVE.L     #5, D6
    JSR        GET_BIT
    CMP.L      #0, D4
    BEQ        EA_DATA_REGISTER
    CMP.L      #1, D4
    BEQ        EA_ADDR_REGISTER
    CMP.L      #2, D4
    BEQ        EA_INDIRECT
    CMP.L      #3, D4
    BEQ        EA_INDIRECT_INCREMENT
    CMP.L      #4, D4
    BEQ        EA_INDIRECT_DECREMENT
    *101, and 110 mode bits should be detected in disassembler_OPCodes 
    MOVE.L     #0, D5
    MOVE.L     #2, D6
    JSR        GET_BIT
    CMP.L      #0, D4
    BEQ        EA_ABS_WORD
    CMP.L      #1, D4
    BEQ        EA_ABS_LONG
    *Unreachable
    RTS
    

*D3 holds the mode+register bits
*A3 points to current address in memory which is being scanned
*D5, D6, D4 can be used as temporary storage registers
EA_DATA_REGISTER
    LEA   D_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA    ZERO_MSG, A1
    MOVE.L     #0, D5
    MOVE.L     #2, D6
    JSR        GET_BIT
    MULU       #2, D4
    ADDA.L     D4, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    RTS


EA_ADDR_REGISTER
    LEA   A_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA    ZERO_MSG, A1
    MOVE.L     #0, D5
    MOVE.L     #2, D6
    JSR        GET_BIT
    MULU       #2, D4
    ADDA.L     D4, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    RTS


EA_INDIRECT
    LEA   OPEN_PARENTHESIS_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA   A_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA    ZERO_MSG, A1
    MOVE.L     #0, D5
    MOVE.L     #2, D6
    JSR        GET_BIT
    MULU       #2, D4
    ADDA.L     D4, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA   CLOSE_PARENTHESIS_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    RTS



EA_INDIRECT_INCREMENT
    LEA   OPEN_PARENTHESIS_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA   A_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA    ZERO_MSG, A1
    MOVE.L     #0, D5
    MOVE.L     #2, D6
    JSR        GET_BIT
    MULU       #2, D4
    ADDA.L     D4, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA   CLOSE_PARENTHESIS_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA   PLUS_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    RTS


EA_INDIRECT_DECREMENT
    LEA   MINUS_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA   OPEN_PARENTHESIS_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA   A_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA    ZERO_MSG, A1
    MOVE.L     #0, D5
    MOVE.L     #2, D6
    JSR        GET_BIT
    MULU       #2, D4
    ADDA.L     D4, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    LEA   CLOSE_PARENTHESIS_MSG, A1
    MOVE.B   #14,  D0    
    TRAP     #15
    RTS



EA_ABS_WORD
    CLR.L      D4
    MOVE.W     (A3)+, D4
    LEA        DOLLAR_MSG,       A1
    MOVE.B      #14,            D0    
    TRAP        #15
    JSR        PRINT_WORD_VALUE
    RTS

EA_ABS_LONG
    MOVE.L    (A3)+, D4
    LEA        DOLLAR_MSG,       A1
    MOVE.B      #14,            D0    
    TRAP        #15
    JSR        PRINT_LONG_VALUE
    RTS




*Prints the byte size value.
*The value is in D4
PRINT_BYTE_VALUE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #2, D6
PRINT_BYTE_VALUE_LOOP
        *Gets the most significant bit basically
        *Could use GET_BIT subroutine but it is 
        *costly in terms of registers used
        MOVE.B     D4, D5
        LSR.B      #4, D5
        LSL.B      #4, D4
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
        BNE         PRINT_BYTE_VALUE_LOOP
        MOVEM.L    (A7)+, D5-D6
        RTS



*Prints the word size value.
*The value is in D4
PRINT_WORD_VALUE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #4, D6
PRINT_WORD_VALUE_LOOP
        *Gets the most significant bit basically
        *Could use GET_BIT subroutine but it is 
        *costly in terms of registers used
        MOVE.W     D4, D5
        LSR.W      #6, D5
        LSR.W      #6, D5
        LSL.W      #4, D4
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
        BNE         PRINT_WORD_VALUE_LOOP
        MOVEM.L    (A7)+, D5-D6
        RTS


*Prints the long size value.
*The value is in D4
PRINT_LONG_VALUE
        MOVEM.L    D5-D6, -(A7)
        MOVE.L     #8, D6
PRINT_LONG_VALUE_LOOP
        *Gets the most significant bit basically
        *Could use GET_BIT subroutine but it is 
        *costly in terms of registers used
        MOVE.L     D4, D5
        LSR.L      #8, D5
        LSR.L      #8, D5
        LSR.L      #8, D5
        LSR.L      #4, D5
        LSL.L      #4, D4
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
        BNE         PRINT_LONG_VALUE_LOOP
        MOVEM.L    (A7)+, D5-D6
        RTS


 