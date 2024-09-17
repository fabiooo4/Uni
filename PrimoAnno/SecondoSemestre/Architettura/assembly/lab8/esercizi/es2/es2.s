# Scrivere un programma Assembly che confronti 2 numeri caricati nei registri EAX ed EBX
# e stampi una stringa che indichi quale sia il maggiore ed il minore oppure indichi che i
# due numeri sono uguali.  

.section .data
numero1:
  .long 69 

numero2:
  .long 420 

uguali:
  .ascii "I due numeri sono uguali\n"
ugualiLen:
  .long . - uguali

primoMaggiore:
  .ascii " è maggiore di "
primoMaggioreLen:
  .long . - primoMaggiore

primoMinore:
  .ascii " è minore di "
primoMinoreLen:
  .long . - primoMinore

risultato:
  .ascii "000"
risultatoLen:
  .long . - risultato
risultatoOffset:
  .long . - risultatoLen - 2

lf:
  .long 10

.section .text
.global _start

_start:
  # Sposta i numeri nei registri
  movl numero1, %eax
  movl numero2, %ebx

  # Confronta i due numeri
  cmpl %eax, %ebx
  je uguale

  # Stampa il primo numero
  # Salva l'indirizzo di memoria del placeholder del risultato
  leal risultato, %esi
  addl risultatoOffset, %esi
  movl risultatoLen, %ecx

  # Converti il primo numero da intero a stringa e mettilo in risultato
convertiPrimo:
  movl $10, %ebx
  div %bl
  addb $48, %ah
  movb %ah, (%esi)
  xorb %ah, %ah
  decl %esi
  loop convertiPrimo

  # Stampa
  movl $4, %eax
  movl $1, %ebx
  leal risultato, %ecx
  movl risultatoLen, %edx
  int $0x80

  # Se maggiore stampa "maggiore di" altrimenti "minore di"
  movl numero2, %ebx
  cmpl numero1, %ebx
  jg stampaMinore
  # Stampa "maggiore di"
  movl $4, %eax
  movl $1, %ebx
  leal primoMaggiore, %ecx
  movl primoMaggioreLen, %edx
  int $0x80
  jmp stampaSecondo

  # Stampa "minore di"
stampaMinore:
  movl $4, %eax
  movl $1, %ebx
  leal primoMinore, %ecx
  movl primoMinoreLen, %edx
  int $0x80

  # Stampa il secondo numero
  # Salva l'indirizzo di memoria del placeholder del risultato
stampaSecondo:
  leal risultato, %esi
  addl risultatoOffset, %esi
  movl risultatoLen, %ecx

  # Converti il secondo numero da intero a stringa e mettilo in risultato
  movl numero2, %eax
convertiSecondo:
  movl $10, %ebx
  div %bl
  addb $48, %ah
  movb %ah, (%esi)
  xorb %ah, %ah
  decl %esi
  loop convertiSecondo

  # Stampa
  movl $4, %eax
  movl $1, %ebx
  leal risultato, %ecx
  movl risultatoLen, %edx
  int $0x80

  # A capo
  movl $4, %eax
  movl $1, %ebx
  leal lf, %ecx
  movl $1, %edx
  int $0x80

  jmp end

uguale:
  # Stampa: I numeri sono uguali
  movl $4, %eax
  movl $1, %ebx
  leal uguali, %ecx
  movl ugualiLen, %edx
  int $0x80
  
# Termina il programma
end:
  movl $1, %eax
  movl $0, %ebx
  int $0x80
