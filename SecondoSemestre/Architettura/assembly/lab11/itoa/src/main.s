# filename: main.s

.section .text

  .global _start

_start:

  movl $100, %eax     # Valore da convertire e stampare

  call itoa           # chiama la funzione itoa dal file itoa.s

  movl $1, %eax       # sys call exit
  xorl %ebx, %ebx
  int $0x80
