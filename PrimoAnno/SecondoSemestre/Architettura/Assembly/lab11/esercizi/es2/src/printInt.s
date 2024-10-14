.section .data
  char: .byte 0

.section .text
  .global printInt
  .type printInt, @function

# Convert an integer in %eax to a string
printInt:
  movl $10, %ebx # Divisor
  xorl %ecx, %ecx

  # If %eax is 0 print '0'
  testl %eax, %eax
  jnz divide

  push $48
  movl $1, %ecx
  jmp print

divide:
  xorl %edx, %edx
  # While %eax != 0 keep looping
  testl %eax, %eax
  jz print 

  # Divide %edx:%eax by %ebx (%eax <- quotient, %edx <- remainder)
  divl %ebx
  # Convert and save the remainder on the stack
  addl $48, %edx
  pushl %edx

  incl %ecx
  jmp divide

print:
  popl %edx
  movb %dl, char
  pushl %ecx

  # Syscall write
  movl $4, %eax
  movl $1, %ebx
  leal char, %ecx
  movl $1, %edx
  int $0x80
  
  popl %ecx
  loop print

  # Print the new line character
  movb $10, char

  movl $4, %eax
  movl $1, %ebx
  leal char, %ecx
  movl $1, %edx
  int $0x80
  
  ret
