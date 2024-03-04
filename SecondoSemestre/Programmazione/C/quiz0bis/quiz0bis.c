/*
Scrivere un programma che legge 3 numeri interi da tastiera sicuramente compresi
tra 0 e 6, estremi inclusi (non serve correggere errori in input dell'utente).
Il programma stampa a video:

- il più piccolo tra i pari inseriti, NO se non esiste
- in una nuova riga il più grande dei dispari inseriti, NO se non esiste
*/

#include <stdio.h>

#define INT_MAX 2147483647
#define INT_MIN -2147483648

int main() {
  int n;
  int minPari = INT_MAX;
  int maxDispari = INT_MIN;

  scanf("%d", &n);
  if (n % 2 == 0) {
    minPari = n;
  } else {
    maxDispari = n;
  }

  scanf("%d", &n);
  if (n % 2 == 0 && n < minPari) {
    minPari = n;
  } else if (n % 2 != 0 && n > maxDispari) {
    maxDispari = n;
  }

  scanf("%d", &n);
  if (n % 2 == 0 && n < minPari) {
    minPari = n;
  } else if (n % 2 != 0 && n > maxDispari) {
    maxDispari = n;
  }

  if (minPari != INT_MAX) {
    printf("%d\n", minPari);
  } else {
    printf("NO\n");
  }

  if (maxDispari != INT_MIN) {
    printf("%d\n", maxDispari);
  } else {
    printf("NO\n");
  }

  return 0;
}
