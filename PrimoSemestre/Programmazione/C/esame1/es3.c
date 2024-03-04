/* Scrivere un programma che acquisisce un array di 10 numeri interi e un intero
 * n senz’altro positivo e strettamente <10. Il programma modifica l’array
 * facendo scorrere ogni intero di n posizioni a destra (gli ultimi n interi
 * vengono riportati all’inizio) e stampa l'array a video (usare "%d "). */

#include <stdio.h>
#define N 10

int main() {
  int src[N];
  int offset;

  // Input array
  for (int i = 0; i < N; i++)
    scanf("%d", &src[i]);

  // Input offset
  do {
    scanf("%d", &offset);
  } while (offset <= 0 || offset > N);

  for (int i = 0; i < offset; i++) {
    for (int j = N - 1; j >= 0; j--) {
      int prev = src[j];
      src[j] = src[j - 1];
      src[j - 1] = prev;
    }
  }

  for (int i = 0; i < N; i++) {
    printf("%d ", src[i]);
  }

  return 0;
}
