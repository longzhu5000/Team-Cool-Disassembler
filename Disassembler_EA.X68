*--------------------------------------------------------------------
* Title      : EA 
* Written by :
* Date       :
* Description: Compare OPMODE for bit 6-8 of ADD, ADDA, SUB, AND, OR
*--------------------------------------------------------------------


*----------------------------------------------
* D2 stores unique values for isolation
* D3 store original data
* D4 to copy and modify D3      (OPMODE; bit 8-6)
* D5 to copy and modify D3      (EAMODE; bit 5-3)
* D6 to copy and modify D3      (EAREG;  bit 2-0)
*----------------------------------------------
CHECK_OPMODE:
        JSR         OPMODE_ISOLATE_8_6
        
        RTS
        
OPMODE_ISOLATE_8_6:
        MOVE.L      D3,     D4
        MOVE.L      #6,     D2
        LSR.L       D2,     D4
        MOVE.L      #29,    D2
        LSL.L       D2,     D4
        LSR.L       D2,     D4      ;D4 Holds bit 8-6
        
        JSR         CMP_OPMODE
        
        CMP.B       #$0,    D4      ;<ea>, Dn       EXCEPT FOR SUB (REVERSED)
        BEQ         OP_FIELD_DN
        
        CMP.B       #$1,    D4      ;<ea>, Dn
        BEQ         OP_FIELD_DN
        
        CMP.B       #$2,    D4      ;<ea>, Dn
        BEQ         OP_FIELD_DN
        
        CMP.B       #$4,    D4      ;Dn, <ea>
        BEQ         OP_FIELD_EA
        
        CMP.B       #$5,    D4      ;Dn, <ea>
        BEQ         OP_FIELD_EA
        
        CMP.B       #$6,    D4      ;Dn, <ea>
        BEQ         OP_FIELD_EA
        
        CMP.B       #$3,    D4      ;#$3 and #$7 are ADDA
        BEQ         OP_FIELD_DN
        
        CMP.B       #$7,    D4
        BEQ         OP_FIELD_DN
        
        RTS
        
OP_FIELD_DN:
        JSR         ISO_EA
                
        LEA         COMMA_MSG,  A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        JSR         ISO_REG_11_9
        
        RTS
        
OP_FIELD_EA:
        JSR         ISO_REG_11_9
        
        LEA         COMMA_MSG,  A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        JSR         ISO_EA
        
        RTS
*-------------------------------------
CMP_OPMODE:
        CMP.B       #$0,    D4       
        BEQ         TYPE_B
        
        CMP.B       #$1,    D4
        BEQ         TYPE_W
        
        CMP.B       #$2,    D4
        BEQ         TYPE_L
        
        CMP.B       #$4,    D4
        BEQ         TYPE_B
        
        CMP.B       #$5,    D4
        BEQ         TYPE_W
        
        CMP.B       #$6,    D4
        BEQ         TYPE_L
        
        BNE         OP_ADDA
        
        RTS
*------------------------------------------        
ISO_EA:
        CLR.L       D5
        CLR.L       D6
        CLR.L       D2
        
        MOVE.L      D3,     D5          ;isolate EA Mode bit 5-3, store in D5
        MOVE.L      #3,     D2          
        LSR.L       D2,     D5
        MOVE.L      #29,    D2
        LSL.L       D2,     D5
        LSR.L       D2,     D5
        
        MOVE.L      D3,     D6          ;isolate EA Reg bit 2-0, store in D6
        MOVE.L      #29,    D2
        LSL.L       D2,     D6
        LSR.L       D2,     D6          
        JSR         EA_MODE
        
        RTS

ISO_REG_11_9:
        CLR.L       D6
        CLR.L       D5
        CLR.L       D2
        
        CMP.B       #$3,    D4
        BEQ         IS_ADDA
        CMP.B       #$7,    D4
        BEQ         IS_ADDA
        
        MOVE.L      D3,     D6          ;isolate bit 11-9 for register
        MOVE.L      #9,     D2
        LSR.L       D2,     D6
        MOVE.L      #29,    D2
        LSL.L       D2,     D6
        LSR.L       D2,     D6 
        
        JSR         EA_MODE
        
        RTS
        
*-------------------------------------
* Because ADDA is unique
* always prints out An as destination
*-------------------------------------
IS_ADDA:
        LEA         SPACE_MSG,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        LEA         A_MSG,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        
        MOVE.L      D3,     D6
        MOVE.L      #9,     D2
        LSR.L       D2,     D6
        MOVE.L      #29,    D2
        LSL.L       D2,     D6
        LSR.L       D2,     D6 
        
        JSR         REG

        RTS
*---------------------------------------
EA_MODE:                                ;Finds out EA mode value and type        
        CMP.B       #0,     D5
        BEQ         DN
        CMP.B       #1,     D5
        BEQ         AN_DIRECT
        CMP.B       #2,     D5
        BEQ         AN_INDIRECT
        CMP.B       #3,     D5
        BEQ         AN_INC
        CMP.B       #4,     D5
        BEQ         AN_DEC
        CMP.B       #7,     D5
        BEQ         ABSOLUTE
        
        RTS

REG:                                    ;Finds out REG BIT value and type
        CMP.B       #0,     D6
        BEQ         ZERO                ;value of bits 0-7
        CMP.B       #1,     D6
        BEQ         ONE
        CMP.B       #2,     D6
        BEQ         TWO
        CMP.B       #3,     D6
        BEQ         THREE
        CMP.B       #4,     D6
        BEQ         FOUR
        CMP.B       #5,     D6
        BEQ         FIVE
        CMP.B       #6,     D6
        BEQ         SIX
        CMP.B       #7,     D6
        BEQ         SEVEN
        RTS
        
        
*---------------------------------------
DN:
        LEA         SPACE_MSG,  A1
        MOVE.B      #14,        D0
        TRAP        #15
        LEA         D_MSG,      A1
        MOVE.B      #14,        D0
        TRAP        #15
        ;CODE HERE
        JSR         REG
        RTS
        
AN_DIRECT:
        LEA         SPACE_MSG,  A1
        MOVE.B      #14,        D0
        TRAP        #15
        LEA         A_MSG,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        ;CODE HERE
        JSR         REG
        RTS
        
AN_INDIRECT:
        LEA         SPACE_MSG,  A1
        MOVE.B      #14,        D0
        TRAP        #15
        LEA         OPEN_PAR,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        LEA         A_MSG,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        ;CODE HERE
        JSR         REG
        LEA         CLOSE_PAR,  A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        RTS
        
AN_INC:
        LEA         SPACE_MSG,  A1
        MOVE.B      #14,        D0
        TRAP        #15
        LEA         OPEN_PAR,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        LEA         A_MSG,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        ;CODE HERE
        JSR         REG
        LEA         CLOSE_PAR,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        LEA         PLUS_MSG,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        
        RTS
        
AN_DEC:
        LEA         SPACE_MSG,  A1
        MOVE.B      #14,        D0
        TRAP        #15
        LEA         MINUS_MSG,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        LEA         OPEN_PAR,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        LEA         A_MSG,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        ;CODE HERE
        JSR         REG
        LEA         CLOSE_PAR,  A1
        MOVE.B      #14,    D0
        TRAP        #15
        
        RTS
        
ABSOLUTE:
        LEA         SPACE_MSG,  A1
        MOVE.B      #14,        D0
        TRAP        #15
        CMP.B       #0,     D5
        BEQ         WORD_TYPE
        CMP.B       #1,     D5
        BEQ         LONG_TYPE
        CMP.B       #4,     D5          ;Compare for immediate data
        BEQ         IM_DATA
        
        RTS
        
*------------------------------------
ZERO:
        LEA         ZERO_MSG,   A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        RTS
ONE:
        LEA         ONE_MSG,    A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        RTS
TWO:
        LEA         TWO_MSG,    A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        RTS
THREE:
        LEA         THREE_MSG,    A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        RTS
FOUR:
        LEA         FOUR_MSG,    A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        RTS
FIVE:
        LEA         FIVE_MSG,    A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        RTS
SIX:
        LEA         SIX_MSG,    A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        RTS
SEVEN:
        LEA         SEVEN_MSG,  A1
        MOVE.B      #14,        D0
        TRAP        #15
        
        RTS
*------------------------------------
* ABSOLUTE EA MODE -> REGISTER TYPE
*------------------------------------
WORD_TYPE:
        LEA         DOLLAR_MSG, A1
        MOVE.B      #14,        D0
        TRAP        #15
*        JSR         GET_VALUE_W
        
        RTS
        
LONG_TYPE:
        LEA         DOLLAR_MSG, A1
        MOVE.B      #14,        D0
        TRAP        #15
*        JSR         GET_VALUE_W
        
        RTS

IM_DATA:
        LEA         HASH_MSG,   A1
        MOVE.B      #14,        D0
        TRAP        #15
*        JSR         GET_DATA
        
        RTS

*------------------------------------
* OPMODE values
* ADDA: has unique OPMODE; unique implementation
*------------------------------------
TYPE_B:
        LEA     BYTE_MSG, A1
        MOVE.B  #14,    D0
        TRAP    #15
        
        RTS
        
TYPE_W:
        LEA     WORD_MSG, A1
        MOVE.B  #14,    D0
        TRAP    #15
        
        RTS
        
TYPE_L:
        LEA     LONG_MSG, A1
        MOVE.B  #14,    D0
        TRAP    #15        
        
        RTS
        
OP_ADDA:
        CMP.B   #%011,      D4
        BEQ     ADDA_W
        CMP.B   #%111,      D4
        BEQ     ADDA_L
        
ADDA_W:
        LEA     ADDA_W_MSG, A1
        MOVE.B  #14,    D0
        TRAP    #15        

        RTS
ADDA_L:
        LEA     ADDA_L_MSG, A1
        MOVE.B  #14,    D0
        TRAP    #15        

        RTS
        



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
