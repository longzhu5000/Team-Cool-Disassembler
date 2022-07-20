*-----------------------------------------------------------
* Title      :Basic Dissassembler
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
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
        MOVE.L      (A3),          D3
        
        *START OF OPCODE RECOGNITION
        
        JSR         OPCODE_DETECT
        
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
        * Bit shifting to isolate the right most digit
        * 1234 5678 => 8000 0000 => 0000 0008
        MOVE.B      #28,            D0    
        LSL.L       D0,             D2     
        ROL.L       #4,             D2 
        
        * Bit shifting to prep the next digit
        * 1234 4567 => 0123 4567
        ASR.L       #4, D3
        
        *Assuming D4 is empty
        
        MOVE.B       D2,            D4
        LEA          ZERO_MSG,      A1
        * load the address of Zero_msg
        * because all of the msgs are stored next to each other in order
        * we can simply take the value isolated from the number, multiply it by 2 (msg's take up 2 bytes)
        * and then add it to the address starting at zero_msg
        MULU         #2,            D4
        ADDA.L       D4,            A1
        
        * trap command 14 reads whatever address is in A1, and then spits out the data to the console
        MOVE.B       #14,           D0
        TRAP         #15
        BRA          PRINT_LOOP
        
PRINT_DONE:
        RTS
        
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
        
        *   opcode detection
*-----------------------------------------
OPCODE_DETECT:
        *START WITH A LONG IN (A3)
        *MAKE COPY IN D7
        *MAKE COPY OF D7 (MOVE.W) IN D6 TO STORE FIRST WORD
        *SHIFT BY 16 RIGHT
        *MAKE COPY OF D7 (MOVE.W) IN D5 TO STORE SECOND WORD
        *FOR EACH WORD
            *SHIFT RIGHT 6 BITS (TO ISOLATE STATIC BITS)
            *IF D3 == $13A JSR DETECTED, PRINT JSR MSG, THEN RTS (PREPARE FOR ADDRESSING MODE)
        *RTS (OR GO TO HIGHER OPCODE DETECTER FOR MORE THAN JSR)
        *BEFORE RTS, CLEAR D7, D6, D5
        MOVE.L      (A3)+,           D7
        MOVE.W      D7,             D6
        
        *move 16 to register instead
        LSR.L       #8,             D7
        LSR.L       #8,             D7
        
        MOVE.W      D7,             D5
        
        *first word (D6)
        *add more cmp for more opcodes in order that makes more sense (move is last because it has 2 static bits)
        
        LSR.W       #6,              D6
        CMP.W       #$13A,          D6
        BEQ         JSR_DETECTED
        
        *second word (D5)
       
        LSR.W       #6,              D5
        CMP.W       #$13A,          D5
        BEQ         JSR_DETECTED
        
        CLR.L       D5
        CLR.L       D6
        CLR.L       D7
        
        RTS
        
JSR_DETECTED:
        LEA         JSRMSG,         A1
        MOVE.B      #14,            D0
        TRAP        #15
        
        *implement opcode detection here (create copies of previous words by using D7)
        *increment A3 as needed when scanning through more words
        
        CLR.L       D5
        CLR.L       D6
        CLR.L       D7
        
        RTS
        
        

DONE:

        LEA         GOODBYE_MSG,    A1
        MOVE.B      #14,            D0
        TRAP        #15
        MOVE.B      #9,             D0
        TRAP        #15        
        

    *SIMHALT             ; halt simulator

* Put variables and constants here

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

* opcodes
JSRMSG:             DC.B        'JSR ',0


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
