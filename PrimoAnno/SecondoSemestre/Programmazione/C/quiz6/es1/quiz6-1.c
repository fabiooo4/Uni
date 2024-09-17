/* Scrivere un programma C in grado di acquisire da tastiera un array di 8
interi strettamente positivi. Il programma sostituirà ogni elemento dell'array
con la sua cifra più significativa e stamperà a video l'array ottenuto.

Ad esempio se l'input fosse 34 54  5 6 15 67 44 1 l'output sarà 3,5,5,6,1,6,4,1
(separare i numeri con una virgola). */

#include <stdio.h>
#define D 8

int msDigit(int);

int main() {
  int a[D];

  for (int i = 0; i < D; i++) {
    scanf("%d", &a[i]);
  }

  for (int i = 0; i < D; i++) {
    if (i == 0)
      printf("%d", msDigit(a[i]));
    else
      printf(",%d", msDigit(a[i]));
  }

  return 0;
}

int msDigit(int n) {
  int digit = 0;
  while (n > 0) {
    digit = n % 10;
    n = n / 10;
  }

  return digit;
}
