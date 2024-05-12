.section .data
  values: .int 0      # Numero di valori inseriti nello stack
  lines: .long 0      # Numero di valori inseriti nello stack
  swapFlag: .byte 0   # Flag per segnare se è stato effettuato uno scambio

.section .text
  .global bubbleSort
  .type bubbleSort, @function

# %ecx offset parametri
# %edx numero valori
# %edi numero di righe nel file
# %esi fallback parametri
bubbleSort:
  # Salva ebp nello stack per liberare %esp
  pushl %ebp 
  movl %esp, %ebp

  # Vai 2 posti indietro nello stack (1 call + 1 push)
  addl $8, %ebp

# Salva numero valori e numero righe in .data
  movl %edx, values
  movl %edi, lines

# Sposta %edx alla colonna di parametri scelta dall'offset
  subl %ecx, %edx

# Reset flag
flag:
  movl $0, swapFlag
  movl lines, %edi

bubbleLoop:
  decl %edi

  # Se abbiamo controllato tutte le righe controlla se la lista è ordinata
  cmpl $0, %edi
  je isOrdered

  movl (%ebp, %edx, 4), %eax  # Parametro 1
  subl $4, %edx
  movl (%ebp, %edx, 4), %ebx  # Parametro 2

  # Se viene usato hpf (%ecx != 3) ordina decrescente
  cmp $3, %ecx
  jne descending

  # Se viene usato edf (%ecx = 3) ordina crescente
  cmp %ebx, %eax
  jg swap

  descending:
  cmp %ebx, %eax
  jl swap

  # Se a == b usa parametri fallback
  je fallback

  jmp bubbleLoop

fallback:
  # Salva i registri
  pushl %esi
  pushl %ecx
  pushl %edx

  # Sposta %edx una riga indietro per leggere il primo parametro
  addl $4, %edx

  # Sposta %edx alla colonna di parametri scelta dal fallback
  subl %esi, %ecx
  addl %ecx, %edx

  # Leggi i parametri
  movl (%ebp, %edx, 4), %eax  # Parametro 1
  subl $4, %edx
  movl (%ebp, %edx, 4), %ebx  # Parametro 2

  # Carica i registri
  popl %esi
  popl %ecx
  popl %edx

  # Se viene usato edf (%ecx = 3) ordina crescente
  cmp $3, %ecx
  jne fallbackDescending

  cmp %ebx, %eax
  jl swap

  fallbackDescending:
  # Se viene usato hpf (%ecx != 3) ordina decrescente
  cmp %ebx, %eax
  jg swap

  jmp bubbleLoop


# Scambia il parametro1(%eax) con parametro2(%ebx)
swap:
  # Salva i registri
  pushl %ecx
  pushl %esi
  pushl %edx
  pushl %edi

  movl $1, swapFlag
  # call swapOrders

  # Carica i valori
  popl %ecx
  popl %esi
  popl %edx
  popl %edi

  jmp bubbleLoop

isOrdered:
  # Se non è stato effettuato nessuno swap allora la lista è ordinata
  cmpl $1, swapFlag
  jne return

  jmp flag

return:
  popl %ebp # Ripristina %ebp

  # Lo stack sarà ordinato in base al valore scelto da %ecx
  ret
