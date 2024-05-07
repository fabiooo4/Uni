# Scrivere un programma che recupera e stampa i parametri della riga di comando. Usare
# l’istruzione POP per estrarre i parametri dallo stack, invece di manipolare il valore dei
# registri ESP ed EBP manualmente come effettuato nell’esempio precedente.

.section .text

  .global _start

_start:
  # Skip the number of parameters and the name of the program
  popl %ecx
  popl %ecx

params:
  popl %ecx # Contains the parametar
  testl %ecx, %ecx # Checks if its 0 (NULL)
  jz end

  # If the parameter is not null print it and jump to the next one
  call printStr
  jmp params

  # Termina
  end:
  movl $1, %eax
  xorl %ebx, %ebx
  int $0x80
