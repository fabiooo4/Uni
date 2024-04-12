# Scrivere un programma Assembly che calcoli il fattoriale di un 
# numero naturale letto da  tastiera e ne stampi il risultato a video.   

.section .data
  n:
  .long 3

  inputText:
  .ascii "Inserisci un numero naturale fino a 12: "
  inputTextLen:
  .long . - inputText

  resultText:
  .ascii "\nIl fattoriale è: "
  resultTextLen:
  .long . - resultText

  result:
  .ascii "\0\0\0\0\0\n"

.section .bss
  nStr:
  .string ""
  r:
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

  movl n, %eax
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

  # Terminate
  movl $1, %eax
  movl $0, %ebx
  int $0x80

