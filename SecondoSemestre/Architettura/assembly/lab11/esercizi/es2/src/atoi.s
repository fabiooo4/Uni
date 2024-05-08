.section .text
  .global atoi
  .type atoi, @function

# Convert an ascii string in %esi to int
atoi:
  xorl %eax, %eax
  xorl %ebx, %ebx
  xorl %ecx, %ecx

atoiLoop:
  # Move the character %esi + %ecx to %bl
  movb (%esi, %ecx), %bl

  # If the character is 0 return
  testb %bl, %bl
  jz atoiEnd

  # Subtract '0' from %bl (convert to int)
  subb $48, %bl

  # Multiply %eax by 10
  movb $10, %dl
  mulb %dl

  # Add converted char to %eax
  addl %ebx, %eax

  # Increment offset and loop to next char
  inc %ecx
  jmp atoiLoop

atoiEnd:
  # Result is in %eax
  ret
