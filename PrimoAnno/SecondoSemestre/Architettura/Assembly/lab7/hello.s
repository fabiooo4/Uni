# Nome file
# ----------
# hello.s
# 
# Istruzioni per la compilazione
# ------------------------------
# as -o hello.o hello.s
# ld -o hello hello.o
# 
# Funzionalita'
# -------------
# Stampa a video la scritta "Hello, World!" e va a capo
# 
# Commenti
# --------
# Il carattere # indica l'inizio di un commento.

# http://asm.sourceforge.net/syscall.html


.section .data                 #sezione variabili globali

hello:                         #etichetta
      .ascii "Hello, World!\n" #stringa costante

hello_len:
      .long . - hello          #lunghezza della stringa in byte

.section .text                 #sezione istruzioni
      .global _start           #punto di inizio del programma

_start:
      movl $4, %eax            #Carica il codice della system call WRITE
                               #in eax per scrivere la stringa
                               #”Hello, World!” a video.
      
      movl $1, %ebx            #Mette a 1 il contenuto di EBX
                               #Quindi ora EBX=1. 1 è il
                               #primo parametro per la write e
                               #serve per indicare che vogliamo
                               #scrivere nello standard output

      leal hello, %ecx         #Secondo parametro dell write
                               #Carica in ECX l’indirizzo di
                               #memoria associato all’etichetta
                               #hello, ovvero il puntatore alla
                               #stringa “Hello, World!\n” da stampare.

      movl hello_len, %edx     #Terzo parametro della write
                               #carica in EDX la lunghezza della
                               #stringa “Hello, World!\n”.

      int $0x80                #esegue la system call write
                               #tramite l’interrupt 0x80


      movl $1, %eax            #Mette a 1 il registro EAX
                               #1 è il codice della system call exit
      
      xorl %ebx, %ebx          #azzera EBX. Contiene il codice di
                               #ritorno della exit

      int $0x80                #esegue la system call exit

