.section .data

titolo:
  .ascii "Programma per calcolare quante auto servono\n"

titoloLen:
  .long . - titolo # Lunghezza del titolo

testo:
  .ascii "Totale auto richieste: "

testoLen:
  .long . - testo # Lunghezza del testo

numPersone:
  .long 152 # Numero di persone

personePerAuto:
  .long 5 # Numero di persone per auto

numAuto:
  .ascii "000\n" # Variabile ASCII che conterra' il numero di auto

.section .text
  .globl _start

_start:
  movl numPersone, %eax # Carica il numero di persone in %eax
  movl personePerAuto, %ebx # Carica il numero di persone per auto in %ebx
  div %bl # Prende eax e lo divide per src, il quoziente sara' in %al e il resto in %ah
  cmpb $0, %ah # Compara il resto con 0
  je continuazione # Se il resto e' 0, salta a continuazione
  # Se il resto non e' 0, incrementa il numero di macchine
  incb %al # Incrementa di 1 il numero di macchine
  xorb %ah, %ah # Azzera il registro ah

continuazione: # Etichetta per il ciclo con il resto gia' gestito
  # Il valore numerico del risultato è salvato in AL
  # Bisogna convertirlo in ASCII
  leal numAuto, %esi # Carica l'indirizzo di numAuto in %esi
  addl $2, %esi # La prima cifra della stringa che verrà modificata e' la terza 
  movl $10, %ebx # Carica 10 in %ebx usato come divisore
  movl $3, %ecx # Carica 3 in %ecx, usato come contatore

inizioCiclo:
  div %bl # Dividi il numero di macchine per 10, quoziente in %al, resto in %ah
  addb $48, %ah # Aggiungi 48 al resto per convertirlo in ASCII
  movb %ah, (%esi) # Salva il resto in %esi
  xorb %ah, %ah # Azzera il registro %ah
  decl %esi # Decrementa %esi per passare alla cifra successiva
  loop inizioCiclo # Ripeti il ciclo finche' %ecx non e' 0

# Stampa a video il tutolo
movl $4, %eax # Carica 4 in %eax, il codice per la system call write
movl $1, %ebx # Carica 1 in %ebx, il file descriptor per stdout
leal titolo, %ecx # Carica l'indirizzo di titolo in %ecx
movl titoloLen, %edx # Carica la lunghezza di titolo in %edx
int $0x80 # Esegue la system call tramite un interrupt

# Stampa a video il testo
movl $4, %eax
movl $1, %ebx
leal testo, %ecx
movl testoLen, %edx
int $0x80

# Stampa a video il numero di auto
movl $4, %eax
movl $1, %ebx
leal numAuto, %ecx
movl $4, %edx
int $0x80

# Termina il programma
movl $1, %eax # Carica 1 in %eax, il codice per la system call exit
movl $0, %ebx # Carica 0 in %ebx, il codice di uscita
int $0x80 # Esegue la system call tramite un interrupt
