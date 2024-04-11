# Scrivere il programma Assembly equivalente al seguente algoritmo C per il calcolo del
# massimo comune divisore (MCD) di due numeri naturali. Si assuma che i parametri a e
# b siano nei registri EAX ed EBX, mentre il valore di ritorno deve essere memorizzato in
# ECX. Verificarne il funzionamento con il debugger.
# unsigned int MCD(unsigned int a, unsigned int b) {
#  if (a==0 && b==0)
#    b=1;
#  else if (b==0)
#    b=a;
#  else if (a!=0)
#    while (a!=b)
#      if (a<b)
#        b = b - a;
#      else
#        a = a - b;
#
#  return b;
# }

.section .data
  a:
    .long 12
  b:
    .long 12

.section .text
  .global _start

_start:
  movl a, %eax
  movl b, %ebx

  cmp $0, %eax    # if a == 0 check if b ==0
  jne elseifb0

  cmp $0, %ebx    # if b == 0
  jne elseifb0

  movl $1, %ebx   # if a = 0 and b = 0, b = 1
  jmp end         # exit if

  elseifb0:       # if b == 0 enter the loop, else check if a == 0
  cmp $0, %ebx
  jne elseifa0

  movl %eax, %ebx # if b == 0, b = a
  jmp end

  elseifa0:       # if a == 0 enter the loop
  cmp $0, %eax
  je end

  while:
  cmp %eax, %ebx  # if a != b, keep looping
  je end 

  jl alb          # if a < b, b = b - a
  sub %eax, %ebx  # else a = a - b
  jmp while

  alb:
  sub %ebx, %eax

  cmp %eax, %ebx  # if a != b, keep looping
  jne while

  end:
  movl %ebx, %ecx # put result in %ecx

  movl $1, %eax
  movl $0, %ebx
  int $0x80
