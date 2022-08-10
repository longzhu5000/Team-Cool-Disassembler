*****************************
*
* demo_test.X68
*
* Created 12/05/2018
*
* Test program for CSS 422 Disassembler Project Demo
*
*****************************


start		EQU	$00009000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

		ORG	start

NOP
    LSL.B     D1,D2
    LSL.W     D1,D2
    LSL.W     (A1)
    LSL.W     (A1)+
    LSL.W     -(A1)
    LSL.L     D1,D2
    LSR.B     D1,D2
    LSR.W     D1,D2
    LSR.W     (A1)
    LSR.W     (A1)+
    LSR.W     -(A1)
    LSR.L     D1,D2    
    ASR.B     D1,D2
    ASR.W     D1,D2
    ASR.W     (A1)
    ASR.W     (A1)+
    ASR.W     -(A1)
    ASR.L     D1,D2
    ASL.B     D1,D2
    ASL.W     D1,D2
    ASL.W     (A1)
    ASL.W     (A1)+
    ASL.W     -(A1)
    ASL.L     D1,D2  
    BGT.B     label1
    BGT.B     label2
    BLE.B     label1
    BLE.B     label2
    BGE.B     label1
    BEQ.B     label2
    BEQ.W     label1
label1

label2

label3

    LSL.B     #$1,D2
    LSL.W     #$2,D2
    LSL.L     #$3,D2
    LSL.W     #8, D2
    LSL.W     $12
    LSL.W     $1234
    LSL.W     $12345678
    ASR.B     #$1,D2
    ASR.W     #$2,D2
    ASR.L     #$3,D2
    ASR.L     #8, D2
    ASR.W     $12
    ASR.W     $1234
    ASR.W     $12345678
label4
    BGT.B     label4
    BGT.B     label4
    BGT.B     label4
    BLE.W     label1
    BLE.W     label2
    BLE.W     label3
    BEQ.W     label1
    BEQ.W     label2
    BEQ.W     label3
    LEA     (A0),A0
    LEA     (A5),A0
    LEA     (A7),A0
    LEA     (A0),A7
    LEA     (A5),A7
    LEA     (A7),A7
    ADDA.W        D1,A2
        ADDA.W        (A1),A2
        ADDA.W        (A1)+,A2
        ADDA.W        -(A1),A2
        ADDA.L        D1,A2
        ADDA.L        (A1),A2
        ADDA.L        (A1)+,A2
        ADDA.L        -(A1),A2
        ADDA.W    $12,A2
        ADDA.W    $1234,A2
        ADDA.W    $12345678,A2
        ADDA.W    #$1234,A2
        ADDA.L    $12,A2
        ADDA.L    $1234,A2
        ADDA.L    $12345678,A2
        ADDA.L    #$12345678,A2
        ADDQ.B    #8, D3
        ADDQ.W    #7, A3
        ADDQ.L    #1, (A3)+
        ADDQ.W    #7, (A2)
        ADDQ.L    #2, -(A2)
        ADDQ.L    #8, $12
        ADDQ.L    #8, $1234
        ADDQ.L    #8, $12345678
* Put program code here 

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source




























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
