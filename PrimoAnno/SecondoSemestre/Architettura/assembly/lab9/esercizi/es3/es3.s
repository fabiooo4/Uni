# Scrivere un programma Assembly che calcoli il fattoriale di un 
# numero naturale letto da  tastiera e ne stampi il risultato a video.   

.section .data
  inputText:
  .ascii "Inserisci un numero naturale fino a 6: "
  inputTextLen:
  .long . - inputText

  resultText:
  .ascii "\nIl fattoriale è: "
  resultTextLen:
  .long . - resultText

  result:
  .ascii "\0\0\0\0\0\n"
  resultLen:
    .long . - result
  resultOffset:
    .long . - resultLen

.section .bss
  nStr:
  .string ""

.section .text
.globl _start
  
_start:
  # Print input text
  movl $4, %eax # write
  movl $1, %ebx # stdout
  leal inputText, %ecx # string
  movl inputTextLen, %edx # string length
  int $0x80

  # Input number
  movl $3, %eax # read
  movl $0, %ebx # keyboard
  leal nStr, %ecx # destination address
  movl $9, %edx # string length
  int $0x80

  # Convert nStr to integer
  leal nStr, %esi
  # Reset registers
  movl $0, %eax
  movl $0, %ecx
  movl $0, %ebx

  nLoop:
  movb (%ecx,%esi,1), %bl # Load 1 byte from nStr into %bl using %ecx as offset
  cmp $10, %bl             # Check if the character "\n" is inside %bl
  je nEnd

  subb $48, %bl            # Converts ASCII to its integer number
  movl $10, %edx
  mulb %dl                # %ebx = %ebx * 10
  addl %ebx, %eax

  inc %ecx
  jmp nLoop 

  nEnd:
  movl %eax, %ecx

  factorial:
  cmp $0, %ecx
  je zero
  cmp $1, %ecx
  je endFactorial

  decl %ecx
  mull %ecx
  jmp factorial

  zero: # Base case
  movl $1, %eax

  endFactorial:
  # Result is in %eax

  # Convert the result into a string
  # Save memory address of the placeholder for the result
  leal result, %esi
  addl resultOffset, %esi
  movl resultLen, %ecx

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
  leal resultText, %ecx
  movl resultTextLen, %edx
  int $0x80

  # Print the result
  movl $4, %eax
  movl $1, %ebx
  leal result, %ecx
  movl resultLen, %edx
  int $0x80

  # Terminate
  movl $1, %eax
  movl $0, %ebx
  int $0x80
