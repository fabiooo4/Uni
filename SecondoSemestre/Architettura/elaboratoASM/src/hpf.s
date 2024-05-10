.section .data
  fd: .int 0          # File descriptor
  buffer: .string ""  # Spazio per il buffer di input
  newline: .byte 10   # Valore del simbolo di nuova linea
  values: .int 0      # Numero di valori inseriti nello stack
  lines: .long 0      # Numero di valori inseriti nello stack
  concatenate: .string ""  # Stringa per concatenare le cifre lette da file

.section .bss

.section .text
    .globl hpf
    .type hpf, @function

# Apre il file
hpf:
  # Salva ebp nello stack per liberare %esp
  pushl %ebp 
  movl %esp, %ebp

  # Vai 2 posti indietro nello stack (1 call + 1 push)
  addl $8, %ebp
  movl (%ebp), %ebx  # Ottiene il file descriptor passato dal menu
  movl %ebx, fd      # e lo sposta in fd

  popl %ebp # Ripristina %ebp

# Legge il file riga per riga
xorl %edi, %edi
readLine:
  mov $3, %eax       # syscall read
  mov fd, %ebx       # File descriptor
  mov $buffer, %ecx  # Buffer di input
  mov $1, %edx       # Lunghezza massima
  int $0x80           

  # Se ci sono errori o EOF esco dalla funzione
  cmp $0, %eax
  jle endHpf
  
  # Se c'è una nuova linea incrementa il contatore
  movb buffer, %al
  cmpb newline, %al
  jne pushInt 
  incw lines

# Se il carattere è un intero convertilo
pushInt:
  # Se il carattere non è una virgola, aggiungilo alla fine della stringa concatenate
  movb buffer, %al

  # if buffer == '\n' || buffer == ',' push, else appenb
  cmpb $10, %al
  je push

  cmpb $44, %al
  jne append

push:
  # Se il carattere è una virgola resetta il contatore
  xorl %edi, %edi

  # Incrementa il contatore dei valori inseriti nello stack
  incw values

  # Converti la stringa in intero
  leal concatenate, %esi
  call atoi
  # Il risultato è in %eax

  # Inserisci nello stack
  pushl %eax

  # Resetta la stringa concatenate 
  movl $0, concatenate

  jmp readLine # Torna alla lettura del file

append:
  # Il carattere viene aggiunto a %ebx + %edi
  leal concatenate, %ebx
  movb %al, (%ebx, %edi)
  incl %edi

  jmp readLine # Torna alla lettura del file

endHpf:
  ret
