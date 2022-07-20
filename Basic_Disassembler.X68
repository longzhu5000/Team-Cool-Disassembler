*-----------------------------------------------------------
* Title      :Basic Dissassembler
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
shift4      EQU     4
shift8      EQU     8
shift12     EQU     12
shift16     EQU     16

    ORG    $1000
START:                  ; first instruction of program

* Put program code here

*------LEA = Load effective address
*------Running Trap #15 while the number 14 is in D0 will print out whatever data is in the address stored in A1

        LEA         INTRO_MSG,      A1
        MOVE.B      #14,            D0    
        TRAP        #15
        
        LEA         STARTING_MSG,   A1
        MOVE.B      #14,            D0   
        TRAP        #15
        
*----------------- 
*       Running trap command 15 while the number 2 is in D0 
*       Will ask the user to enter input
*       after the user hits enter, the length of the input is stored in D1
*       and the user data is stored in the space allocated by STA_ADDR repressented by ASSCI code
*       IE 31 = 1, 32 = 2 etc etc
*       If I store the number 1200, it will appear in memory as 31 32 30 30

        LEA         STA_ADDR,       A1
        MOVE.B      #2,             D0
        TRAP        #15
        
        JSR         CONVERT_TO_ASCII
        
        * A3 now has our Starting Address
        MOVEA.L     D7,             A3
        
        CLR.L       D2
        CLR.L       D7
        
        LEA         ENDING_MSG,     A1
        MOVE.B      #14,            D0
        TRAP        #15
        
        LEA         END_ADDR,       A1
        MOVE.B      #2,             D0
        TRAP        #15
        
        JSR         CONVERT_TO_ASCII
        * A4 now has our Ending Address
        MOVEA.L     D7,             A4
        

        JSR         PRINT_MEMORY_LOOP
        
        
        
        *BRA         DONE
        *   ASCII conversion
*---------------------------------------        
CONVERT_TO_ASCII:             
        CMPI.B      #$0,            D1
        BEQ         ASCII_DONE
        MOVE.B      (A1)+,          D2
        MOVE.B      #$39,           D0
        CMP.B       D0,             D2
        BLE         NUMBER_ASCII   
        BRA         LETTER_ASCII  

ASCII_DONE:
        RTS
        
NUMBER_ASCII:
        SUBI.B      #$1,            D1
        MOVE.B      #$30,           D0
        SUB.B       D0,             D2
        ADD.B       D2,             D7
        CMPI.B      #$0,            D1
        BEQ         ASCII_DONE
        ASL.L       #4,             D7
        BRA         CONVERT_TO_ASCII
LETTER_ASCII:
        SUBI.B      #$1,            D1
        MOVE.B      #$37,           D0
        SUB.B       D0,             D2
        ADD.B       D2,             D7
        CMPI.B      #$0,            D1
        BEQ         ASCII_DONE
        ASL.L       #4,             D7
        BRA         CONVERT_TO_ASCII
*---------------------------------------        
        
        
        *   Printing data and addresses
*---------------------------------------

PRINT_MEMORY_LOOP:
        * add code here to compare current address with end address
        
        * if equal to, or further than ending address jump to DONE
        * SIMHALT
        CMP.L       A3,             A4
        BEQ         DONE
        BLE         DONE
        
        * We are goiong to keep track of the number of byts we have examined using D1
        * Before printing the address we have to reverse the order
        CLR.L       D1
        CLR.L       D2
        MOVE.B      #$8,            D1
        MOVE.L      A3,             D3
        JSR         REVERSE_START
        
        MOVE.L      D7,             D3
        CLR.L       D1
        CLR.L       D2
        MOVE.B      #$8,            D1
        JSR         PRINT_LOOP
        
        
        * space between address and data
        LEA         SPACE_MSG,      A1
        MOVE.B      #14,            D0    
        TRAP        #15
        
        CLR.L       D1
        CLR.L       D2
        MOVE.B      #$8,            D1
        MOVE.L      (A3)+,          D3
        JSR         REVERSE_START
        
        MOVE.L      D7,             D3
        CLR.L       D1
        CLR.L       D2
        MOVE.B      #$8,            D1
        JSR         PRINT_LOOP
        
        * new line
        LEA         NEW_LINE,       A1
        MOVE.B      #14,            D0    
        TRAP        #15
*        SIMHALT
*        RTS
        * branch to the start of this method
        BRA         PRINT_MEMORY_LOOP


PRINT_LOOP:

        
        * When D1 == 0, we are done and exit this loop
        CMPI.B      #$0,            D1
        BEQ         PRINT_DONE
        SUBI.B      #$1,            D1
        
        MOVE.B      D3,             D2
        MOVE.B      #28,            D0    
        LSL.L       D0,             D2     
        ROL.L       #4,             D2 
        
        
        ASR.L       #4, D3
        
        
        CMP.B       #0,             D2
        BEQ         PRINT_0
        CMP.B       #1,             D2
        BEQ         PRINT_1
        CMP.B       #2,             D2
        BEQ         PRINT_2
        CMP.B       #3,             D2
        BEQ         PRINT_3
        CMP.B       #4,             D2
        BEQ         PRINT_4
        CMP.B       #5,             D2
        BEQ         PRINT_5
        CMP.B       #6,             D2
        BEQ         PRINT_6
        CMP.B       #7,             D2
        BEQ         PRINT_7
        CMP.B       #8,             D2
        BEQ         PRINT_8
        CMP.B       #9,             D2
        BEQ         PRINT_9
        CMP.B       #$A,            D2
        BEQ         PRINT_A
        CMP.B       #$B,            D2
        BEQ         PRINT_B
        CMP.B       #$C,            D2
        BEQ         PRINT_C
        CMP.B       #$D,            D2
        BEQ         PRINT_D
        CMP.B       #$E,            D2
        BEQ         PRINT_E
        CMP.B       #$F,            D2
        BEQ         PRINT_F

        * This should never be called
        BRA         PRINT_LOOP
        
PRINT_DONE:
        RTS
        
PRINT_0:
        LEA         ZERO_MSG,       A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_1:
        LEA         ONE_MSG,        A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_2:
        LEA         TWO_MSG,        A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_3:
        LEA         THREE_MSG,      A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_4:
        LEA         FOUR_MSG,       A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_5:
        LEA         FIVE_MSG,       A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_6:
        LEA         SIX_MSG,        A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_7:
        LEA         SEVEN_MSG,      A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_8:
        LEA         EIGHT_MSG,      A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_9:
        LEA         NINE_MSG,       A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_A:
        LEA         A_MSG,          A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_B:
        LEA         B_MSG,          A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_C:
        LEA         C_MSG,          A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_D:
        LEA         D_MSG,          A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_E:
        LEA         E_MSG,          A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP
PRINT_F:
        LEA         F_MSG,          A1
        MOVE.B      #14,            D0    
        TRAP        #15
        BRA         PRINT_LOOP

    *   Reversing the address
*---------------------------------------

REVERSE_START:        
        CLR.L       D1
        CLR.L       D7
        MOVE.B      #8,             D1
        JSR         REVERSE_LOOP
        RTS
        
REVERSE_LOOP:

        
        CMPI.B      #$0,            D1
        BEQ         REVERSE_DONE
        SUBI.B      #$1,            D1
        ASL.L       #4,             D7
        
        CLR.L       D5
        
        MOVE.B      D3,             D5
        
        MOVE.B      #28,            D0    
        LSL.L       D0,             D5     
        ROL.L       #4,             D5
        
        ADD.B       D5,             D7
        
        
        ASR.L       #4,             D3
        
        BRA         REVERSE_LOOP

REVERSE_DONE:
        RTS
DONE:

        LEA         GOODBYE_MSG,    A1
        MOVE.B      #14,            D0
        TRAP        #15
        MOVE.B      #9,             D0
        TRAP        #15        
        

    *SIMHALT             ; halt simulator

* Put variables and constants here

****************************************************** 
* ADD : 1101
* ADDA: 1101
* ADDQ: 0101
****************************************************** 
HEX_1101        MOVE.B      #'A',   (A2)+
                MOVE.B      #'D',   (A2)+
                MOVE.B      #'D',   (A2)+
                MOVE.W      D7,     D6
                LSR.W       #6,     D6          ;shifts right 6
                ANDI.W      #$0003, D6          
                CMP.B       #%11,   D6          ;determine if ADD or ADDA
                BNE         OP_ADDQ             ;if 11, go to OP_ADDQ
                MOVE.B      #'A',   (A2)+       ;if yes size 11, go to OP_ADDA
                MOVE.B      #'.',   (A2)+
                MOVE.W      D7,     D6
                LSR.L       #$8,    D6          ;shifts 8 and isolate first bit
                ANDI.W      #$0001, D6          
                CMP.B       #%1,    D6          ;compare for 1
                BEQ         ADDA_L              ;jump to long, else word
                MOVE.B      #'W',   (A2)+
                JMP         OP_ADDA
ADDA_L          MOVE.B      #'L',   (A2)+

OP_ADDQ         

OP_ADD          


OP_ADDA

****************************************************** 
* First four bits = 1001
* SUB
******************************************************
hex_1001        MOVE.B      #'S',   (A2)+
                MOVE.B      #'U',   (A2)+
                MOVE.B      #'B',   (A2)+
                MOVE.W      D7,     D6
                LSR.W       #6,     D6
                ANDI.W      #$0003, D6
                CMP.B       #%01,   D6
                BEQ         OP_SUB
                RTS

OP_SUB                   


INTRO_MSG:       DC.B       'Welcome to Team Cools Disassembler!',CR,LF,0
STARTING_MSG:    DC.B       'Please enter the Starting Address',CR,LF,0
ENDING_MSG:      DC.B       'Please enter the Ending Address',CR,LF,0
GOODBYE_MSG:     DC.B       'Done Reading data',CR,LF,0
* CR and LF for strings above because we want to go to next line after printing message

STA_ADDR         DS.B        40
END_ADDR         DS.B        40

* no CR and LF for strings below because we want to print each number and letter

SPACE_MSG:       DC.B        '  ',0

ZERO_MSG:        DC.B        '0',0
ONE_MSG:         DC.B        '1',0
TWO_MSG:         DC.B        '2',0
THREE_MSG:       DC.B        '3',0
FOUR_MSG:        DC.B        '4',0
FIVE_MSG:        DC.B        '5',0
SIX_MSG:         DC.B        '6',0
SEVEN_MSG:       DC.B        '7',0
EIGHT_MSG:       DC.B        '8',0
NINE_MSG:        DC.B        '9',0
A_MSG:           DC.B        'A',0
B_MSG:           DC.B        'B',0
C_MSG:           DC.B        'C',0
D_MSG:           DC.B        'D',0
E_MSG:           DC.B        'E',0
F_MSG:           DC.B        'F',0 


*-----Carriage Return
CR              EQU          $0D
*-----------Line Feed
LF              EQU          $0A

NEW_LINE:       DC.B         '',CR,LF,0

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
