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
        
*--------------------------------Start of opcode sizes        
BYTE_SIZE:
        LEA         DOT_BYTE, A1
        MOVE.B      #14, D0
        TRAP        #15

        BRA         PREP_FOR_ROT
WORD_SIZE:
        LEA         DOT_WORD, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        BRA         PREP_FOR_ROT
LONG_SIZE:
        LEA         DOT_LONG, A1
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
        LEA         START_PAREN, A1
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
        
        LEA         END_PAREN, A1
        MOVE.B      #14, D0
        TRAP        #15
        RTS
ADDPP_EA:
        *print the '(A'
        LEA         START_PAREN, A1
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
        
        LEA         END_PAREN, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         PLUS_SIGN, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        RTS
ADDPM_EA:
        *print the '-(A'
        LEA         MINUS_SIGN, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         START_PAREN, A1
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
        
        LEA         END_PAREN, A1
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
        
        LEA         HEX, A1
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
        LEA         IMM_DATA, A1
        MOVE.B      #14, D0
        TRAP        #15
        
        LEA         HEX, A1
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
        LEA         HEX, A1
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





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
