TITLE Project 5 - Arrays, Addressing, and Stack-Passed Parameters  (Proj5_huanchih.asm)

; Author: Chih Hsuan Huang
; Last Modified: 11/24/2023
; OSU email address: huanchih@oregonstate.edu
; Course number/section: CS 271 Section 400_2023
; Project Number: Project 5    NULL Due Date: 11/24/2023
; Description:  Program generates 200 random integers in the range of 15 (LO) to 50 (HI)
;               and stores them in consecutive elements of an array (ARRAYSIZE = 200).
;               Random numbers are generated using Irvine's 'RandomRange' and 'Randomize'.
;               The generated list of integers is displayed with two spaces between each value,
;               and 20 numbers per line.
;               The list of integers is then sorted.
;               The sorted list of integers is displayed with two spaces between each value,
;               and 20 numbers per line.
;               Another array, 'counts', holds the number of instances of each value in the range [15,50].
;               The 'counts' array is displayed with two spaces between each value,
;               and 20 numbers per line.


INCLUDE Irvine32.inc

;  constant definitions 
  
   HI           =   50
   LO           =   15
   ARRAYSIZE    =   200

.data
  
;  variable definitions 

   programTitle      byte   "Generating, Sorting, and Counting Random integers!                      Programmed by Chih Hsuan Huang", 0
   description       byte   "This program generates 200 random integers between 15 and 50, inclusive.", 0
   description_1     byte   "It then displays the original list, sorts the list, displays the median value of the list,", 0
   description_2     byte   "displays the list sorted in ascending order, and finally displays the number of instances", 0
   description_3     byte   "of each generated value, starting with the number of lowest.", 0
   intro             byte   "--Program Intro--", 0
   intro_1           byte   "**EC1: Display the numbers ordered by column instead of by row. These numbers should still be printed 20-per-row, filling the first row before printing the second row.", 0
   intro_2           byte   "**EC2: Generate the numbers directly into a file, then read the file into the array. This may modify your procedure parameters significantly. ", 0
   intro_3           byte   "--Program prompts, etc?", 0
   unsortedTitle     byte   "Your unsorted random numbers: ", 0
   sortedTitle       byte   "Your sorted random numbers: ", 0
   medianTitle       byte   "The median value of the array: ", 0
   countsTitle       byte   "Your list of instances of each generated number, starting with the smallest value: ", 0
   goodbyeMsg        byte   "Goodbye, and thanks for using my program!", 0
   twoSpace          byte   " ", 0
  
   randArray         DWORD   ARRAYSIZE   DUP(?)
   counts            DWORD   36  DUP(0) 

.code
; ---------------------------------------------------------------------------------
; Name: main
;
; Description: The main procedure of the program that orchestrates the execution
;              of various tasks such as initializing, generating, and displaying
;              arrays of random integers, sorting the array, calculating the median,
;              counting occurrences, and displaying results. Finally, it concludes
;              with a farewell message.
;
; Preconditions: None 
;
; Postconditions: Program execution completes.
;
; Receives: None 
;
; Returns: None.
;
; Registers Changed: EAX, EBX, ECX, EDX, ESI
; ---------------------------------------------------------------------------------

main PROC

    ; Call introduction procedure with relevant offset parameters
    push  OFFSET  programTitle
    push  OFFSET  description
    push  OFFSET  description_1
    push  OFFSET  description_2
    push  OFFSET  description_3
    push  OFFSET  intro
    push  OFFSET  intro_1
    push  OFFSET  intro_2
    push  OFFSET  intro_3
    call  introduction

    ; Initialize random number generator
    call  Randomize

    ; Generate and fill an array with random integers
    push  OFFSET   randArray
    call  fillArray

    ; Display the unsorted array
    push  OFFSET   randArray
    push  OFFSET   unsortedTitle
    push  OFFSET   twoSpace
    push  OFFSET   twoSpace
    push  OFFSET   counts
    push  OFFSET   twoSpace
    call  displayList

    ; Sort the array
    push  OFFSET   randArray
    call  sortList

     ; Count occurrences of each value in the array
    push  OFFSET   randArray
    push  OFFSET   counts
    call  countList

    ; Display the median of the array
    push  OFFSET   randArray
    push  OFFSET   medianTitle
    call  displayMedian

    ; Display the sorted array
    push  OFFSET   randArray
    push  OFFSET   sortedTitle
    push  OFFSET   twoSpace
    push  OFFSET   countsTitle
    push  OFFSET   counts
    push  OFFSET   twoSpace
    call  displayList

    ; Display farewell message
    push  OFFSET   goodbyeMsg
    call  farewell

    ; Exit to the operating system
    exit   
main ENDP

; ---------------------------------------------------------------------------------
; Name: introduction
;
; Description: Displays an introduction message by outputting a series of strings
;              separated by carriage return and line feed (CrLf) characters.
;
; Preconditions: Assumes that the calling code has pushed the relevant string offsets
;                onto the stack in the correct order.
;
; Postconditions: The introduction message is displayed.
;
; Receives: None 
;
; Returns: None.
;
; Registers Changed: EAX, EBX, ECX, EDX
; ---------------------------------------------------------------------------------
introduction PROC

    push  ebp           ; Set up stack frame
    mov   ebp, esp

    ; Display program title
    mov   edx, [ebp+40]
    call  WriteString
    call  CrLf
    call  CrLf
    ; Display description lines
    mov   edx, [ebp+36]
    call  WriteString
    call  CrLf
    mov   edx, [ebp+32]
    call  WriteString
    call  CrLf
    mov   edx, [ebp+28]
    call  WriteString
    call  CrLf
    mov   edx, [ebp+24]
    call  WriteString
    call  CrLf
    mov   edx, [ebp+20]
    call  WriteString
    call  CrLf

    ; Display additional lines
    call  CrLf
    mov   edx, [ebp+16]
    call  WriteString
    call  CrLf
    call  CrLf
    mov   edx, [ebp+12]
    call  WriteString
    call  CrLf
    mov   edx, [ebp+8]
    call  WriteString
    call  CrLf
    call  CrLf

    pop   ebp           ; Restore previous stack frame
    ret   12            ; Clean up and return
introduction ENDP


; ---------------------------------------------------------------------------------
; Name: fillArray
;
; Description: Fills an array with random integers in the specified range [LO, HI].
;
; Preconditions: Assumes that the calling code has pushed the address of the array
;                onto the stack.
;
; Postconditions: The array is filled with random integers.
;
; Receives: The address of the array to be filled.
;
; Returns: None.
;
; Registers Changed: EAX, ESI
; ---------------------------------------------------------------------------------

fillArray PROC

    push  ebp            ; Set up stack frame
    mov   ebp, esp
    mov   esi, [ebp+8]   ; Get the address of the array
    mov   ecx, ARRAYSIZE ; Set the loop counter to the array size

addElement:
    mov   eax, HI        ; Calculate the range for RandomRange
    sub   eax, LO
    inc   eax
    call  RandomRange    ; Generate a random number within the range
    add   eax, LO        ; Adjust the random number to be in [LO, HI]
    mov   [esi], eax     ; Store the random number in the array

    add   esi, 4         ; Move to the next element in the array
    loop  addElement     ; Repeat until all elements are filled

    pop   ebp            ; Restore previous stack frame
    ret   4              ; Clean up and return

fillArray ENDP

; ---------------------------------------------------------------------------------
; Name: sortList
;
; Description: Sorts an array of integers in ascending order using the bubble sort algorithm.
;
; Preconditions: Assumes that the calling code has pushed the address of the array onto
;                the stack.
;
; Postconditions: The array is sorted in ascending order.
;
; Receives: The address of the array to be sorted.
;
; Returns: None.
;
; Registers Changed: EAX, EBX, ECX, EDX, ESI
; ---------------------------------------------------------------------------------
sortList PROC

    push   ebp            ; Set up stack frame
    mov    ebp, esp
    mov    esi, [ebp+8]   ; Get the address of the array
    mov    ecx, ARRAYSIZE ; Set the loop counter to the array size
    dec    ecx            ; Decrement for zero-based indexing

outerLoop:
    mov    eax, [esi]
    mov    edx, esi
    push   ecx

innerLoop:
    mov    ebx, [esi+4]
    mov    eax, [edx]
    cmp    eax, ebx
    jle    skipSwap
    add    esi, 4
    push   esi
    push   edx
    push   ecx
    call   exchangeElements
    sub    esi, 4

skipSwap:
    add    esi, 4
    loop   innerLoop

    pop    ecx
    mov    esi, edx

    add    esi, 4
    loop   outerLoop

    pop    ebp            ; Restore previous stack frame
    ret    8              ; Clean up and return

sortList ENDP

; ---------------------------------------------------------------------------------
; Name: exchangeElements
;
; Description: Exchanges the values at two given addresses.
;
; Preconditions: Assumes that the calling code has pushed the addresses of the
;                elements onto the stack in the correct order.
;
; Postconditions: The values at the given addresses are exchanged.
;
; Receives: The addresses of the two elements to be exchanged.
;
; Returns: None.
;
; Registers Changed: EAX, EBX, ECX, EDX, ESI
; ---------------------------------------------------------------------------------
exchangeElements PROC

    push    ebp            ; Set up stack frame
    mov     ebp, esp
    pushad                 ; Save general-purpose registers

    mov     eax, [ebp+16]  ; Get the address of the first element
    mov     ebx, [ebp+12]  ; Get the address of the second element

    mov     edx, eax
    sub     edx, ebx

    mov     esi, ebx
    mov     ecx, [ebx]     ; Save the value at the second element
    mov     eax, [eax]     ; Get the value at the first element

    mov     [esi], eax     ; Store the value of the first element at the second element
    add     esi, edx       ; Move to the first element
    mov     [esi], ecx     ; Store the saved value at the first element

    popad                  ; Restore general-purpose registers
    pop     ebp            ; Restore previous stack frame
    ret     12             ; Clean up and return

exchangeElements ENDP

; ---------------------------------------------------------------------------------
; Name: displayMedian
;
; Description: Displays the median of an array of integers.
;
; Preconditions: Assumes that the calling code has pushed the address of the array
;                and the title string onto the stack in the correct order.
;
; Postconditions: The median of the array is displayed.
;
; Receives: The address of the array to find the median, and the title string.
;
; Returns: None.
;
; Registers Changed: EAX, EBX, ECX, EDX, ESI
; ---------------------------------------------------------------------------------
displayMedian PROC

    push  ebp          ; Set up stack frame
    mov   ebp, esp
    mov   esi, [ebp+12] ; Get the address of the array
    mov   eax, ARRAYSIZE ; Set the loop counter to the array size
    mov   edx, [ebp+8]  ; Get the address of the title string
    call  WriteString

    mov   edx, 0
    mov   ebx, 2
    div   ebx
    mov   ecx, eax

medianLoop:
    add   esi, 4
    loop  medianLoop

    mov   eax, [esi - 4]
    add   eax, [esi]
    mov   edx, 0
    mov   ebx, 2
    div   ebx
    call  WriteDec
    call  CrLf
    call  CrLf
    pop   ebp
    ret   8

displayMedian ENDP

; ---------------------------------------------------------------------------------
; Name: displayList
;
; Description: Displays the contents of an array, presenting 20 numbers per line
;              with two spaces between each value.
;
; Preconditions: Assumes that the calling code has pushed the array address and
;                the title string onto the stack in the correct order.
;
; Postconditions: The array is displayed with 20 numbers per line and two spaces
;                 between each value.
;
; Receives: The address of the array to be displayed, and the title string.
;
; Registers Changed: EAX, EBX, ECX, EDX, ESI
; ---------------------------------------------------------------------------------
displayList PROC

    push  ebp            ; Set up stack frame
    mov   ebp, esp
    mov   esi, [ebp+28]  ; Get the address of the array
    mov   edx, [ebp+24]   ; Get the address of the title string
    call  WriteString    ; Display the title
    call  CrLf

    mov  edx, [ebp+20]  ; twoSpace ???
    mov   ebx, 0         ; Counter for a new line

    ; Outer loop for rows
    mov   ecx, 10        ; 20 rows

rowLoop:
    push  ecx

    ; Inner loop for columns
    mov   ecx, 20        ; 10 columns
    mov   edi, ebx       ; Current row index

columnLoop:
    mov  eax, [esi + edi*4] 
    call WriteDec           
    push edx                ; keep twoSpace address
    call WriteString        ; show twoSpace
    pop  edx              
    add  edi, 10            ; move to next element
    loop columnLoop

    pop   ecx
    call  CrLf                ; Move to the next line
    inc   ebx                 ; Increment the new line counter
    loop  rowLoop

    call  Crlf
    mov   edx, [ebp+16]  ; Get the address of the counts title string
    call  WriteString
    call  Crlf
    mov   ecx, 36               
    mov   esi, [ebp+12]

printCounts:
    mov   eax, [esi]
    cmp   eax, 0
    je    skipNextLinee
    call  WriteDec
    mov   edx, [ebp+8]
    call  WriteString
    inc           ebx
    ;To check if the maximum limit of integers per line is reached
    cmp   ebx, 30
    jl    skipNextLinee
    call  CrLf
    mov   ebx, 0       ;the counter is refreshed

skipNextLinee:
    add   esi, 4       ;move to next element of the array
    loop  printCounts
 
skip:
    pop ebp
    ret


displayList ENDP


; ---------------------------------------------------------------------------------
; Name: countList 
;
; Description: Counts the occurrences of each value in the array and updates
;              the corresponding counts array.
;
; Preconditions: Assumes that the calling code has pushed the address of the array
;                onto the stack.
;
; Postconditions: The counts array is updated with the occurrences of each value
;                 in the array.
;
; Receives: The address of the array to be counted.
;
; Returns: None.
;
; Registers Changed: EAX, EDX, ESI, EDI, ECX, EBP
; ---------------------------------------------------------------------------------
countList PROC

    push ebp             ; Set up stack frame
    mov  ebp, esp
    mov  esi, [ebp+12]    ; Get the address of the array
    mov  edi, [ebp+8] ; Get the address of the counts array
    mov  ecx, ARRAYSIZE  ; Set the loop counter to the array size

countLoop:
    mov  eax, [esi]     ; Get the value at the current index
    sub  eax, LO         ; Convert to the counts array index
    mov  edx, [edi + eax*4] ; Get the current count
    inc  edx            ; Increment the count
    mov  [edi + eax*4], edx ; Update the count in the counts array
    add  esi, 4         ; Move to the next element
    loop countLoop

    pop  ebp            ; Restore previous stack frame
    ret  4              ; Clean up and return

countList ENDP





; ---------------------------------------------------------------------------------
; Name: farewell
;
; Description: Displays a farewell message.
;
; Preconditions: Assumes that the calling code has pushed the farewell message
;                string onto the stack.
;
; Postconditions: The farewell message is displayed.
;
; Receives: The address of the farewell message string.
;
; Returns: None.
; Registers Changed: EDX, EBP
; ---------------------------------------------------------------------------------
farewell PROC

    push   ebp           ; Set up stack frame
    mov    ebp, esp
    call   CrLf
    call   CrLf
    mov    edx, [ebp+8]  ; Get the address of the farewell message string
    call   WriteString
    call   CrLf
    call   CrLf

    pop   ebp            ; Restore previous stack frame
    ret   4              ; Clean up and return

farewell ENDP

END main
