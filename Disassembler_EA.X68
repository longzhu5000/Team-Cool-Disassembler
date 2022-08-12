*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------


*Prints out appropriate register number
*does not print 'D' or 'A'
REGISTER_11_9:
        *make a copy
        MOVE.W      D3,     D4
        
        *isolate bits 11-9 on the right
        MOVE.W      #4,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15
        
        RTS
*Appends the size to the opcode (.B, .W, .L)
*Preps for rotating leftmost bit to see which form to use (<ea>, Dn -> Dn)/(Dn, <ea> -> <ea>)
OPMODE_8_6:
        *append size to opcode
        MOVE.W      D3,     D4
        
        MOVE.W      #7,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        CMP.B       #$0,    D4
        BEQ         BYTE_SIZE
        
        CMP.B       #$4,    D4
        BEQ         BYTE_SIZE
        
        CMP.B       #$1,    D4
        BEQ         WORD_SIZE
        
        CMP.B       #$5,    D4
        BEQ         WORD_SIZE
        
        CMP.B       #$2,    D4
        BEQ         LONG_SIZE
        
        CMP.B       #$6,    D4
        BEQ         LONG_SIZE
           
        *isolates bits 8-6 to D4 on the left side, so rotation can be done in higher level to corresponding output for opmode
PREP_FOR_ROT:
        *MOVE.W      D3,     D4
        
        MOVE.W      #13,     D2
        LSL.W       D2,     D4
        *MOVE.W      #13,    D2
        *LSR.W       D2,     D4
        
        RTS

*Appends the size to the opcode (.B, .W, .L)
SIZE_13_12:
        MOVE.W      D3,     D4
        
        MOVE.W      #2,     D2
        LSL.W       D2,     D4
        MOVE.W      #14,    D2
        LSR.W       D2,     D4
        
        CMP.B       #$1,    D4
        BEQ         BYTE_SIZE
        
        CMP.B       #$3,    D4
        BEQ         WORD_SIZE
        
        CMP.B       #$2,    D4
        BEQ         LONG_SIZE
        
        RTS
        
*Appends the size to the opcode (.B, .W, .L)
SIZE_7_6:
        MOVE.W      D3,     D4
        
        MOVE.W      #8,     D2
        LSL.W       D2,     D4
        MOVE.W      #14,    D2
        LSR.W       D2,     D4
        
        CMP.B       #$0,    D4
        BEQ         BYTE_SIZE
        
        CMP.B       #$1,    D4
        BEQ         WORD_SIZE
        
        CMP.B       #$2,    D4
        BEQ         LONG_SIZE
        
        RTS

*Appends the size to the opcode (.W, .L)
SIZE_6:
        MOVE.W      D3,     D4
        
        MOVE.W      #9,     D2
        LSL.W       D2,     D4
        MOVE.W      #15,    D2
        LSR.W       D2,     D4

        
        CMP.B       #$0,    D4
        BEQ         WORD_SIZE
        
        CMP.B       #$1,    D4
        BEQ         LONG_SIZE
        
        RTS
        
*--------------------------------Start of opcode sizes        
BYTE_SIZE:
        LEA         BYTE_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15

        BRA         PREP_FOR_ROT
WORD_SIZE:
        LEA         WORD_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        BRA         PREP_FOR_ROT
LONG_SIZE:
        LEA         LONG_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        BRA         PREP_FOR_ROT
*Handles EA, prints out appropriate registers and numbers
*immediate data may need editing
EFFECTIVEADD_5_0:
        *isolate mode bits (5-3)
        *make a copy
        MOVE.W      D3,     D4
        
        *isolate bits 5-3 on the right
        MOVE.W      #10,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        CMP.B       #$0,    D4
        BEQ         DATAR_EA
        
        CMP.B       #$1,    D4
        BEQ         ADDR_EA
        
        CMP.B       #$2,    D4
        BEQ         ADDP_EA
        
        CMP.B       #$3,    D4
        BEQ         ADDPP_EA
        
        CMP.B       #$4,    D4
        BEQ         ADDPM_EA
        
        CMP.B       #$7,    D4
        BEQ         IDATA_EA

        RTS
        
        
*----------------------------------------MOVE, MOVEA EA, and MOVEM       
DESTINATION_11_6: 
       
        MOVE.W      D3,     D4
        *isolate bits 8-6 on the right
        MOVE.W      #7,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        CMP.B       #$0,    D4
        BEQ         PRINT_DESTINATION_DATA
        
        CMP.B       #$1,    D4
        BEQ         DEST_A_EA
        
        CMP.B       #$2,    D4
        BEQ         DEST_P_EA
        
        CMP.B       #$3,    D4
        BEQ         DEST_PP_EA
        
        CMP.B       #$4,    D4
        BEQ         DEST_PM_EA
        
        CMP.B       #$7,    D4
        BEQ         IDATA_EA
        
        RTS

PRINT_DESTINATION_DATA:
        LEA         DATA_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.W      D3,     D4
        
        *print the reg num
        *isolate bits 11-9 on the right
        MOVE.W      #4,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15

        RTS
DEST_A_EA:
        *print the 'A'
        LEA         ADDR_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.W      D3,     D4
        
        *print the reg num
        *isolate bits 11-9 on the right
        MOVE.W      #4,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15

        RTS
DEST_P_EA:
        *print the '(A'
        LEA         OPEN_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         ADDR_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.W      D3,     D4
        
        *print the reg num
        *isolate bits 11-9 on the right
        MOVE.W      #4,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15
        
        LEA         CLOSE_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        RTS
DEST_PP_EA:
        *print the '(A'
        LEA         OPEN_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         ADDR_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.W      D3,     D4
        
        *print the reg num
        *isolate bits 11-9 on the right
        MOVE.W      #4,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15
        
        LEA         CLOSE_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         PLUS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
DEST_PM_EA:
        *print the '-(A'
        LEA         MINUS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         OPEN_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         ADDR_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.W      D3,     D4
        
        *print the reg num
        *isolate bits 2-0 on the right
        MOVE.W      #13,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15
        
        LEA         CLOSE_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS


PRE_DECR_MASK_FIELD:

        CMP.B       #$F,    D0
        BGT         EXIT_LOOP_DECR
        ROL         #1,     D4      
        BCS         PRE_DECR_LOOP_TRACK
        BCC         PRE_DECR_LOOP_UNTRACK

PRE_DECR_LOOP_TRACK:
        *   D0  keeps track of num of bits
        *   D1  keeps track of first reg
        *   D2  keeps track of value for some other logic
        *   D3  keeps track of word data from memory
        *   D4  holds the rotating word
        *   D5  keeps track of space between reg, - if not set, and / if set
        *   D6  keeps track of second reg

        CMP.W       #$FF,   D1
        BNE         PRE_DECR_LOOP_TRACK_SECOND
        
        
        MOVE.B      D0,     D1
        ADD.B       #1,     D0
        BRA         PRE_DECR_MASK_FIELD
        
PRE_DECR_LOOP_TRACK_SECOND:


        MOVE.B      D0,     D6
        ADD.B       #1,     D0
        BRA         PRE_DECR_MASK_FIELD
        
PRE_DECR_LOOP_UNTRACK:
        ADD.B       #1,     D0
        CMP.B       #$FF,   D1
        BEQ         PRE_DECR_MASK_FIELD
        
        CMP.B       #$FF,    D6
        BNE         PRE_DECR_MASK_FIELD
        MOVE.B      #$1,    D5

        BRA         PRE_DECR_MASK_FIELD

EXIT_LOOP_DECR:

        CLR.L       D3
        MOVE.B      D1,     D3
        CMP.B       #$7,    D1
        BGT         DECR_1_A
        BLE         DECR_1_B

        RTS
DECR_1_A:
        JSR         PRINT_A_DECR
        BRA         DECR_2
DECR_1_B:
        JSR         PRINT_D_DECR
        BRA         DECR_2

DECR_2:
        CMP.B       #$0,    D5
        BEQ         DECR_2_A
        BNE         DECR_2_B
        
DECR_2_A:
        JSR         PRINT_MINUS
        BRA         DECR_3
        
DECR_2_B:
        JSR         PRINT_DIV
        BRA         DECR_3
        
DECR_3:
        CLR.L       D3
        MOVE.B      D6,     D3
        CMP.B       #$7,    D6
        BGT         DECR_3_A
        BLE         DECR_3_B

DECR_3_A:
        JSR         PRINT_A_DECR
        RTS
DECR_3_B:
        JSR         PRINT_D_DECR
        RTS


PRINT_D_DECR:

        LEA         DATA_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         ZERO_MSG, A1
        MULU        #2,       D3
        ADDA.L      D3,       A1
        
        MOVE.B      #14, D0
        TRAP        #15

        RTS 
PRINT_A_DECR:
        LEA         ADDR_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        SUB.B       #$8,      D3
        LEA         ZERO_MSG, A1
        MULU        #2,       D3
        ADDA.L      D3,       A1
        
        MOVE.B      #14, D0
        TRAP        #15

        RTS 


       
POST_INCR_MASK_FIELD:
        CMP.B       #$0,    D0
        BLT         EXIT_LOOP_INCR
        ROL         #1,     D4      
        BCS         POST_INCR_LOOP_TRACK
        BCC         POST_INCR_LOOP_UNTRACK

POST_INCR_LOOP_TRACK:
        *   D0  keeps track of num of bits
        *   D1  keeps track of first reg
        *   D2  keeps track of value for some other logic
        *   D3  keeps track of word data from memory
        *   D4  holds the rotating word
        *   D5  keeps track of space between reg, - if not set, and / if set
        *   D6  keeps track of second reg
        CMP.W       #$FF,   D1
        BNE         POST_INCR_LOOP_TRACK_SECOND
        
        
        MOVE.B      D0,     D1
        SUB.B       #1,     D0
        BRA         POST_INCR_MASK_FIELD
        
POST_INCR_LOOP_TRACK_SECOND:


        MOVE.B      D0,     D6
        SUB.B       #1,     D0
        BRA         POST_INCR_MASK_FIELD
        
POST_INCR_LOOP_UNTRACK:
        SUB.B       #1,     D0
        CMP.B       #$FF,   D1
        BEQ         POST_INCR_MASK_FIELD
        
        CMP.B       #$FF,    D6
        BNE         POST_INCR_MASK_FIELD
        MOVE.B      #$1,    D5

        BRA         POST_INCR_MASK_FIELD

EXIT_LOOP_INCR:
        CLR.L       D3
        MOVE.B      D1,     D3
        CMP.B       #$7,    D1
        BGT         INCR_1_A
        BLE         INCR_1_B

        RTS
INCR_1_A:
        JSR         PRINT_A_INCR
        BRA         INCR_2
INCR_1_B:
        JSR         PRINT_D_INCR
        BRA         INCR_2

INCR_2:
        CMP.B       #$0,    D5
        BEQ         INCR_2_A
        BNE         INCR_2_B
        
INCR_2_A:
        JSR         PRINT_MINUS
        BRA         INCR_3
        
INCR_2_B:
        JSR         PRINT_DIV
        BRA         INCR_3
        
INCR_3:
        CLR.L       D3
        MOVE.B      D6,     D3
        CMP.B       #$7,    D6
        BGT         INCR_3_A
        BLE         INCR_3_B

INCR_3_A:
        JSR         PRINT_A_INCR
        RTS
INCR_3_B:
        JSR         PRINT_D_INCR
        RTS


PRINT_D_INCR:

        LEA         DATA_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        
        LEA         ZERO_MSG, A1
        MULU        #2,       D3
        ADDA.L      D3,       A1
        
        MOVE.B      #14, D0
        TRAP        #15

        RTS 
PRINT_A_INCR:
        LEA         ADDR_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        SUB.B       #$8,      D3
        LEA         ZERO_MSG, A1
        MULU        #2,       D3
        ADDA.L      D3,       A1
        
        MOVE.B      #14, D0
        TRAP        #15

        RTS

PRINT_MINUS:
        LEA         MINUS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15

        RTS

PRINT_DIV:
        LEA         DIV_SIGN, A1
        MOVE.B      #14, D0
        TRAP        #15

        RTS       
*----------------------------------------Start of EA branches
DATAR_EA:
        *print the 'D'
        LEA         DATA_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.W      D3,     D4
        
        *print the reg num
        *isolate bits 2-0 on the right
        MOVE.W      #13,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15

        RTS
ADDR_EA:
        *print the 'A'
        LEA         ADDR_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.W      D3,     D4
        
        *print the reg num
        *isolate bits 2-0 on the right
        MOVE.W      #13,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15

        RTS
ADDP_EA:
        *print the '(A'
        LEA         OPEN_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         ADDR_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.W      D3,     D4
        
        *print the reg num
        *isolate bits 2-0 on the right
        MOVE.W      #13,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15
        
        LEA         CLOSE_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        RTS
ADDPP_EA:
        *print the '(A'
        LEA         OPEN_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         ADDR_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.W      D3,     D4
        
        *print the reg num
        *isolate bits 2-0 on the right
        MOVE.W      #13,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15
        
        LEA         CLOSE_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         PLUS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
ADDPM_EA:
        *print the '-(A'
        LEA         MINUS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         OPEN_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         ADDR_REG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        MOVE.W      D3,     D4
        
        *print the reg num
        *isolate bits 2-0 on the right
        MOVE.W      #13,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *print out the register number
        MOVE.L      D4,     D1
        MOVE.B      #3,     D0
        TRAP        #15
        
        LEA         CLOSE_PARENTHESIS_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
IDATA_EA:
        *(not doing this)check register to see if it's W or L addressinG
        *use (A3)+.W or .L to get the address data
        *print it out
        
        *->take the next long and spit it out
        *print out the data in hex form
        *NOTE that if register = 100 it means raw data, can be in decimal b/c not address
        
        MOVE.W      D3,     D4
        
        *get reg num
        *isolate bits 2-0 on the right
        MOVE.W      #13,     D2
        LSL.W       D2,     D4
        MOVE.W      #13,    D2
        LSR.W       D2,     D4
        
        *raw data
        CMP         #$4,    D4
        BEQ         IDATA
        
        *W addressing
        CMP         #$0,    D4
        BEQ         WADDR
        
        LEA         DOLLAR_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        *MOVE.B      #16,    D2          *base 16
        *MOVE.B      #15,    D0
        MOVE.L      (A3)+,   D4
        JSR         PRINT_LONG_VALUE
        *TRAP        #15
        
        RTS
*immediate data, print as hex or binary?
IDATA:
        LEA         HASH_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         DOLLAR_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        *MOVE.W      (A3)+,     D1
        *MOVE.B      #3,     D0
        *TRAP        #15
        
        *MOVE.B      #16,    D2          *base 16
        *MOVE.B      #15,    D0
        MOVE.W      (A3)+,   D4
        JSR         PRINT_WORD_VALUE
        *TRAP        #15

        RTS
        
WADDR:
        LEA         DOLLAR_MSG, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        *MOVE.B      #16,    D2          *base 16
        *MOVE.B      #15,    D0
        MOVE.W      (A3)+,   D4
        JSR         PRINT_WORD_VALUE
        *TRAP        #15
        
        RTS

        
*Prints out hex data
*immediate data, print as hex or binary?
DATA_7_0:
        *make a copy
        MOVE.W      D3,     D4
        
        *isolate bits 7-0 on the right
        MOVE.W      #8,     D2
        LSL.W       D2,     D4
        MOVE.W      #8,     D2
        LSR.W       D2,     D4
        
         *print out the data in hex form
        *MOVE.B      #16,    D2          *base 16
        *MOVE.B      #15,    D0
        *MOVE.W      D4,     D1
        JSR         PRINT_WORD_VALUE
        *TRAP        #15


        RTS

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
    LEA        D_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #0, D5
    MOVE.L     #2, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    LEA       ZERO_MSG, A1
    MULU      #2, D4    
    ADDA.L    D4, A1
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
    CMP.L      #0, D4
    BEQ       SHIFT_ROTATE_COUNT_8
    BRA       SHIFT_ROTATE_COUNT_1_7
 
SHIFT_ROTATE_COUNT_1_7
    LEA       ZERO_MSG, A1
    MULU      #2, D4    
    ADDA.L    D4, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    BRA       SHIFT_ROTATE_REGISTER_DEST

SHIFT_ROTATE_COUNT_8
    LEA       EIGHT_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    BRA       SHIFT_ROTATE_REGISTER_DEST





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
    MOVEM.L     D5, -(A7)
    MOVE.L      D4, D5
    ROL.B       #1, D5
    ANDI.L      #1, D5
    CMP.B       #1, D5
    BEQ         NEG_BYTE_DISPLACEMENT
    MOVEM.L    (A7)+, D5
    ADD.L       A3, D4
    JSR         PRINT_LONG_VALUE
    RTS
NEG_BYTE_DISPLACEMENT
    MOVEM.L    (A7)+, D5
    NEG.B       D4
    SUB.L       A3, D4
    NEG.L       D4
    JSR         PRINT_LONG_VALUE
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
    MOVEM.L     D5, -(A7)
    MOVE.L      D4, D5
    ROL.W       #1, D5
    ANDI.L      #1, D5
    CMP.B       #1, D5
    BEQ         NEG_WORD_DISPLACEMENT
    MOVEM.L    (A7)+, D5
    ADD.L       A3, D4
    SUB.L       #2, D4
    JSR         PRINT_LONG_VALUE
    RTS
NEG_WORD_DISPLACEMENT
    MOVEM.L    (A7)+, D5
    NEG.W       D4
    SUB.L       A3, D4
    NEG.L       D4
    SUB.L       #2, D4
    JSR         PRINT_LONG_VALUE
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
    RTS


********************************End of LEA EA functions*******************************


*********************************Start of ADDA EA functions**************************
ADDA_EA_SIZE_AND_EA 
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #8, D5
    MOVE.L     #8, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    LEA        WORD_MSG, A1
    MULU       #3, D4
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
    BEQ        ADDA_EA_IMM_SOURCE
ADDA_EA_NON_IMM_SOURCE
    MOVEM.L    D3/D5-D6, -(A7)
    MOVE.L     D4, D3     
    JSR        GET_EA
    LEA         COMMA_MSG,   A1
    MOVE.B      #14,   D0    
    TRAP        #15
    MOVEM.L    (A7)+, D3/D5-D6
    BRA        ADDA_EA_DEST
ADDA_EA_IMM_SOURCE
    LEA        HASH_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    LEA        DOLLAR_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #6, D5
    MOVE.L     #8, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    CMP.L      #%011, D4
    BEQ        ADDA_EA_IMM_WORD
ADDA_EA_IMM_LONG
    MOVE.L     (A3)+, D4
    JSR        PRINT_LONG_VALUE

    LEA         COMMA_MSG,   A1
    MOVE.B      #14,   D0    
    TRAP        #15
    BRA         ADDA_EA_DEST
ADDA_EA_IMM_WORD
    MOVE.W     (A3)+, D4
    JSR        PRINT_WORD_VALUE

    LEA         COMMA_MSG,   A1
    MOVE.B      #14,   D0    
    TRAP        #15
    BRA         ADDA_EA_DEST

ADDA_EA_DEST   
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
    RTS


*********************************End of ADDA EA functions***************************


********************************Start of ADDQ EA functions***************************
ADDQ_EA_SIZE_AND_EA
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

    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #9, D5
    MOVE.L     #11, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    LEA        HASH_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    LEA        DOLLAR_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    CMP.L      #0, D4
    BEQ       ADDQ_ADD_COUNT_8

ADDQ_ADD_COUNT_1_7
    LEA       ZERO_MSG, A1
    MULU      #2, D4    
    ADDA.L    D4, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    LEA         COMMA_MSG,   A1
    MOVE.B      #14,   D0    
    TRAP        #15
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #0, D5
    MOVE.L     #5, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    MOVEM.L    D3/D5-D6, -(A7)
    MOVE.L     D4, D3
    JSR        GET_EA
    MOVEM.L    (A7)+, D3/D5-D6
    RTS

ADDQ_ADD_COUNT_8
    LEA       EIGHT_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    LEA         COMMA_MSG,   A1
    MOVE.B      #14,   D0    
    TRAP        #15
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #0, D5
    MOVE.L     #5, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    MOVEM.L    D3/D5-D6, -(A7)
    MOVE.L     D4, D3   
    JSR        GET_EA
    MOVEM.L    (A7)+, D3/D5-D6
    RTS




********************************End of ADDQ EA functions*****************************

********************************Start of ADD EA functions****************************

ADD_SUB_EA_SIZE
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #6, D5
    MOVE.L     #8, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    ANDI.L     #%011, D4
    LEA        BYTE_MSG, A1
    MULU       #3, D4
    ADDA.L       D4,  A1
    MOVE.B      #14, D0
    TRAP        #15
    RTS

ADD_SUB_EA_REG
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
    RTS


ADD_SUB_EA_EA
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #0, D5
    MOVE.L     #5, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    CMP.L      #%111100, D4
    BEQ        ADD_SUB_EA_EA_IMM
    MOVEM.L    D3/D5-D6, -(A7)
    MOVE.L     D4, D3   
    JSR        GET_EA
    MOVEM.L    (A7)+, D3/D5-D6
    RTS

ADD_SUB_EA_EA_IMM
    LEA        HASH_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    LEA        DOLLAR_MSG, A1
    MOVE.B      #14,   D0    
    TRAP        #15
    MOVEM.L    D5-D6, -(A7)
    MOVE.L     #6, D5
    MOVE.L     #8, D6
    JSR        GET_BIT
    MOVEM.L    (A7)+, D5-D6
    ANDI.L     #%011, D4
    CMP.L      #%010, D4
    BNE        ADD_SUB_EA_EA_IMM_WORD
ADD_SUB_EA_EA_IMM_LONG
    MOVE.L     (A3)+, D4
    JSR         PRINT_LONG_VALUE
    RTS
ADD_SUB_EA_EA_IMM_WORD
    MOVE.W     (A3)+, D4
    JSR        PRINT_WORD_VALUE
    RTS


********************************End of ADD EA functions*****************************


















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


 





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
