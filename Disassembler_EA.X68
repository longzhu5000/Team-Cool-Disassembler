*-----------------------------------------------------------
* Title      : EA 
* Written by :
* Date       :
* Description: Compare OPMODE for bit 6-8 of ADD, ADDA, SUB, AND, OR
*-----------------------------------------------------------


*----------------------------------------------
* OPMODE_DN = <ea> [+,-,(and),(or)]  Dn  ->  Dn
* OPMODE_EA =  Dn  [+,-,(and),(or)] <ea> -> <ea>
* OPMODE_AN = Address Register

* D3 to store original data
* D4 to copy and modify D3 data
* D2 and D5 stores unique values for isolation
*----------------------------------------------
CHECK_OPMODE:
        JSR     EA_ISOLATE_8_6
        
        RTS
        
EA_ISOLATE_8_6:
        MOVE.L      D3,     D4
        MOVE.L      #6,     D2
        MOVE.L      #29,    D5
        LSR.L       D2,     D3
        LSL.L       D5,     D3
        LSR.L       D5,     D3
        
        ;Compares OPMODE for ADDA first; unique values
        CMP.B       #%011,    D3      ;compares bit 011 for ADDA.W
        BEQ         ADDA_W
        CMP.B       #%111,    D3      ;compares bit 111 for ADDA.L
        BEQ         ADDA_L
        
        
        CMPI.B      #%010,    D3      ;compare to 2
        BCS         OPMODE_DN       ;branch to DN if less than or equal to 2
        BHI         OPMODE_EA       ;branch to EA if greater than 2
        
*---------------------------------------
OPMODE_DN:
        CMP.B   #%000,    D3
        BEQ     TYPE_B
        CMP.B   #%001,    D3
        BEQ     TYPE_W
        CMP.B   #%010,    D3
        BEQ     TYPE_L

    
        ;JSR     ADD_DN
        ;JSR     SUB_DN
        ;JSR     AND_DN
        ;JSR     OR_DN

        RTS
        
OPMODE_EA:
        CMP.B   #%100,    D3
        BEQ     TYPE_B
        CMP.B   #%101,    D3
        BEQ     TYPE_W
        CMP.B   #%110,    D3
        BEQ     TYPE_L
    
        ;JSR     ADD_EA
        ;JSR     SUB_EA
        ;JSR     AND_EA
        ;JSR     OR_EA

        RTS

*---------------------------------------
*ADD_DN:
*        LEA     ADD_DN_MSG, A1
*        MOVE.B  #14,    D0
*        TRAP    #15
*        
*SUB_DN:
*        LEA     SUB_DN_MSG, A1
*        MOVE.B  #14,    D0
*        TRAP    #15
*        
*AND_DN:
*        LEA     AND_DN_MSG, A1
*        MOVE.B  #14,    D0
*        TRAP    #15
*        
*OR_DN:
*        LEA     OR_DN_MSG, A1
*        MOVE.B  #14,    D0
*        TRAP    #15
*        
*ADD_EA:
*        LEA     ADD_EA_MSG, A1
*        MOVE.B  #14,    D0
*        TRAP    #15
*                
*SUB_EA:
*        LEA     SUB_EA_MSG, A1
*        MOVE.B  #14,    D0
*        TRAP    #15
*        
*AND_EA:
*        LEA     AND_EA_MSG, A1
*        MOVE.B  #14,    D0
*        TRAP    #15
*        
*OR_EA:
*        LEA     OR_EA_MSG, A1
*        MOVE.B  #14,    D0
*        TRAP    #15
        
TYPE_B:
        LEA     TYPE_B_MSG, A1
        MOVE.B  #14,    D0
        TRAP    #15
        
        RTS
TYPE_W:
        LEA     TYPE_W_MSG, A1
        MOVE.B  #14,    D0
        TRAP    #15
        
        RTS
TYPE_L:
        LEA     TYPE_L_MSG, A1
        MOVE.B  #14,    D0
        TRAP    #15        

        RTS
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
*------------------------------------
ADD_DN_MSG:     DC.B        '<ea> + Dn -> Dn',0
SUB_DN_MSG:     DC.B        'Dn - <ea> -> Dn',0
AND_DN_MSG:     DC.B        '<ea> [and] Dn -> Dn',0
OR_DN_MSG:      DC.B        '<ea> [or] Dn -> Dn',0

ADD_EA_MSG:     DC.B        'Dn + <ea> -> <ea>',0
SUB_EA_MSG:     DC.B        '<ea> - Dn -> <ea>',0
AND_EA_MSG:     DC.B        'Dn [and] <ea> -> <ea>',0
OR_EA_MSG:      DC.B        'Dn [or] <ea> -> <ea>',0

TYPE_B_MSG:     DC.B        '.B',0
TYPE_W_MSG:     DC.B        '.W',0
TYPE_L_MSG:     DC.B        '.L',0

ADDA_W_MSG:     DC.B        '.W',0
ADDA_L_MSG:     DC.B        '.L',0


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
