
.MODEL SMALL 
STSEG SEGMENT STACK 'STACK'
    
    DW 100 DUP (?)
   
STSEG ENDS

DTSEG SEGMENT 
    
                  
    INPUT_FILENAME DB "INPUT.TXT"  , 0
    OUTPUT_FILENAME DB "OUTPUT.TXT" , 0   
    
    INPUT_HANDLE DW ?
    OUTPUT_HANDLE DW ?
     
    INPUT_CHARACTER DB ?   
    ;******************************
    D DW ?
    
    
    VARIABLE1 DW ?
    VARIABLE2 DW ? 
    V1 DW ? 
    V2 DW ?   
    
    TEMP1 DW ?
    TEMP2 DW ?
    
    POWER1 DW ?
    POWER2 DW ?
    
    FRACTION1 DW ?
    FRACTION2 DW ?  
    
    FINAL_POWER DW ?
    FINAL_FRACTION DW ?
    
    COMPARE_RESULT DW ? 
    
    RESULT DW ?
    RESULT_DIVIDE DW ?
                     
    N0 DW ?                     
    N1 DW ?
    N2 DW ?
    N3 DW ?
    N4 DW ?
    N5 DW ?
    N6 DW ?
    N7 DW ?
    N8 DW ?
    N9 DW ? 
    
    
    FLOAT1 DW 0000000000000000B
    FLOAT2 DW 0000010000000000B
    FLOAT3 DW 0000011000000000B
    FLOAT4 DW 0000100000000000B
    FLOAT5 DW 0000100100000000B
    FLOAT6 DW 0000101000000000B
    FLOAT7 DW 0000101100000000B
    FLOAT8 DW 0000110000000000B
    FLOAT9 DW 0000110010000000B
   FLOAT10 DW 0000110100000000B
        
    
    TEN DW 10   
    
    DECI DW ?
    ONE DW ?
    
    
    FIVE DW 5
    TEST1 DW 325

    FIRST_NUMBER DW ?  
    POWER DW ?
        
    
    BUFF DB 100 DUP ('$')
    NUMSTR DB "000$"   
    
    DTSEG ENDS

CDSEG SEGMENT 
    ASSUME CS:CDSEG , DS:DTSEG SS:STSEG
    
START:     

    MOV AX , DTSEG 
    MOV DS , AX
    
    MOV AX , STSEG
    MOV SS, AX      
    
  
 
    ;SETTING N_I TO 0 ;  N_I ARE FOR COUNTING NUMBERS WITH LEFT MOST DIGIT I
    LEA DI , N0
    MOV BX , 0 
    MOV [DI]  , BX

    LEA DI , N1
    MOV BX , 0 
    MOV [DI]  , BX

    LEA DI , N2
    MOV BX , 0 
    MOV [DI]  , BX

    LEA DI , N3
    MOV BX , 0 
    MOV [DI]  , BX

    LEA DI , N4
    MOV BX , 0 
    MOV [DI]  , BX

    LEA DI , N5
    MOV BX , 0 
    MOV [DI]  , BX

    LEA DI , N6
    MOV BX , 0 
    MOV [DI]  , BX

    LEA DI , N7
    MOV BX , 0 
    MOV [DI]  , BX

    LEA DI , N8
    MOV BX , 0 
    MOV [DI]  , BX

    LEA DI , N9
    MOV BX , 0 
    MOV [DI]  , BX

    ;SETING DECI TO 0.1
    SUB AX ,AX ; AX=0
    OR AX , 0111001001100110B
    MOV DECI , AX      
    ;SETTING ONE TO 1
    SUB AX , AX ;AX=0
    OR AX , 0000000000000000
    MOV ONE , AX
    
    ;GETTING NUMBER D FROM CONSOLE
    MOV AH  , 01H
    INT 21H             
    SUB AL , '0'
    MOV AH , 0
    MOV D , AX
    
    
    
    
    ;OPEN FILE 
    LEA DX,INPUT_FILENAME
    MOV AL,0
    MOV AH,3DH
    INT 21H                       
    MOV INPUT_HANDLE , AX

   
    MOV CX , 1000 ; COUNTER FOR LOOP                                        
    
LOOP_READ_FILE:
    PUSH CX
        
    CALL READ_CHAR
    CMP AX , 13
    JZ NEXT_LINE
    
    ;COMPLETING THE FIRST_NUMBER
    MOV AL , INPUT_CHARACTER
    SUB AX , '0'
    LEA BX , FIRST_NUMBER
    MOV DX , [BX]
    MOV BX , AX
    MOV AX  , DX
    MUL TEN
    ADD AX , BX
    LEA DI , FIRST_NUMBER
    MOV [DI] , AX         ; FISRST NUMBER CONTAINS first number inputed
    JMP LOOP_READ_FILE       
        
    NEXT_LINE:
    CALL READ_CHAR ;read \n    
    
    CALL READ_CHAR
    SUB AX ,'0'
    LEA DI , POWER
    MOV [DI] , AX   ;POWER CONTAINS power of 10
    CALL READ_CHAR  ;read \d
    CALL READ_CHAR  ;read \n
  
    LEA DI , FIRST_NUMBER                  
    CALL SET_FLOATING_POINT_FORMAT
    
    ; NOW FIRST NUMBER IS FLOATING POINT
    CALL POWER_OF_DECI
    
    MOV VARIABLE1 , AX ; CONTAINS 10 ^ -?
    MOV AX , FIRST_NUMBER
    MOV VARIABLE2 , AX ; CONTAIN THE NUMBER
    
    CALL FLOAT_MUL ; AFTER THIS AX AND RESULT CONTAIN THE REAL FLOATING POINT READ FROM FILE
    
    MOV RESULT_DIVIDE  , AX
    LOOP_DIVIDE_BY_10:
        MOV V1 , AX
        MOV BX , FLOAT10
        MOV V2 , BX
        CALL IS_V1_GREATER_THAN_V2 ;V1 IS OUR NUMBER AND V2 IS FLOAT 10
        CMP COMPARE_RESULT , -1
        JE END_LOOP_DIVIDE_BY_10    
        
        MOV AX , RESULT
        MOV VARIABLE1 , AX
        MOV AX , DECI
        MOV VARIABLE2 , AX
        
        CALL FLOAT_MUL ;AFTER THIS RESULT IS IN AX
        MOV RESULT_DIVIDE, AX
        
        JMP LOOP_DIVIDE_BY_10
    
    END_LOOP_DIVIDE_BY_10:
    
        MOV AX , RESULT_DIVIDE ;NOW AX IS LESS THAN 10
        MOV V1 , AX
        CALL INC_Ti
       
    
    POP CX
    LOOP LOOP_READ_FILE


    ;CLOSING THE INPUT
    MOV AH,3EH
    MOV BX,INPUT_HANDLE             
    INT 21H
    
    ;NOW WE CALCULATE THE PERCENT
    CALL CALCULATE_PERCENT
    ;AX CONTAINS OUR FINAL RESULT
     
    
    ;CREATE OUTPUT FILE
    LEA DX,OUTPUT_FILENAME
    MOV CX,0
    MOV AH,3CH
    INT 21H                         
    MOV OUTPUT_HANDLE,AX
    ;START WRITING ON FILE    
    PUSH AX
    MOV BX , 10
    DIV BX
    PUSH AX
    PUSH DX
    MOV INPUT_CHARACTER , AL
    CALL PRINT
    MOV INPUT_CHARACTER , DL
    CALL PRINT
    ;CLOSE THE OUT PUT FILE
    MOV AH,3EH
    MOV BX,OUTPUT_HANDLE
    INT 21H  
    POP DX 
    POP AX
    ;NOW PRINTING ON THE CONSOLE
    ADD AX , '0'
    ADD DX , '0'
    
    PUSH DX    
    
    MOV DX , AX
    MOV AH , 9
    INT 21H
    
    POP DX
    
    MOV AH,  9
    INT 21H
    
    ;TERMIANTE THE PROGRAM   
    MOV AH , 4CH
    MOV AL ,0 
    INT 21H 
    

FINISH:


READ_CHAR:
    LEA DX,INPUT_CHARACTER
    MOV BX,INPUT_HANDLE
    MOV CX,1
    MOV AH,3FH
    INT 21H                         ;READ A CHARACTER FROM FILE
    CMP AX,0
    JZ FINISH
    MOV AL , INPUT_CHARACTER                              ;CHECKING THE FIEL IS FINISHED
    
    RET


SET_POWER_BITS :
    LEA DI , POWER
    MOV BX , 0
    MOV BX , [DI]
    SAL BX , 10 ;SET RIGHT 10 BIT TO ZERO
    MOV [DI] , BX 
     
    RET
    
SET_FLOATING_POINT_FORMAT:
    PUSH DI
    SUB BX , BX           ;SET BX = 0000H
    SUB AX , AX           ;SET AX = 0000H  
    MOV BX , [DI]                       
    MOV DI , 0 ;COUNTER FOR FINDING SHIFT AMOUNT
    FIND_FIRST_1_LOOP:
        MOV AX , BX
        AND AX , 0400H    
        CMP AX , 0400H               ;CHECK FOR WHETHER 11 TH BIT IS 1 RO NOT
        JE END_FIND_FIRST_1_LOOP
        SAL BX , 1                          ;SHIFT LEFT
        INC DI                              ;SHIFT AMOUNT ++
        JMP FIND_FIRST_1_LOOP
        
    END_FIND_FIRST_1_LOOP:
    MOV AX , 10
    SUB AX , DI ; NOW AX CONTAINS SHIFT AMOUNT
    SAL AX , 10 ; NOW FIRST 10 BIT OF AX  IS ZERO 
  
    
    AND BX , 1111101111111111B ; SET THE 11 TH BIT TO 0 ; JUST FOR SAVE ING THE FIRST 10 BIT
    ADD BX , AX ; NOW BX IS HALF PRECISION FLOATING POINT FORMAT ; NOTE THAT SIGN BIT IS 0
    POP DI
    MOV [DI] , BX  ;MOV BX TO FIRST NUMBER
 
    RET
    

FLOAT_MUL:
    MOV AX , VARIABLE1    
    PUSH AX
    
    CALL GET_FRACTION 
    MOV FRACTION1 , AX
    
    POP AX
    
    CALL GET_POWER
    MOV POWER1 , AX
    
    MOV AX , VARIABLE2
    PUSH AX
    CALL GET_FRACTION
    MOV FRACTION2 , AX
    
    POP AX
    
    CALL GET_POWER
    MOV POWER2 , AX
    ;
    MOV AX , POWER1
    MOV BX , POWER2
    ADD AX , BX
    
    MOV FINAL_POWER , AX
    
    MOV AX , FRACTION1
    MOV BX , FRACTION2 
    
    MUL BX
    PUSH AX
    PUSH DX
    
    CALL CHECK_FOR_OVERFLOW
    
    POP DX
    POP AX 
    SUB SI , SI  ;SHIFT AMOUNT COUNTER
    
    SHIFT_DX_LOOP: ; SHIFT DX FOR ? BIT TO LEFT
        MOV CX , DX
        AND CX , 8000H
        CMP CX , 8000H
        JE END_SHIFT_DX_LOOP
        SAL DX , 1
        INC SI
        JMP SHIFT_DX_LOOP              
                      
    END_SHIFT_DX_LOOP:
    SUB CX , CX ; CX = 0
    MOV CL , 16
    SUB CX , SI
    ;SHIFT AX FOR 16 -? BIT TO RIGHT
    SHR AX , CL
    
    ADD AX , DX ;NOW AX CONTAINS FRACTION PART
    MOV FINAL_FRACTION , AX  
    ;
    SUB BX , BX
    MOV BX , FINAL_POWER 
    AND BX , 0000000000011111B ; FOR PREVENTING FROM SETTING SIGN BIT TO 1 !!!
    SAL BX , 10          
    AND AX , 7FFFH ; SET THE MSB BIT TO 0
    SHR AX , 5
    ADD AX , BX ; NOW AX CONTAINS FLOATING POINT FOEMAT OF MUL OF VARIABLE 1 AND 2
    MOV RESULT ,  AX
    
    RET
    
    
    
    

GET_POWER: ;VARIABLE AND RESULT IS IN AX 
    
    SHR AX , 10
    AND AX , 0000000000011111B
    
    RET

GET_FRACTION: ;VARIABLE AND RESULT IS IN AX
    
    AND AX , 0000001111111111B ;GET FRACTION PART 
    OR AX ,  0000010000000000B ;  1.??????
    
    RET
    
       
POWER_OF_DECI:  
    MOV CX , POWER
    SUB AX , AX ; AX= 0 
    SUB BX , BX ; BX = 0   
    
    MOV AX , ONE  ;AX CONTAINS ONE FLOAT 
    MOV BX , DECI ;BX CONTAINS DECI FLOAT
    MOV VARIABLE1 , AX
    MOV VARIABLE2 , BX
 
    CMP CX , 0 
    JE END_POWER_OF_DECI
    LOOP_POWER_OF_DECI:          
                   PUSH CX     
                   CALL FLOAT_MUL
                   MOV VARIABLE1  , AX
                   POP CX
                   LOOP LOOP_POWER_OF_DECI
                   
    END_POWER_OF_DECI:
    ; NOW AX CONTAINS 10 ^ -? FLOAT
    RET               

        
IS_V1_GREATER_THAN_V2:
    MOV AX , V1 
    CALL GET_POWER
    SAL AX , 11  ; BEACAUSE WHEN WE WANT TO COMPARE WE NEED SIGN OF POWER 
    MOV TEMP1 , AX
    MOV AX , V2
    CALL GET_POWER
    SAL AX , 11  ; BEACAUSE WHEN WE WANT TO COMPARE WE NEED SIGN OF POWER
    MOV BX , TEMP1
    ;AX IS FOR V2  , AND BX IS FOR V1
    CMP BX , AX
    JG YES
    JL NO
    
    MOV AX , V1
    CALL GET_FRACTION
    MOV TEMP1 , AX
    MOV AX ,V2
    CALL GET_FRACTION
    MOV BX , TEMP1
    ; AX IS FOR V2 , AND BX IS FOR V1 
    CMP BX , AX
    JG YES
    JL NO
    
    YES: 
        MOV COMPARE_RESULT  , 1
        RET
    NO:    
        MOV COMPARE_RESULT , -1
        RET 
        
        
INC_Ti:
    ;V1 CONTAINS OUR NUMBER
    MOV AX , FLOAT1
    MOV V2 , AX
    CALL IS_V1_GREATER_THAN_V2
    CMP COMPARE_RESULT , -1
    JE INC0
    
    MOV AX , FLOAT2
    MOV V2 , AX
    CALL IS_V1_GREATER_THAN_V2
    CMP COMPARE_RESULT , -1
    JE INC1
    
    MOV AX , FLOAT3
    MOV V2 , AX
    CALL IS_V1_GREATER_THAN_V2
    CMP COMPARE_RESULT , -1
    JE INC2
    
    MOV AX , FLOAT4
    MOV V2 , AX
    CALL IS_V1_GREATER_THAN_V2
    CMP COMPARE_RESULT , -1
    JE INC3
    
    MOV AX , FLOAT5
    MOV V2 , AX
    CALL IS_V1_GREATER_THAN_V2
    CMP COMPARE_RESULT , -1
    JE INC4
    
    MOV AX , FLOAT6
    MOV V2 , AX
    CALL IS_V1_GREATER_THAN_V2
    CMP COMPARE_RESULT , -1
    JE INC5
    
    MOV AX , FLOAT7
    MOV V2 , AX
    CALL IS_V1_GREATER_THAN_V2
    CMP COMPARE_RESULT , -1
    JE INC6
    
    MOV AX , FLOAT8
    MOV V2 , AX
    CALL IS_V1_GREATER_THAN_V2
    CMP COMPARE_RESULT , -1
    JE INC7
    
    MOV AX , FLOAT9
    MOV V2 , AX
    CALL IS_V1_GREATER_THAN_V2
    CMP COMPARE_RESULT , -1
    JE INC8
    
    MOV AX , FLOAT10
    MOV V2 , AX
    CALL IS_V1_GREATER_THAN_V2
    CMP COMPARE_RESULT , -1
    JE INC9
    
    
    INC0:
        INC N0
        RET
    INC1:
        INC N1
        RET
    INC2:
        INC N1
        RET
    INC3:
        INC N3
        RET
    INC4:
        INC N4
        RET
    INC5:
        INC N5
        RET
    INC6:
        INC N6
        RET
    INC7:
        INC N7
        RET
    INC8:
        INC N8
        RET            
    INC9:
        INC N9
        RET
             
             
CHECK_FOR_OVERFLOW:
      
      AND DX , 0000000000100000B  ; CHECK FOR BIT 22
      CMP DX , 0000000000100000B
      JE OVERFLOW
      JNE NOT_OVERFLOW
      
      OVERFLOW:
        INC FINAL_POWER      
        RET
      
      NOT_OVERFLOW:
        RET
      
GET_Ti:
     MOV AX , D
     
     CMP AX  , 0
     JE GET0
     
     CMP AX  , 1
     JE GET1
    
     CMP AX  , 2
     JE GET2
     
     CMP AX  , 3
     JE GET3
     
     CMP AX  , 4
     JE GET4
     
     CMP AX  , 5
     JE GET5
     
     CMP AX  , 6
     JE GET6
     
     CMP AX  , 7
     JE GET7
     
     CMP AX  , 8
     JE GET8
     
     CMP AX  , 9
     JE GET9

        
     GET0:
        MOV AX , N0
        RET
     
     GET1:
        MOV AX , N1
        RET
        
     GET2:
        MOV AX , N2
        RET
        
     GET3:
        MOV AX , N3
        RET
        
     GET4:
        MOV AX , N4
        RET
        
     GET5:
        MOV AX , N5
        RET
        
     GET6:
        MOV AX , N6
        RET
        
     GET7:
        MOV AX , N7
        RET
        
     GET8:
        MOV AX , N8
        RET
        
     GET9:
        MOV AX , N9
        RET


                 
CALCULATE_PERCENT:

    SUB AX , AX
    SUB DX , DX
    
    CALL GET_Ti
    ;AX , CONTAINS NUMERATOR
    MOV BX  , 10 ;BX CONTAINS DENUMERATOR
    DIV BX          ;AFETR THIS AX CONTAINS QUTIENT
    
    RET
    
     
    
PRINT:
    ;WRITING THE CHARACTER TO THE OUTPUT FILE     
    MOV BX,OUTPUT_HANDLE
    MOV CX,1
    LEA DX,INPUT_CHARACTER  
    MOV AH,40H
    INT 21H
    
    RET         
   
    
    
    
      
             
END START