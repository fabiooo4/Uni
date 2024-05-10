.section .data
  fd: .int 0 # File descriptor
  paramError: .ascii "Nessun parametro fornito\n\0"
  fileError: .ascii "Errore nell'apertura del file\n\0"

.section .text

  .global _start

_start:
  popl %esi # Salta il numero di parametri
  popl %esi # Salta il nome del programma

  # Primo parametro
  popl %esi

  # Se il parametro non è vuoto apri il file
  testl %esi, %esi
  jz errorParam

  # Apri il file del parametro1
  movl $5, %eax   # Syscall open
  movl %esi, %ebx # Nome del file
  movl $0, %ecx   # Modalità lettura
  int $0x80

  # Se il file descriptor è null allora errore
  cmp $0, %eax
  jl errorFile

  movl %eax, fd

  # Il file descriptor si trova in %eax
  # Apre il loop del menu (presupponendo il file descriptor in %eax)
  call menu
  jmp end

errorParam:
  leal paramError, %ecx
  call printStr
  jmp end

errorFile:
  leal fileError, %ecx
  call printStr
  jmp end

end:
  # Chiudi il file aperto dal parametro1
  mov $6, %eax # syscall close
  mov fd, %ecx # File descriptor
  int $0x80

  # Termina
  movl $1, %eax
  movl $0, %ebx
  int $0x80
