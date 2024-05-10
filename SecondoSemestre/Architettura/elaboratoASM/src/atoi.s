.section .text
  .global atoi
  .type atoi, @function

# Converti una stringa ascii situata in %esi in un intero
atoi:
  xorl %eax, %eax
  xorl %ebx, %ebx
  xorl %ecx, %ecx

atoiLoop:
  # Sposta il carattere %esi + %ecx in %bl
  movb (%esi, %ecx), %bl

  # Se il carattere è 0 return
  testb %bl, %bl
  jz atoiEnd

  # Sottrai '0' da %bl (converti in intero)
  subb $48, %bl

  # Moltiplica %eax per 10
  movb $10, %dl
  mulb %dl

  # Somma il carattere convertito a %eax
  addl %ebx, %eax

  # Incrementa l'offset e itera al carattere successivo
  inc %ecx
  jmp atoiLoop

atoiEnd:
  # Il risultato è in %eax
  ret
