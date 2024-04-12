# Scrivere un programma Assembly che calcoli il fattoriale di un 
# numero naturale letto da  tastiera e ne stampi il risultato a video.   

.section .data
  n:
  .long 2

  resultText:
  .ascii "Il fattoriale è: "
  resultTextLen:
  .long . - resultText

  result:
  .ascii "\0\0\0\0\0\n"

.section .bss
  nStr:
  .string ""

.section .text
.globl _start
  
  movl n, %eax
  movl %eax, %ecx

  factorial:
  decl %ecx
  mulb %ecx

_start:
