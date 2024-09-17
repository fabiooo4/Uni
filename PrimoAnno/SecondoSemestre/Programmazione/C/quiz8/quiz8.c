/* Scrivere un programma che legge un array di 10 interi sicuramente positivi.
Il programma stampa, per ogni elemento dell'array il valore, 1 se è primo 0 se
non è primo, il numero dei suoi divisori (utilizzare printf("%d %d %d\n" ....).
Per verificare se un intero è primo o no e calcolare quanti sono i suoi divisori
utilizzare la funzione con prototipo

int verifica(int, int *);

che preso un intero come parametro, restituisce 1 se è primo, 0 se non è primo e
inserisce in un parametro passato per indirizzo il numero dei divisori */

#include <stdio.h>
#define DIM 10

int verifica(int, int *);

int main() {
  int a[DIM];

  for (int i = 0; i < DIM; i++) {
    int nDiv = 0;
    scanf("%d", &a[i]);
    int isPrime = verifica(a[i], &nDiv);
    printf("%d %d %d\n", a[i], isPrime, nDiv);
  }

  return 0;
}

int verifica(int num, int *nDiv) {
  for (int i = 1; i <= num; i++) {
    if (num % i == 0) {
      *nDiv += 1;
    }
  }

  if (*nDiv == 2)
    return 1;
  else
    return 0;
}
