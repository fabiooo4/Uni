.section .data
  fd: .int 0          # File descriptor
  buffer: .string ""  # Spazio per il buffer di input
  newline: .byte 10   # Valore del simbolo di nuova linea
  values: .int 0      # Numero di valori inseriti nello stack
  lines: .long 0      # Numero di valori inseriti nello stack
  concatenate: .string ""  # Stringa per concatenare le cifre lette da file

.section .bss

.section .text
    .globl edf
    .type edf, @function

# Pianifica per primi gli ordini con scadenza minore
# Se la scadenza è uguale va prima quello con priorità più alta
edf:
  # Salva ebp nello stack per liberare %esp
  pushl %ebp 
  movl %esp, %ebp

  # Vai 2 posti indietro nello stack (1 call + 1 push)
  addl $8, %ebp
  movl (%ebp), %ebx  # Ottiene il file descriptor passato dal menu
  movl %ebx, fd      # e lo sposta in fd

  popl %ebp # Ripristina %ebp

  xorl %edi, %edi

  # Resetta il numero di valori e di linee letti
  movl $0, values
  movl $0, lines

  # Siccome il file è già stato aperto nel main e questa potrebbe non essere la
  # prima volta che viene letto bisogna "resettare" la posizione di lettura all'inizio
  # del file ogni volta che si vuole leggere da esso
  mov $19, %eax  # syscall lseek (riposizione il read/write offset)
  mov fd, %ebx   # File descriptor
  mov $0, %ecx   # Valore di offset
  mov $0, %edx   # Posizione di riferimento (0 = inizio del file)
  int $0x80

# Legge il file riga per riga
readLine:

  # Lettura di 1 byte alla volta (1 carattere)
  mov $3, %eax       # syscall read
  mov fd, %ebx       # File descriptor
  mov $buffer, %ecx  # Buffer di input
  mov $1, %edx       # Lunghezza massima
  int $0x80           

  # Se ci sono errori esco dalla funzione
  cmp $0, %eax
  jl endEdf

  # Altrimenti se c'è EOF eseguo l'algoritmo
  je edfAlgorithm
  
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


edfAlgorithm:

  # Riordina lo stack in base ad un offset messo in %ecx e il numero di valori in %edx
  # %ecx/$esi <- 1 = identificativo
  # %ecx/$esi <- 2 = durata
  # %ecx/$esi <- 3 = scadenza
  # %ecx/$esi <- 4 = priorità
  # Fallback in %esi nel caso a = b (nel caso di edf sarebbe la priorità se 2 scadenze sono uguali)
  # Numero di righe in %edi
  movl $3, %ecx
  movl $4, %esi
  movl values, %edx
  movl lines, %edi
  call bubbleSort

  # Stack ordinato

#   # Salva %ebp nello stack per liberare %esp
#   pushl %ebp
#   movl %esp, %ebp
#
#   # Metti il numero di valori come offset
#   movl values, %ecx
#   # movl %ecx, %edx
#   # subl $2, %edx # Per ottenere la scadenza
#   
#   # Resetta i registri
#   xorl %eax, %eax
#   xorl %ebx, %ebx
#
#   subl $2, %ecx
#
# # Stampa tutti i valori nello stack
# loopValues:
#   # Legge un valore alla volta dallo stack v[n] n = values - %ecx
#   movb (%ebp, %ecx, 4), %al
#
#   pushl %ecx
#   call printInt
#   popl %ecx
#
#   # decl %ecx
#   subl $4, %ecx
#
#   cmp $0, %ecx
#   jge loopValues
#
#   # Ripristina %ebp
#   popl %ebp
#
#   movl values, %ecx

# Togli dallo stack tutti i valori
  movl values, %ecx
popInt:
  popl %eax
  loop popInt

endEdf:
  ret
