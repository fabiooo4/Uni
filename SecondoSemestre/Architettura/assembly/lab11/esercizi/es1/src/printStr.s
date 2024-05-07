.section .text
  .global printStr
  .type printStr, @function

# Print the string in %ecx
printStr:
  # Reset ecx to count how many characters to print
  xorl %edx, %edx

countChars:
  # Move the character at position %ecx + %edx to %al
  movb (%ecx,%edx), %al 

  # If the character is 0 stop counting
  testb %al, %al
  jz print

  # Increment %edx and loop to the next character
  incl %edx
  jmp countChars
  
print:
  movl $4, %eax
  movl $1, %ebx
  # %ecx contains the string to pring
  # %edx contains the length of the string
  int $0x80

  # Print the new line character
  # %eax contains the write interrupt id
  # %ebx contains the stdout id
  movl $10, %ecx
  movl $1, %edx
  int $0x80

  ret
