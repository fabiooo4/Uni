  # filename: readstr.s
#
# Read a string from keyboard and outputs the same string to video

.section .data

.section .bss          # Uninitialized data
	str: .string ""      # Buffer to store the string with unknown length

.section .text
	.global _start

_start:
	movl $3, %eax         # Set system call READ
	movl $0, %ebx         # | <- keyboard
	leal str, %ecx        # | <- destination
	movl $50, %edx        # | <- string length
	int $0x80             # Execute syscall

	movl $4, %eax	        # Set system call WRITE
	movl $1, %ebx	        # | <- standard output (video)
	leal str, %ecx        # | <- destination
	movl $50, %edx        # | <- length
	int $0x80             # Execute syscall

	movl $1, %eax         # Set system call EXIT
	xorl %ebx, %ebx       # | <- no error (0)
	int $0x80             # Execute syscall
