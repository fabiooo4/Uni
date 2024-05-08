# Scrivere un programma Assembly che esegue la divisione intera tra due numeri decimali
# forniti come parametri della riga di comando e stampa il risultato a video.   

.section .text

  .global _start

_start:
  # Skip the number of parameters and the name of the program
  popl %esi
  popl %esi

  movl $2, %ecx # Count how many parameters to obtain
params:
  cmp $1, %ecx
  je secondParam

  popl %esi # Contains the parameter

secondParam:
  testl %esi, %esi # Checks if its 0 (NULL)
  jz end

  # If the parameter is not null convert it to integer and jump to the next one
  pushl %ecx # Save the counter
  call atoi
  popl %ecx # Retrieve the counter


  # If first parameter has already been obtained
  cmp $1, %ecx
  je skipPop
  # Retrieve the second parameter before pushing the first one to the stack
  popl %esi

skipPop:
  pushl %eax
  loop params

  popl %ebx # Divisor
  popl %eax # Dividend

  xorl %edx, %edx # Reset %edx for division
  divl %ebx # Divide %edx:%eax by %ebx

  # Print quotient in %eax
  call printInt

  end:
  movl $1, %eax
  xorl %ebx, %ebx
  int $0x80
