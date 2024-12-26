TITLE Project3 - Data Validation, Looping, and Constants  (Proj3_huanchih.asm)
; Author: Chih Hsuan Huang
; Last Modified: 11/05/2023
; OSU email address: huanchih@oregonstate.edu
; Course number/section: CS 271 Section 400_F2023
; Project Number: Project3          Due Date: 11/05/2023
; Description: The main procedure must be modularized into commented logical sections (procedures are not required this time)
;The four value limits defined as constants.
;The user input loop terminate depending on the value of the SIGN flag.
;The Min, Max, Count, Sum, and Average stored in named variables as they are calculated.

INCLUDE Irvine32.inc

.data

       sum      SDWORD   0             ; Initialize the sum with 0
       avg      SDWORD   0             ; Initialize the average with 0
       count    DWORD    0             ; Initialize the count with 0
       proName  BYTE     21 DUP(0)     ; Allocate 21 bytes for the user's name
       count_1  DWORD    1
       exc_1    BYTE     "--Program Intro--", 0
       exc_2    BYTE     "**EC: Number the lines during user input. Increment the line number only for valid number entries. ", 0
       exc_3    BYTE     "**EC: Calculate and display the average as a decimal-point number , rounded to the nearest .01. ", 0
       exc_4    BYTE     "--Program prompts, etc—", 0
       intro    BYTE     "Welcome to the Integer Accumulator by General Kenobi", 0
       intro_1  BYTE     "We will be accumulating user-input negative integers between the specified bounds, then displaying", 0
       intro_2  BYTE     "statistics of the input values including minimum, maximum, and average values values, total sum,", 0
       intro_3  BYTE     "and total number of valid inputs.", 0
       pro_1    BYTE     "What is your name? ",0
       pro_2    BYTE     "Hello there, ",0
       pro_3    BYTE     " Enter number: ",0
       msg_1    BYTE     "Please enter numbers in [-200, -100] or [-50, -1].",0
       msg_2    BYTE     "Enter a non-negative number when you are finished, and input stats will be shown.",0
       msg_3    BYTE     "This is not a number we're looking for (Invalid Input)!",0
       msg_4    BYTE     "You entered ",0
       msg_5    BYTE     " valid numbers.",0
       msg_6    BYTE     "The maximum valid number is ",0
       msg_7    BYTE     "The minimum valid number is ",0
       msg_8    BYTE     "The sum of your valid numbers is ",0
       msg_9    BYTE     "The rounded average is ",0
       msg_10   BYTE     "No valid numbers were entered.",0
       msg_11   BYTE     "We have to stop meeting like this. Farewell, ",0
       rema     DWORD    ?
       flpoin   BYTE     ".",0
       flprom   BYTE     "As a floating point number:    ", 0
       neg1k    DWORD    -1000
       onek     DWORD    1000
       subt     DWORD    ?
       flpoin_1 DWORD    ?
       max      SDWORD   -100          ; Initialize the maximum number with -100
       min      SDWORD   0             ; Initialize the minimum number with 0
       rou      DWORD    0
.code

main PROC
       ; Display introductory messages
       mov   edx,OFFSET intro                         ;show intro
       call  WriteString
       call  Crlf
       mov   edx,OFFSET intro_1                       ;show intro
       call  WriteString
       call  Crlf
       mov   edx,OFFSET intro_2                       ;show intro
       call  WriteString
       call  Crlf
       mov   edx,OFFSET intro_3                       ;show intro
       call  WriteString
       call  Crlf
       mov   edx,OFFSET pro_1                       ; prompt for name
       call  WriteString
       mov   edx,OFFSET proName                    ; read name
       mov   ecx,SIZEOF proName
       call  ReadString

       ; Display greeting message with the user's name
       mov   edx,OFFSET pro_2                       ; print greetins message
       call  WriteString
       mov   edx,OFFSET proName     
       call  WriteString
       call  Crlf
       call  Crlf
       call  Crlf

       ; Display instructions for the user
       mov   edx,OFFSET msg_1                       ; print instructions
       call  WriteString
       call  Crlf
       mov   edx,OFFSET msg_2
       call  WriteString
       call  Crlf
       call  Crlf
       mov   edx,OFFSET exc_1                       ;print statement
       call  WriteString
       call  Crlf
       mov   edx,OFFSET exc_2                      
       call  WriteString
       call  Crlf
       call  Crlf
       mov   edx,OFFSET exc_4              
       call  WriteString
       call  Crlf
; Repeatedly prompt the user to enter a number.

cou:
       ; Loop to repeatedly prompt the user to enter a number
       mov   eax, count_1
       call  WriteDec
       add   eax, 1
       mov   count_1, eax
       mov   edx,OFFSET pro_3
       call  WriteString
       call  ReadInt
       add   eax,0
       JNS   endLoop                               ; non-negative number is entered, goto extLoop

       ; if user input exists in the [-200,-100], add it to sum
       ; otherwise goto nxtCmp
       mov   ebx,-200
       mov   ecx,-100     
       cmp   eax,ebx      
       jl    err
       cmp   eax,ecx
       jg    next
       add   sum,eax
       mov   ebx,eax

       ; update maximum and minimum
       .IF eax > max
        xchg eax,max   ; If the number is within the range, update the sum, maximum, and minimum
       .ENDIF             ; Otherwise, go to the next comparison
       .IF ebx < min
        xchg ebx,min
       .ENDIF

       ; count the valid numbers
       inc count
       jmp cou

       
next:
       ; if user input exists in the [-50,-1], add it to sum
       ; otherwise goto err
       mov   ebx,-50
       mov   ecx,-1
       cmp   eax,ebx
       jl    err
       cmp   eax,ecx
       jg    err
       add   sum,eax
       mov   ebx,eax

       ; update maximum and minimum
       .IF eax > max
              xchg eax,max
       .ENDIF
       .IF ebx < min
              xchg ebx,min
       .ENDIF

       ; count the valid numbers
       inc count
       jmp cou

       ; Notify the user of any invalid numbers
err:
       mov   edx,OFFSET msg_3
       call  WriteString
       call  Crlf
       jmp   cou

endLoop:
       ; Check if any valid numbers were entered
       cmp   count,0
       jne   disp         
       ; if no valid numbers were entered, display a
       ;special message and skip to departing
       mov   edx,OFFSET msg_10
       call  WriteString
       call  Crlf
       jmp   departing

       ; otherwise
disp:
       ; Display statistics of the given valid numbers
       mov   edx,OFFSET exc_1                       
       call  WriteString
       call  Crlf
       mov   edx,OFFSET exc_3                      
       call  WriteString
       call  Crlf
       call  Crlf
       mov   edx,OFFSET exc_4              
       call  WriteString
       call  Crlf
       mov   esi,sum
       mov   edi,count
       fild  sum     
       fidiv count                                      ; ST(0)=sum/count

       call  CrLf
       mov   edx,OFFSET msg_4                       ; display number of valid numbers
       call  WriteString
       mov   eax,edi
       call  WriteDec
       mov   edx,OFFSET msg_5
       call  WriteString
       call  Crlf

       mov   edx,OFFSET msg_6                       ; display maximum number
       call  WriteString
       mov   eax,max
       call  WriteInt
       call  Crlf

       mov   edx,OFFSET msg_7                       ; display minimum number
       call  WriteString
       mov   eax,min
       call  WriteInt
       call  Crlf

       mov   edx,OFFSET msg_8                       ; display the sum of the given numbers
       call  WriteString
       mov   eax,sum
       call  WriteInt
       call  Crlf

       mov   edx,OFFSET msg_9                       ; display rounded average of the given numbers
       call  WriteString
       frndint
       fist  avg
       mov   eax,avg
       call  WriteInt
       call  Crlf

       ; integer rounded average
       mov    eax, 0
       mov    eax, sum
       cdq
       mov    ebx, count_1
       sub    ebx, 2
       idiv   ebx
       mov    rou, eax

       ; integer average for accumulator
       mov   rema, edx
       mov   edx, OFFSET flprom
       call  WriteString
       call  WriteInt
       mov   edx, OFFSET flpoin
       call  WriteString


       ; stuff for floating point creation
       mov   eax, rema
       mul   neg1k
       mov   rema, eax ; eax now holds remainder * -1000
       mov   eax, count_1
       sub   eax, 2           ; ebx now holds something?
       mul   onek
       mov   subt, eax

       ; stack stuff for floating point creation
       fld   rema
       fdiv  subt
       fimul onek
       frndint
       fist  flpoin_1
       mov   eax, flpoin_1
       call  WriteDec
       call  CrLf



departing:                                              ; display departing message
       mov   edx,OFFSET msg_11
       call  WriteString
       mov   edx,OFFSET proName
       call  WriteString
       call  Crlf
       exit

main ENDP

END main