/* Scrivere nel file il sottoprogramma

int higherdigit(int n, int m)

che ricevuti in ingresso due interi n e m non negativi, restituisce la cifra più
alta tra quelle presenti nei due numeri,
se i due numeri sono formati dallo stesso numero di cifre,  -1 altrimenti.
Ad esempio, se al sottoprogramma vengono passati in ingresso i numeri 31 e 421
esso restituirà -1, infatti 31
è composto i 2 cifre mentre 421 di 3; se al sottoprogramma vengono passati  in
ingresso i numeri 31 e 42 esso
restituirà 4, infatti i numeri sono di 2 cifre e la più alta che compare è 4. */

#include <stdio.h>
int higherdigit(int, int);
int main() {
  int a, b, r;

  do {
    scanf("%d", &a);
  } while (a < 0);
  do {
    scanf("%d", &b);
  } while (b < 0);

  r = higherdigit(a, b);

  printf("%d", r);

  return 0;
}

int higherdigit(int a, int b) {
  int digitsA = 0;
  int digitsB = 0;
  int digit = 0;
  int maxDigit = 0;
  int tmp = 0;

  tmp = a;
  while (tmp > 0) {
    digit = tmp % 10;
    tmp /= 10;

    if (digit > maxDigit)
      maxDigit = digit;

    digitsA++;
  }

  tmp = b;
  while (tmp > 0) {
    digit = tmp % 10;
    tmp /= 10;

    if (digit > maxDigit)
      maxDigit = digit;

    digitsB++;
  }

  if (digitsA == digitsB) {
    return maxDigit;
  } else {
    return -1;
  }
}
