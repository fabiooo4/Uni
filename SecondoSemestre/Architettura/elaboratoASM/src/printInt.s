.section .data
  char: .byte 0

.section .text
  .global printInt
  .type printInt, @function

# Converte un intero che si trova in %eax in una stringa
printInt:
  movl $10, %ebx # Divisor
  xorl %ecx, %ecx

  # Se %eax è 0 stampa '0'
  testl %eax, %eax
  jnz divide

  push $48
  movl $1, %ecx
  jmp print

divide:
  xorl %edx, %edx
  # Mentre %eax != 0 continua a iterare
  testl %eax, %eax
  jz print 

  # Divide %edx:%eax per %ebx (%eax <- quoziente, %edx <- resto)
  divl %ebx
  # Converti e salva il resto sullo stack
  addl $48, %edx
  pushl %edx

  # Incrementa il numero di cifre
  incl %ecx
  jmp divide

print:
  # Ottiene i caratteri dallo stack e li stampa
  popl %edx
  movb %dl, char
  pushl %ecx

  # Syscall write
  movl $4, %eax
  movl $1, %ebx
  leal char, %ecx
  movl $1, %edx
  int $0x80
  
  popl %ecx
  loop print

  # Stampa il carattere '\n'
  movb $10, char

  movl $4, %eax
  movl $1, %ebx
  leal char, %ecx
  movl $1, %edx
  int $0x80
  
  ret
