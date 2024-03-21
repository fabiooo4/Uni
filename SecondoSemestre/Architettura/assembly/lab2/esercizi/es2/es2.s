# Scrivere un programma Assembly che confronti 2 numeri caricati nei registri EAX ed EBX
# e stampi una stringa che indichi quale sia il maggiore ed il minore oppure indichi che i
# due numeri sono uguali.  

.section .data
numero1:
.long 69

numero2:
.long 420

numero:
  .ascii "Il numero "
numeroLen:
  .long . - numero

uguali:
  .ascii "I due numeri sono uguali\n"
ugualiLen:
  .long . - uguali

maggiore:
  .ascii " e' maggiore"
maggioreLen:
  .long . - maggiore

minore:
  .ascii " e' minore"
minoreLen:
  .long . - minore

risultato:
  .ascii "00000\n"

.section .text
.global _start

_start:
  # Sposta i numeri nei registri
  movl numero1, %eax
  movl numero2, %ebx

  # Confronta i due numeri
  cmpl %eax, %ebx
  je uguali
  jle 1minore2
  # Else: se il numero 1 è maggiore del numero 2
  # Stampa: Il numero 
  movl $4, %eax
  movl $1, %ebx
  leal numero, %ecx
  movl numeroLen, %edx
  int $0x80
  # Stampa: risultato
  # TODO

  # Stampa: e' maggiore

uguali:
  # Stampa: I numeri sono uguali
  movl $4, %eax
  movl $1, %ebx
  leal uguali, %ecx
  movl ugualiLen, %edx
  int $0x80

1minore2:
  movl $4, %eax
  movl $1, %ebx
  leal numero, %ecx
  movl numeroLen, %edx
  int $0x80

intStr:
  
