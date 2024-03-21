# Scrivere un programma Assembly che sommi i numeri 100, 33 e 68 e metta il risultato in  una variabile
# chiamata “somma”. Stampare a monitor il risultato.  
.section .data

titolo:
  .ascii "100 + 33 + 68 = "
titoloLen:
  .long . - titolo

risultato:
  .ascii "000\n"

somma:
  .long 0

.section .text
  .global _start

_start:
  # Esegue la somma e la mette nella variabile somma
  movl $0, %eax
  addl $100, %eax
  addl $33, %eax
  addl $68, %eax
  movl %eax, somma

  # Mette in %esi l'indirizzo di memoria dell'ultima cifra del placeholder del risultato e in %ecx il contatore
  leal risultato, %esi 
  addl $2, %esi 
  movl $3, %ecx 

# Itera ogni cifra del risultato e la aggiunge alla stringa risultato trasformando la cifra in ASCII
ciclo:
  movl $10, %ebx
  div %bl
  addb $48, %ah
  movb %ah, (%esi)
  xorb %ah, %ah
  decl %esi
  loop ciclo
 
# Stampa a video il titolo
movl $4, %eax
movl $1, %ebx
leal titolo, %ecx
movl titoloLen, %edx
int $0x80

# Stampa a video il risultato
movl $4, %eax
movl $1, %ebx
leal risultato, %ecx
movl $4, %edx
int $0x80

# Termina il programma
movl $1, %eax
movl $0, %ebx
int $0x80
