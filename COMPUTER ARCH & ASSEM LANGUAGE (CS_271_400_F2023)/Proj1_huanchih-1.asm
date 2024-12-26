INCLUDE Irvine32.inc

;Name:Chih Hsuan Huang
;Email:huanchih@oregonstate.edu
;--Program Intro--
;**EC: I combined all the extra credits together
;--Program prompts, etc—

.data
   Title_1        BYTE   "         Elementary Arithmetic1", 0
   userName       BYTE   "     by Chih Hsuan Huang ", 0
   introduce_1    BYTE   "--Program Intro--", 0
   introduce_2    BYTE   "**EC: Use jg startProgram to repeat until the user chooses to quit.", 0
   introduce_3    BYTE   "**EC: Check if numbers are in strictly descending order. NOTE: Strictly Descending means A > B > C", 0
   introduce_4    BYTE   "--Program prompts, etc—", 0
   intro          BYTE   "Enter 3 numbers A > B > C, and I'll show you the sums and differences.", 0
   intro_1        BYTE   "**EC: Program verifies the numbers are in descending order.", 0
   firstnumber    BYTE   "First  Number: ", 0
   secondnumber   BYTE   "Second Number: ", 0
   thirdnumber    BYTE   "Third  Number: ", 0
   number_1       DWORD   ?   ; boolean to check for number
   number_2       DWORD   ?   
   number_3       DWORD   ?
   intro_2        BYTE   "Thanks for using Elementary Arithmetic!  Goodbye!",0
   equalsigns     BYTE   " = ", 0
   plus_1         DWORD   ?   ; boolean to check for sum
   plus_2         DWORD   ?
   plus_3         DWORD   ?
   plus_4         DWORD   ?
   Plussigns      BYTE   " + ",0
   minus_1        DWORD   ?  ; boolean to check for difference
   minus_2        DWORD   ?
   minus_3        DWORD   ?
   minus_4        DWORD   ?
   minus_5        DWORD   ?
   minus_6        DWORD   ?
   minus_7        DWORD   ?
   minussigns     BYTE   " - ",0
   product_1      DWORD   ?  ; boolean to check for product
   product_2      DWORD   ?
   product_3      DWORD   ?
   product_4      DWORD   ?
   productsigns   BYTE   " * ",0
   quotient_1     DWORD   ?  ; boolean to check for quotient
   quotient_2     DWORD   ?
   quotient_3     DWORD   ?
   quotientsigns  BYTE   " / ",0
   remainder_1    DWORD   ?  ; boolean to check for remainder
   remainder_2    DWORD   ? 
   remainder_3    DWORD   ?
   remainderSigns BYTE   " ... ",0
   errormessage   BYTE   "ERROR: The numbers are not in descending order!", 0
   intro_3        BYTE   "Impressed?  Bye!",0


.code
startProgram:
main PROC
  ;print program title
   call CrLf
   mov   edx, OFFSET Title_1
   call  WriteString
  
  ;print name
   mov   edx, OFFSET userName
   call  WriteString
   call  CrLf

   ;print instructions
   mov   edx, OFFSET intro
   call  WriteString
   call  CrLf

   mov   edx, OFFSET intro_1
   call  WriteString
   call  CrLf
   mov   edx, OFFSET introduce_1
   call  WriteString
   call  CrLf
   mov   edx, OFFSET introduce_3
   call  WriteString
   call  CrLf
   mov   edx, OFFSET introduce_4
   call  WriteString
   call  CrLf

   ;enter first number
   call  CrLf
   mov   edx, OFFSET firstnumber
   call  WriteString
   ;read first number
   call  ReadInt
   mov   number_1, eax

   ;enter second number
   mov   edx, OFFSET secondnumber
   call  WriteString
   ;read second number
   call  ReadInt
   mov   number_2, eax

   ;enter third number
   mov   edx, OFFSET thirdnumber
   call  WriteString
   ;read third number
   call  ReadInt
   mov   number_3, eax
   mov   eax, number_3
   cmp   eax, number_2
   mov   eax, number_2
   cmp   eax, number_1
   jg    Error
   jle   Calculate

Error:
   ;error message
   mov   edx, OFFSET errormessage
   call  WriteString
   call  CrLf
   call  CrLf
   mov   edx, OFFSET intro_3
   call  WriteString
   call  CrLf
   ;jump to startProgram
   call  CrLf
   mov   edx, OFFSET introduce_1
   call  WriteString
   call  CrLf
   mov   edx, OFFSET introduce_2
   call  WriteString
   call  CrLf
   mov   edx, OFFSET introduce_4
   call  WriteString
   call  CrLf
   jg    startProgram
   call  CrLf
   call  CrLf

Calculate:
   ;find sum A+B
   mov   eax, number_1
   add   eax, number_2
   mov   plus_1, eax

   ;find difference A-B
   mov   eax, number_1
   sub   eax, number_2
   mov   minus_1, eax

   ;find sum A+C
   mov   eax, number_1
   add   eax, number_3
   mov   plus_2, eax

   ;find difference A-C
   mov  eax, number_1
   sub  eax, number_3
   mov  minus_2, eax

   ;find sum B+C
   mov  eax, number_2
   add  eax, number_3
   mov  plus_3, eax

   ;find difference B-C
   mov  eax, number_2
   sub  eax, number_3
   mov  minus_3, eax

   ;find sum A+B+C
   mov  eax, number_1
   add  eax, number_2
   add  eax, number_3
   mov  plus_4, eax

   ;find difference B-A
   mov  eax, number_2
   sub  eax, number_1
   neg  eax
   mov  minus_4, eax

   ;find difference C-A
   mov  eax, number_3
   sub  eax, number_1
   neg  eax
   mov  minus_5, eax

   ;find difference C-B
   mov  eax, number_3
   sub  eax, number_2
   neg  eax
   mov  minus_6, eax

   ;find difference C-B-A
   mov  eax, number_2
   sub  eax, number_3
   neg  eax
   sub  eax, number_1
   neg  eax
   mov  minus_7, eax

   ;find product B*A
   mov  eax, number_1
   mov  ebx, number_2
   mul  ebx
   mov  product_1, eax

   ;find product C*A
   mov  eax, number_1
   mov  ebx, number_3
   mul  ebx
   mov  product_2, eax

   ;find product C*B
   mov  eax, number_2
   mov  ebx, number_3
   mul  ebx
   mov  product_3, eax

   ;find product C*B*A
   mov  eax, number_1
   mov  ebx, number_2
   mul  ebx
   mov  ebx, number_3
   mul  ebx
   mov  product_4, eax

   ;find quotient and remainder A/B
   mov  edx, 0
   mov  eax, number_1
   cdq
   mov  ebx, number_2
   cdq
   div  ebx
   mov  quotient_1, eax
   mov  remainder_1, edx

   ;find quotient and remainder A/C
   mov  edx, 0
   mov  eax, number_1
   cdq
   mov  ebx, number_3
   cdq
   div  ebx
   mov  quotient_2, eax 
   mov  remainder_2, edx

   ;find quotient and remainder B/C
   mov  edx, 0
   mov  eax, number_2
   cdq
   mov  ebx, number_3
   cdq 
   div  ebx
   mov  quotient_3, eax
   mov  remainder_3, edx

   ;print the sum results A+B
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET Plussigns
   call WriteString
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, plus_1
   call WriteDec
   call CrLf

   ;print the difference results A-B
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, minus_1
   call WriteDec
   call CrLf
  
  ;print the sum results A+C
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET Plussigns
   call WriteString
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, plus_2
   call WriteDec
   call CrLf

  ;print the difference results A-C
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, minus_2
   call WriteDec
   call CrLf

   ;print the sum results B+C
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET Plussigns
   call WriteString
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, plus_3
   call WriteDec
   call CrLf

   ;print the difference results B-C
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, minus_3
   call WriteDec
   call CrLf

   ;print the sum results A+B+C
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET Plussigns
   call WriteString
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET Plussigns
   call WriteString
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, plus_4
   call WriteDec
   call CrLf

   ;print the difference results B-A
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, minus_4
   call WriteDec
   call CrLf

   ;print the difference results C-A
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, minus_5
   call WriteDec
   call CrLf

   ;print the difference results C-B
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, minus_6
   call WriteDec
   call CrLf

   ;print the difference results C-B-A
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  edx, OFFSET minussigns
   call WriteString
   mov  eax, minus_7
   call WriteDec
   call CrLf

   ;print the producte results B*A
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET productsigns
   call WriteString
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, product_1
   call WriteDec
   call CrLf

   ;print the producte results C*A
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET productsigns
   call WriteString
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, product_2
   call WriteDec
   call CrLf

   ;print the producte results C*B
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET productsigns
   call WriteString
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, product_3
   call WriteDec
   call CrLf

   ;print the producte results A*B*C
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET productsigns
   call WriteString
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET productsigns
   call WriteString
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, product_4
   call WriteDec
   call CrLf

   ;print the quotient and remainder results A/B
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET quotientsigns
   call WriteString
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, quotient_1
   call WriteDec
   mov  edx, OFFSET remaindersigns
   call WriteString
   mov  eax, remainder_1
   call WriteDec
   call CrLf

   ;print the quotient and remainder results A/C
   mov  eax, number_1
   call WriteDec
   mov  edx, OFFSET quotientsigns
   call WriteString
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, quotient_2
   call WriteDec
   mov  edx, OFFSET remaindersigns
   call WriteString
   mov  eax, remainder_2
   call WriteDec
   call CrLf
   
   ;print the quotient and remainder results B/C
   mov  eax, number_2
   call WriteDec
   mov  edx, OFFSET quotientsigns
   call WriteString
   mov  eax, number_3
   call WriteDec
   mov  edx, OFFSET equalsigns
   call WriteString
   mov  eax, quotient_3
   call WriteDec
   mov  edx, OFFSET remaindersigns
   call WriteString
   mov  eax, remainder_3
   call WriteDec
   call CrLf

endProgram:
   ; print the end
   call CrLf
   mov  edx, OFFSET intro_2
   call WriteString
   call CrLf

exit  
main ENDP
END main