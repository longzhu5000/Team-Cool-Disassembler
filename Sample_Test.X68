*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

                  ; first instruction of program

TEST
    RTS
    NOP
    
    MOVE.B      D1,     D2
    MOVEA.W     A1,     A2
    MOVEM.W     A1-A7,  -(A1)
    MOVEQ       #$0,    D0
    LEA         (A1),   A2
    
    AND.B       D1,     D2
    OR.B        D1,     D2

    ADD.B       D1,     D2
    ADDA.W      D1,     A2
    ADDQ.W      #$1,    A2
    SUB.B       D1,     D2
    
    JSR         TEST
    BGT.B       TEST
    BLE.W       TEST
    BEQ.W       TEST
    BRA         TEST
    NOT         TEST
    
    LSL.B       D1,     D2
    LSR.B       D1,     D2
    ASL.B       D1,     D2
    ASR.B       D1,     D2
    ROL.B       D1,     D2
    ROR.B       D1,     D2


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
