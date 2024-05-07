# Scrivere un programma Assembly che esegue la divisione intera tra due numeri decimali
# forniti come parametri della riga di comando e stampa il risultato a video.   

.section .text

  .global _start

_start:
  # Skip the number of parameters and the name of the program
  popl %esi
  popl %esi

  movl $2, %ecx
params:
  popl %esi # Contains the parametar
  testl %esi, %esi # Checks if its 0 (NULL)
  jz end

  # If the parameter is not null convert it to integer and jump to the next one
  call atoi
  pushl %eax
  loop params

  popl %ebx # Divisor
  popl %eax # Dividend

  div %ebx # Divide %eax by %ebx
  xorb %ah, %ah # Discard remainder

  # Convert number in %eax to string
  call itoa TODO

  # Termina
  end:
  movl $1, %eax
  xorl %ebx, %ebx
  int $0x80
