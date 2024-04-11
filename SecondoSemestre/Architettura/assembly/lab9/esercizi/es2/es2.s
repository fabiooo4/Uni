# Modificare il programma dell’esercizio 1 affinché i due numeri vengano 
# letti da tastiera ed il risultato venga stampato a monitor.  

.section .data
  title:
    .ascii "Calcola l'MCD di due numeri\nInserisci il primo numero: "
  titleLen:
    .long . - title

  num2:
    .ascii "Inserisci il secondo numero: "
  num2Len:
    .long . - num2

  result:
    .ascii "\nL'MCD è: "
  resultLen:
    .long . - result

  resultText:
    .ascii "\nMCD: "
  resultTextLen:
    .long . - result


  mcd:
    .ascii "\0\0\0\0\0\n"
  mcdLen:
    .long . - mcd
  mcdOffset:
    .long . - mcdLen - 1

.section .bss
  aStr:
    .skip 5 # Reserve 5 bytes of memory
  bStr:
    .skip 5

.section .text
  .global _start

_start:
  # Print title
  movl $4, %eax # Write
  movl $1, %ebx # stdout
  leal title, %ecx # String address
  movl titleLen, %edx # String length
  int $0x80

  # Get first number input
  movl $3, %eax # Write
  movl $0, %ebx # Keyboard
  leal aStr, %ecx # Destination Address
  movl $7, %edx # String length
  int $0x80

  # Print second text
  movl $4, %eax
  movl $1, %ebx
  leal num2, %ecx
  movl num2Len, %edx
  int $0x80

  # Get second number input
  movl $3, %eax
  movl $0, %ebx
  leal bStr, %ecx
  movl $7, %edx
  int $0x80

  # Convert bStr to integer
  leal bStr, %esi
  # Reset registers
  movl $0, %eax
  movl $0, %ecx
  movl $0, %ebx

  bLoop:
  movb (%ecx,%esi,1), %bl # Load 1 byte from aStr into %bl using %ecx as offset
  cmp $10, %bl             # Check if the character "\n" is inside %bl
  je bEnd

  subb $48, %bl            # Converts ASCII to its integer number
  movl $10, %edx
  mulb %dl                # %ebx = %ebx * 10
  addl %ebx, %eax

  inc %ecx
  jmp bLoop 

  bEnd:
  movl %eax, %edi # Move the result of the conversion to %edi

  # Convert aStr to integer
  leal aStr, %esi
  # Reset registers
  movl $0, %eax
  movl $0, %ecx
  movl $0, %ebx

  aLoop:
  movb (%ecx,%esi,1), %bl # Load 1 byte from aStr into %bl using %ecx as offset
  cmp $10, %bl             # Check if the character "\n" is inside %bl
  je aEnd

  subb $48, %bl            # Converts ASCII to its integer number
  movl $10, %edx
  mulb %dl                # %ebx = %ebx * 10
  addl %ebx, %eax

  inc %ecx
  jmp aLoop 

  aEnd:
  # Result of a conversion is already in %eax
  movl %edi, %ebx

  # At this point %eax = a, %ebx = b

  cmp $0, %eax    # if a == 0 check if b ==0
  jne elseifb0

  cmp $0, %ebx    # if b == 0
  jne elseifb0

  movl $1, %ebx   # if a = 0 and b = 0, b = 1
  jmp endWhile         # exit if

  elseifb0:       # if b == 0 enter the loop, else check if a == 0
  cmp $0, %ebx
  jne elseifa0

  movl %eax, %ebx # if b == 0, b = a
  jmp endWhile

  elseifa0:       # if a == 0 enter the loop
  cmp $0, %eax
  je endWhile

  while:
  cmp %eax, %ebx  # if a != b, keep looping
  je endWhile 

  jl alb          # if a < b, b = b - a
  sub %eax, %ebx  # else a = a - b
  jmp while

  alb:
  sub %ebx, %eax

  cmp %eax, %ebx  # if a != b, keep looping
  jne while

  endWhile:
  movl %ebx, %ecx # put result in %ecx

  # Convert the result into a string
  # Save memory address of the placeholder for the result
  leal mcd, %esi
  addl mcdOffset, %esi
  movl %ecx, %eax # Dividend

  movl mcdLen, %ecx

  resultStr:
  movl $10, %ebx # Divisor
  div %bl # Quotient in %al, Remainder in %ah
  
  addb $48, %ah
  movb %ah, (%esi)
  xorb %ah, %ah
  decl %esi
  cmp $0, %al
  je end
  loop resultStr

  end:
  # Print the result text
  movl $4, %eax
  movl $1, %ebx
  leal result, %ecx
  movl resultLen, %edx
  int $0x80

  # Print the result
  movl $4, %eax
  movl $1, %ebx
  leal mcd, %ecx
  movl mcdLen, %edx
  int $0x80

  # Terminate
  movl $1, %eax
  movl $0, %ebx
  int $0x80
