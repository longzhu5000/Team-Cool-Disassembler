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
        JSR         LSL_LSR_DECODE
LSL_LSR_FAILURE
        *Put the next instruction-for example "JSR BRA_DECODE"
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

INSTRUCTIONS

LSL_LSR_DECODE:
        *Move all the registers in memory to avoid loss of data(pedantic step)
        MOVEM.L D0-D7/A0-A2/A5-A6,  -(A7)
        *Get the (12, 15) bits.
        MOVE.L  #12, D3
        MOVE.L  #15, D4
        JSR     GET_BIT
        *(12, 15) bit should be 1110(14 in decimal)
        CMP.W   #14, D1
        BNE     INSTRUCTION_DECODE_FAILURE    *TODO should be a single line, reload the registers from main memory and RTS
        *Get the (6, 7) bits.
        MOVE.L  #6, D3
        MOVE.L  #7, D4
        JSR     GET_BIT
        *If the (6, 7) bit is "11" then it is memory shift, else it is register shift
        CMP.L   #3, D1
        BEQ     LSL_LSR_MEMORY_SHIFT
        BRA     LSL_LSR_REGISTER_SHIFT
        
 
*A3 points to the currnet opcode, and A4 points to the last address, D2 holds the current opcode. Other registers can be cleared
LSL_LSR_REGISTER_SHIFT
        *Get the (3, 4) bits.
        MOVE.L  #3, D3
        MOVE.L  #4, D4
        JSR     GET_BIT
        *(3, 4) bit should be 01(1 in decimal)
        CMP.L   #1, D1
        BNE     INSTRUCTION_DECODE_FAILURE  *TODO should be a single line, reload the registers from main memory and RTS
        *Get the 8th.
        MOVE.L   #8, D3
        MOVE.L   #8, D4
        JSR GET_BIT
        LEA     LSR_MESSAGE,   A1
        * load the address of LSR_MESSAGE
        *IF the 8th bit is 1, it is a LSL_MESSAGE
        MULU         #4,            D1
        ADDA.L       D1,            A1
        MOVE.L       #14, D0
        TRAP    #15
        *Get the (6, 7) bits. 
        MOVE.L   #6, D3
        MOVE.L   #7, D4
        JSR GET_BIT
         LEA     LSL_LSR_BYTE_MESSAGE,   A1
        * load the address of LSL_LSR_BYTE_MESSAGE
        *(00)->Byte, (01)->Word, (10)->Long
        MULU         #2,            D1
        ADDA.L       D1,            A1
        MOVE.L       #14, D0
        TRAP    #15
        *TODO
        
        
        
        
        
*Gets the (x, y) bit. Note-0th bit is assumed to be the rightmost bit
*For example, "0101011111100101" and (3, 4) equals "00"
*D2 holds the word of which we get the (x, y) bits of
*D3 holds the x, D4 holds the y
*Result returned in D1
GET_BIT
        CLR.L   D1
        MOVE.W  D2, D1   
        *Shift it to left by 15-y to get rid of all the bits to the left of yth bit 
        *and then shift the bits such that the xth bit is the 0th bit
        NEG.L   D4
        ADDI.L  #15, D4
        LSL.W   D4, D1 
        LSR.W   D3, D1
        RTS

        
        
        

LSL_LSR_MEMORY_SHIFT

            

PRINT_
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

LSR_MESSAGE      DC.B        'LSR',0
LSL_MESSAGE      DC.B        'LSL',0
LSL_LSR_BYTE_MESSAGE DC.B    '.B',0
LSL_LSR_WORD_MESSAGE DC.B    '.W',0
LSL_LSR_LONG_MESSAGE DC.B    '.L',0

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




