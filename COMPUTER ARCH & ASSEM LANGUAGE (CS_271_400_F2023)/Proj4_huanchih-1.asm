TITLE Project 4 - Nested Loops and Procedures      (Proj4_huanchih.asm)


; Author: Chih Hsuan Huang
; Last Modified: 11/19/2023
; OSU email address: huanchih@oregonstate.edu
; Course number/section: CS 271 Section 400 F2023
; Project Number: Project 4 - Nested Loops and Procedures Due Date: 11/19/2023
; Description: The program accepts input from the user indicating how many prime numbers they would like to see. Limit input range is 1 to 4000. 
      ;If the number entered is outside this range, the user will be asked to enter it again and try again. 
      ;Align all output and set a "Press any key to continue..." every 20 lines to continue browsing the next page of output

INCLUDE Irvine32.inc  ; Include Irvine32 library for input and output procedures.

.data
maxPrimes    DWORD   ?       ; Input: number of prime numbers to display
max          DWORD   4000    ; Maximum number for primes
min          DWORD   1       ; Minimum number for primes
primeCount   DWORD   0       ; Number of primes printed
count        BYTE    10      ; Counter for spacing between prime numbers
numTo        DWORD   2       ; Number to check if prime
Num_comp     DWORD   2       ; Counter for checking divisibility
prevPrim     DWORD   1       ; Variable to store the previous prime number
pageNum      DWORD   0       ; Page counter


intro        BYTE "Prime Numbers Programmed by Chih Hsuan Huang", 0
intro_1      BYTE "Enter the number of prime numbers you would like to see.", 0
intro_2      BYTE "I’ll accept orders for up to 4000 primes.", 0
greet_1      BYTE "Enter the number of primes to display [1 ... 4000]: ", 0
outrange     BYTE "No primes for you! Number out of range. Try again.", 0
intro_EC     BYTE "--Program Intro--", 0
EC1_DES      BYTE "**EC:Align Output Column", 0
EC2_DES      BYTE "**EC:Extend the range of primes to display up to 4000 primes, shown 20 rows of primes per page.  The user can “Press any key to continue” to view the next page.  ", 0
prompt_EC    BYTE "--Program prompts, etc—", 0
one          BYTE " ", 0
two          BYTE "  ", 0
three        BYTE "   ", 0
four         BYTE "    ", 0
five         BYTE "     ", 0
Bye          BYTE "Results certified by Chih Hsuan Huang. Goodbye.", 0

.code

;-------------------------------------------------------
; Name: main
;
; Description:
;   This is the primary entry point and main procedure of the program. It orchestrates the overall
;   flow of the program by sequentially calling other procedures. It starts with a greeting to the user,
;   then obtains user input, processes this input to compute and display prime numbers, and finally
;   concludes with a farewell message to the user.
;
; Preconditions: 
;   All invoked procedures (greet, getUserData, getPrimes, laterDude) and variables used within them
;   must be defined and initialized properly. The Irvine32 library should be included for I/O operations.
;
; Postconditions:
;   The program will have completed its execution, having displayed the requested prime numbers and
;   a goodbye message. All resources used will be released before exiting.
;
; Receives: 
;   none 
;
; Returns: 
;   none

;-------------------------------------------------------

main PROC
    call greet               ; Procedure to greet the user
    call getUserData         ; Procedure to get input from the user
    mov  maxPrimes, eax      ; Move the "within limits" number to its variable
    call getPrimes           ; Procedure to get and print primes to screen
    call Goodbye             ; Says goodbye to the user
    exit                     ; Exit to operating system
main ENDP

;-------------------------------------------------------
;Name: getPrimes

; Description: 
; This procedure loops through a range of numbers starting from 2,
; up to the specified limit. The limit is determined by the desired
; quantity of prime numbers the user wishes to find. For each number
; in this range, the algorithm checks divisibility starting from 2 
; up to the number itself, identifying prime numbers.

; Preconditions: 
; maxPrimes must be set to the desired number of primes to find.
; numToCk should be initialized to 2, the first prime number.
; Num_tocomp should also be initialized to 2 for divisibility checks.

; Postconditions:
; Prime numbers up to the specified count (maxPrimes) are printed.
; The global variables numToCk and primeCount may be modified reflecting the last checked number
; and the total count of primes found respectively.

; Receives: 
; maxPrimes = Indirectly received, specifying the number of primes to find.

; Returns: 
; This procedure does not return a value in a register
; Updates global state variables like numTo, primeCount

;-------------------------------------------------------


getPrimes PROC
    inc maxPrimes     ; Increment the user-specified number of primes

primeLoop:
    mov edx, 0        ; Divide number we are checking
    mov eax, numTo
    mov ecx, Num_comp
    div ecx

    cmp edx, 0        ; If evenly divided, check if prime
    je  check
                      ; Else
    inc Num_comp
    jmp primeLoop     ; Back to the top if not evenly divisible

check:
    cmp eax, 1         ; Remainder is 0; if quotient == 1, it's prime
    je  showPrimes
    jmp notPrime       ; Else, it's not prime

showPrimes:
    mov  eax, numTo
    call writeDec
    call AddSpace
    dec  maxPrimes
    mov  ecx, maxPrimes

    ; Increment the page counter and check if it's time to start a new page
    inc  pageNum
    cmp  pageNum, 200
    jl   notPrime

    ; If 200 primes have been printed, reset the page counter and start a new page
    mov  pageNum, 0
    call NewPage

notPrime:
    mov  eax, 2
    mov  Num_comp, eax
    inc  numTo
    loop primeLoop     ; Back to the top of the loop
    ret


getPrimes ENDP

;-------------------------------------------------------
; Name: NewPage
;
; Description:
;   This procedure is responsible for creating a new page in the program's output.

; Preconditions: 
;    It can be called whenever a new page in the output is needed.
;
; Postconditions: 
;   none
;
; Receives: 
;   none
;
; Returns: 
;   none
;
;-------------------------------------------------------
NewPage PROC
    call crLf
    CALL WaitMsg                  ;press any bottom to continue
    call crLf
    ret
NewPage ENDP


;-------------------------------------------------------
; Name: greet
;
; Description:
;   This procedure is responsible for displaying a greeting and introductory information to the user.
;   It prints a series of predefined messages to the console, introducing the program and providing
;   instructions or descriptions about its functionality. The messages include a general introduction,
;   usage instructions, and any special notes or extra credit features.
;
; Preconditions: 
;   The messages to be printed (intro, intro_1, intro_2, intro_EC, EC1_DES, EC2_DES, prompt_EC, greet_1)
;   must be defined in the data segment of the program.
;
; Postconditions: 
;   The console will display the series of introductory messages.
;
; Receives: 
;   No direct inputs are received by this procedure; it utilizes predefined messages from the data segment.
;
; Returns: 
;   This procedure does not return a value. Its primary function is to output text to the console.
;-------------------------------------------------------
greet PROC
    mov  edx, offset intro         ;print intro
    call writeString
    call crLf
    call crLf
    mov  edx, offset intro_1    
    call writeString
    call crLf
    mov  edx, offset intro_2
    call writeString
    call crLf
    call crLf
    mov  edx, offset intro_EC
    call writeString
    call crLf
    mov  edx, offset EC1_DES
    call writeString
    call crLf
    mov  edx, offset EC2_DES
    call writeString
    call crLf
    call crlf
    mov  edx, offset prompt_EC    ;print prompt
    call writeString
    call crLf
    call crlf
    mov  edx, offset greet_1      ;print greet
    call writeString
    ret
greet ENDP

;-------------------------------------------------------
; Name: Goodbye
;
; Description:
;   This procedure is responsible for displaying a farewell message to the user. 
;
; Preconditions: 
;   The farewell message (or the pointer to it) should be defined in the data segment prior to calling 
;   this procedure.
;
; Postconditions: 
;   A farewell message is displayed on the console, indicating the end of the program's execution.
;
; Receives: 
;   none
;
; Returns: 
;   none
;-------------------------------------------------------

Goodbye PROC
    call crLf           ; Says goodbye
    call crLf
    mov  edx, offset Bye
    call writeString
    call crLf
    ret
Goodbye ENDP

; ---------------------------------------------------------------------------------
; Name: getUserData
; 
; Reads and validates user input, ensuring it falls within a predefined range.
;
; Preconditions: 
; The 'min' and 'max' variables must be initialized to define the acceptable range of input.
;
; Postconditions: 
; A valid user input within the specified range is stored in the EAX register.
;
; Receives: 
; 'min' and 'max' variables are used to validate the input.
;
; Returns: 
; eax = Valid integer input from the user that is within the specified range.
; ---------------------------------------------------------------------------------
getUserData PROC
validate:                     ; Called until input is correct
    call ReadInt
    cmp  eax, max
    jg   badInput
    cmp  eax, min
    jl   badInput
    ret                   ; Returns if number is within limits

badInput:                ; If the number is outside of the limits
    mov  edx, offset outrange
    call WriteString
    call crLf
    mov  edx, offset greet_1
    call writeString
    jmp  validate
getUserData ENDP

;-------------------------------------------------------
; Name: AddSpace
;
; Description:
;   This procedure formats the output by adding spaces after each printed integer. The number
;   of spaces added depends on the value of the integer. It ensures a consistent alignment of
;   output by adjusting the space count based on the number's digit length.
;   - 5 spaces for numbers less than 10
;   - 4 spaces for numbers less than 100
;   - 3 spaces for numbers less than 1000
;   - 2 spaces for numbers less than 10000
;   - 1 space for numbers less than 100000
;   It also handles line breaks after every 10 items.
;
; Preconditions: 
;   The EAX register should contain the integer value to be printed.
;   The 'count' variable is used to track the number of items printed in the current row.
;
; Postconditions: 
;   Appropriate spaces are added after the integer for alignment. 
;   If 10 items have been printed in the current row, a new line is started.
;
; Receives: 
;   EAX = Integer value whose output spacing is to be formatted.
;   count = Counter variable to determine when to start a new line.
;
; Returns: 
;   none
;-------------------------------------------------------
AddSpace PROC
    dec  count           ; Decrement the counter for the current line
    mov  cl, count       ; Move the counter to cl for comparison



    ; Determine the space needed based on the value being printed
    cmp  cl, 0
    je   NewLine          ; Jump to NewLine if counter is 0
    cmp  cl, 1
    jl   threeSpace       ; Jump to threeSpace if counter is less than 1

    cmp  eax, 10
    jl   fiveSpace
    ; For values less than 100, add four spaces
    cmp  eax, 100
    jl   fourSpace
    ; For values less than 1000, add five spaces
    cmp  eax, 1000
    jl   threeSpace
    ; For values less than 10000, add two spaces
    cmp  eax, 10000
    jl   twoSpace
    ; For values less than 100000, add one space
    cmp  eax, 100000
    jl   oneSpace

    ; If none of the above conditions are met, just add a single space
    mov  edx, offset five
    call writeString
    ret


threeSpace: 
    mov  edx, offset three  ; Use three spaces for values less than 10000
    call writeString
    ret

fourSpace:
    mov  edx, offset four   ; Use four spaces for values less than 10000
    call writeString
    ret

fiveSpace:
    mov  edx, offset five  ; Use five spaces for values less than 10000
    call writeString
    ret

twoSpace:
    mov  edx, offset two   ; Use two spaces for values less than 10000
    call writeString
    ret

oneSpace:
    mov  edx, offset one   ; Use one spaces for values less than 10000
    call writeString
    ret

NewLine:
    call crLf             ; start a new line
    mov  count, 10       ; reset the counter for the next line
    ret


AddSpace ENDP




END main