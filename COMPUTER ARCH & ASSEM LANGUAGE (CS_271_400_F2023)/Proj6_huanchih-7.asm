TITLE Project 6 - String Primitives and Macros    (Proj6_huanchih.asm)

; Author: Chih Hsuan Huang
; Last Modified: 12/9/2023
; OSU email address: huanchih@oregonstate.edu
; Course number/section: CS 271 Section 400_F2023
; Project Number: Project 6  NULL Due Date: 12/10/2023
; Description: This project allows users to enter 10 integer numbers (signed or unsigned). 
               ;This code will determine whether valid numbers are entered and calculate the sum and average. 
               ;This project will use Macro. mGetString can obtain user input and mDisplayString can help output strings. 
               ;It receives ten numbers read from a 32bit register, 
               ;helps determine input and output through ReadVal and WriteVAl, 
               ;and finally uses DisplayOutput. to output all numbers, sum and average.

INCLUDE Irvine32.inc

MAX_NUMBERS     = 10
STRING_SIZE     = 300
basic_number    = 1

; Macro to get a string input with a prompt
mGetString MACRO prom, inputString
    push ecx
    push edx
    mDisplayString prom
    mov edx, inputString
    mov ecx, STRING_SIZE
    call ReadString
    pop edx
    pop ecx
ENDM

; Macro to display a string
mDisplayString MACRO String
    push edx
    mov edx, String
    call WriteString
    pop edx
ENDM


.data

    min             DWORD  -2147483648
    max             DWORD  2147483647
    avg             SDWORD ?
    sum             SDWORD ?
    arr             SDWORD MAX_NUMBERS DUP(?)
    input           BYTE   STRING_SIZE DUP(0)
    output          BYTE   MAX_NUMBERS DUP(0)
    twoSpace        BYTE   ",   ", 0
    intro           BYTE   "PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
    intro_1         BYTE   "Written by: Chih Hsuan Huang", 0
    intro_2         BYTE   "Please provide 10 signed decimal integers.", 0
    intro_3         BYTE   "Each number needs to be small enough to fit inside a 32-bit register.", 0
    intro_4         BYTE   "After you have finished inputting the raw numbers, I will display a list of", 0
    intro_5         BYTE   "the integers, their sum, and their average value.", 0
    Des_up          BYTE   "--Program Intro--", 0
    Des_down        BYTE   "--Program prompts, etc ", 0
    showPrompt      BYTE   "Please enter a signed number:", 0
    error           BYTE   "ERROR: You did not enter a signed number or your number was too big. ", 0
    again           BYTE   "Please try again:", 0
    promptMsg       BYTE   "You entered the following numbers: ", 0
    sumDisplayMsg   BYTE   "The sum of these numbers is: ", 0
    avgDisplayMsg   BYTE   "The truncated average is: ", 0
    goodbyeMsg      BYTE   "Thanks for playing! ", 0
    
; ---------------------------------------------------------------------------------
; Name: main
;
; Description: Main procedure to execute the program.
; 
; Preconditions: None
;
; Postconditions: Displayed the list of numbers, sum, and truncated average.
; 
; Receives: None
;
; Returns: None
; ---------------------------------------------------------------------------------
.code
main PROC
	
    mov  edi, OFFSET arr
    mov  ecx, 10
    mDisplayString OFFSET intro
    call Crlf
    mDisplayString OFFSET intro_1
    call Crlf
    call Crlf
    mDisplayString OFFSET intro_2
    call Crlf
    mDisplayString OFFSET intro_3
    call Crlf
    mDisplayString OFFSET intro_4
    call Crlf
    call Crlf
    mDisplayString OFFSET Des_up
    call Crlf
    mDisplayString OFFSET Des_down
    call Crlf
    call Crlf 

InputeElement:
    push OFFSET twoSpace
    push OFFSET again
    push OFFSET error
    push OFFSET showPrompt
    push OFFSET input
    push edi 
    call ReadVal  
    add  edi, 4
    loop InputeElement
  
    push OFFSET twoSpace
    push OFFSET output
    push OFFSET promptMsg
    push OFFSET arr
    push OFFSET output
    push OFFSET sumDisplayMsg
    push OFFSET arr
    push OFFSET avgDisplayMsg     
    call DisplayOutput

    call Crlf
    call Crlf
    mDisplayString OFFSET goodbyeMsg
    call Crlf

exit    
main ENDP



; ---------------------------------------------------------------------------------
; Name: ReadVal
;
; Description: Procedure to read a signed integer from the user input.
; 
; Preconditions: Input string and buffer must be defined.
;
; Postconditions: Returns the converted integer value.
; 
; Receives: Input string, buffer, and length.
;
; Returns: Converted integer value.
; ---------------------------------------------------------------------------------
ReadVal  PROC
    push ebp
    mov  ebp, esp
    push ecx
    
prompt:
    
    mov  esi, [ebp+12]   
    mov  edx, 0          ; Clear edx for error checking
    mov  ecx, 0          ; Clear ecx for digit count
    mov  ebx, 10         ; Set divisor to 10
    mov  eax, 0          ; Clear eax for integer conversion 
    mGetString [ebp+16], [ebp+12] ; Display the prompt and get user input
    cld                 ; Clear the direction flag for forward movement
    jmp  signCheck      

prompt_1:
    
    mov  esi, [ebp+12]    
    mov  edx, 0          
    mov  ecx, 0          
    mov  ebx, 10         ; Set divisor to 10
    mov  eax, 0   
    mGetString [ebp+24], [ebp+12] 
    cld                 
 
signCheck:
    lodsb               ; Load the next character from the input string into al
    cmp  al, 0           
    je   inputzero      
    cmp  AL, '+'          ; Check if the character is '+'
    je   positiveSign     
    cmp  AL, '-'          ; Check if the character is '-'
    je   negativeSign   
    jmp  nextCheck

nextCheck:
    cmp  AL, '9'          ; Check if the character is  sign or alphabet
    jg   errorMsg 
    cmp  AL, '0'          
    jl   errorMsg        ; Check if the character is  sign 
    inc  ecx           
    jmp  signCheck       

positiveSign:
    lodsb               ; Load the next character from the input string into AL
    cmp  AL, 0           ; Check if end of string
    je   NoneElement 
    cmp  AL, '9'          ; Check if the character is  sign or alphabet
    jg   errorMsg         
    cmp  AL, '0'          ; Check if the character is  sign
    jl   errorMsg        
    inc  ecx             ; Increment digit count
    jmp  positiveSign   ; Continue the positive sign routine

NoneElement:
    cmp  ecx, 0 
    je   errorMsg
    mov  esi, [ebp+12]    ; Load the input string into esi
    mov  eax, 0          
    lodsb               ; Load the first character of the number
    jmp  PositiveToInt 

negativeSign:
    lodsb               ; Load the next character from the input string into AL
    cmp  AL, 0           
    je   negativeInput    
    cmp  AL, '0'          
    jl   errorMsg         
    cmp  AL, '9'          
    jg   errorMsg         
    inc  ecx             ; Increment digit count
    jmp  negativeSign   

PositiveToInt:
    lodsb               
    cmp  AL, 0           ; Check if end of string
    je   EndCmp           
    sub  AL, '0'          ; Convert character to integer 
    mov  ebx, 10         
    imul edx, ebx       ; Multiply the current result by 10
    add  edx, eax        ; Add the current digit to the result
    jo   errorMsg         ; If there is a overflow, jump to errorMsg
    jmp  PositiveToInt 

inputzero:
    cmp  ecx, 0          ; Check if no digits entered
    je   errorMsg  
    cmp  ecx, 10         
    jg   errorMsg         
    mov  esi, [ebp+12]    
    mov  eax, 0          

convertStringToInt:
    lodsb               
    cmp  AL, 0        
    je   EndCmp        
    sub  AL, '0'         
    push eax            ; Push the digit onto the stack
    mov  eax, edx       
    mov  ebx, 10        ; Set divisor to 10
    imul ebx            ; Multiply the current result by 10
    jo   errorMsg       
    mov  edx, eax       ; Move the result back to edx
    pop  eax            ; Pop the digit from the stack
    add  edx, eax       ; Add the current digit to the result
    jo   errorMsg       ; If there is a overflow, jump to errorMsg
    jnc  convertStringToInt 

negativeInput:
    cmp  ecx, 0          ; Check if no digits entered
    je   errorMsg         
    mov  esi, [ebp+12]    
    mov  eax, 0          
    lodsb              
    jmp  negative_1ative       

negative_1ative:
    lodsb               
    cmp  AL, 0                 ; Check if end of string
    je   EndCmpNeg        
    sub  AL, '0'              ; Convert character to integer 
    mov  ebx, 10              ; Set divisor to 10
    imul edx, ebx       
    add  edx, eax             ; Add the current digit to the result
    jc   errorMsg              ; If there is a carry, jump to errorMsg
    jmp  negative_1ative 

errorMsg:
    push edx            
    mDisplayString [ebp+20]  ; Display the error message
    call CrLf           
    pop  edx                  ; Restore edx
    jmp  prompt_1             ; Retry the input process

EndCmp:
    mov  ebx, [ebp+8]        ; Load the output buffer into ebx
    mov  [ebx], edx           ; Move the final result to the output buffer
    jmp  _RET

EndCmpNeg:
    neg  edx                  ; Negate the result for negative input
    mov  ebx, [ebp+8]   
    mov  [ebx], edx          ; Move the final result to the output buffer
    jmp  _RET

_RET:
    pop  ecx             
    pop  ebp             
    ret  16    
ReadVal ENDP

; ---------------------------------------------------------------------------------
; Name: WriteVal
;
; Description: Procedure to display a signed integer.
; 
; Preconditions: Input buffer must be defined.
;
; Postconditions: Displays the integer.
; 
; Receives: Input buffer.
;
; Returns: None
; ---------------------------------------------------------------------------------
WriteVal PROC
    push ebp
    mov  ebp, esp
    pushad              ; Preserve registers
    mov eax, [ebp+12]   
    mov edi, [ebp+8]   
    mov ecx, 0          
    cmp eax, 0          ; Check if the input value is negative
    jge transfer        ; If not negative, jump to trnsfer
    neg  eax            ; Negate the input value
    push edx            
    mov  edx, '-'  
    push edx            
    mDisplayString esp ; Display the negative sign
    pop  edx             
    pop  edx             

transfer:
    mov  edx, 0          
    mov  ebx, 10         
    div  ebx             ; Divide the input value by 10
    add  dl, '0'         ; Convert the remainder to ASCII
    push edx            
    inc  ecx             ; Increment digit count
    test eax, eax       ; Test if quotient is zero
    jnz  transfer        ; If not zero, continue the loop
    jmp  finish          ; If zero, finish the conversion

finish:
    pop  eax             
    stosb               ; Store the last digit in the output buffer
    dec  ecx             
    cmp  ecx, 0          ; Check if all digits are processed       
    jne  finish       
    mov  eax, 0          
    stosb               
    mov  edx, [ebp+8]    
    mDisplayString edx 
    popad               ; Restore registers
    pop  ebp             
    ret  8               
WriteVal ENDP


; ---------------------------------------------------------------------------------
; Name: DisplayOutput
;
; Description: Procedure to display the sum and average of an array.
; 
; Preconditions: Input array and buffer must be defined.
;
; Postconditions: Displays the sum and average.
; 
; Receives: Input array and buffer.
;
; Returns: None
; ---------------------------------------------------------------------------------
DisplayOutput PROC
    push  ebp
    mov   ebp, esp
    ; Display array prompt
    mov   edx, [ebp+28]    ; Load the array prompt into edx
    call  CrLf
    mDisplayString  edx
    call  CrLf
    ; Display each number in the array
    mov   esi, [ebp+24]     ; Load the input array into esi
    mov   ecx, 10          ; Set the loop counter to the array length

printNumLoop:
    mov   eax, [esi]       ; Load the current array element into eax
    push  eax
    push  [ebp+32]         ; Load the buffer for WriteVal
    call  WriteVal         ; Display the current array element
    mDisplayString  [ebp+36]  ; Display the space between numbers
    add   esi, 4           ; Move to the next array element
    loop  printNumLoop     ; Repeat the process for the entire array
    call  CrLf
    ; Calculate the sum of the array
    mov   esi, [ebp+12]     ; Load the input array into esi
    mov   eax, 0          
    mov   ecx, 10

sumCalLoop:
    mov   ebx, [esi]       ; Load the current array element into ebx
    add   eax, ebx         ; Add the current element to the sum
    add   esi, 4           ; Move to the next array element
    loop  sumCalLoop       ; Repeat the process for the entire array
    ; Display the sum prompt
    mov   edx, [ebp+16]    ; Load the sum prompt into edx
    mDisplayString  edx
    ; Display the sum
    push  eax
    push  [ebp+20]         ; Load the buffer for WriteVal
    call  WriteVal
    call  CrLf
    ; Check if the sum is negative
    cmp   eax, 0
    jl    IfSumNeg
    ; Display the average prompt
    mov   edx, [ebp+8]     ; Load the average prompt into edx
    mDisplayString  edx
    mov   edx, 0           ; Clear edx for average calculation
    ; Calculate the average
    mov   ebx, 10          ; Set divisor to 10
    div   ebx              ; Divide the sum by 10
    ; Display the average
    push  eax
    push  [ebp+20]         ; Load the buffer for WriteVal
    call  WriteVal
    call  CrLf
    jmp   _end

IfSumNeg:
    ; Display the negative sum and average
    neg  eax              
    mov  edx, [ebp+8]
    mDisplayString  edx
    mov  ebx, 10
    mov  edx, 0
    div  ebx             
    neg  eax
    ; Display the average
    push eax
    push [ebp+20]
    call WriteVal
    call CrLf

_end:
    pop  ebp
    ret  16
DisplayOutput ENDP


END main