/* Scrivere un programma che legge da tastiera un array di 10 interi e determina
la sotto sequenza di valori uguali di lunghezza massima. Il programma deve
stampare a video la lunghezza di tale sotto sequenza, l'indice della posizione
iniziale e finale (separati solo da uno spazio). Se nell'array ci sono più sotto
sequenze ripetute di lunghezza massima, stamperà a video i dati della prima.

Ad esempio, se l'array fosse 1 2 3 3 3 3 6 7 2 3  stamperà a
video 4 2 5 (esiste una sottosequenza di 4 valori uguali che inizia all'indice 2
e finisce all'indice 5). */

#include <stdio.h>

#define DIM 10

int main() {
  int a[10];
  int maxSubCount = 0;
  int maxBeg = 0;
  int maxEnd = 0;

  // Input
  for (int i = 0; i < DIM; i++) {
    scanf("%d", &a[i]);
  }

  for (int i = 0; i < DIM; i++) {
    int subCount = 1;
    int begSub = 0;
    int endSub = 0;
    if (i < DIM - 1 && a[i] == a[i + 1]) {
      begSub = i;
      for (int j = i; j < DIM; j++) {
        if (a[j] == a[j + 1]) {
          subCount++;
          endSub = j + 1;
        }
      }
    }

    if (subCount > maxSubCount) {
      maxSubCount = subCount;

      if (begSub > maxBeg)
        maxBeg = begSub;

      if (endSub > maxEnd)
        maxEnd = endSub;
    }
  }

  printf("%d %d %d\n", maxSubCount, maxBeg, maxEnd);

  return 0;
}
