/* Scrivere un programma che legge da tastiera una sequenza di numeri interi
 * positivi (non serve correggere l'errore di input dell'utente) che finisce con
 * -1 (sentinella) e stampa a video la cifra meno significativa, solo se pari,
 * di ogni numero. Ogni cifra va seguita da un'andata a capo. */

#include <stdio.h>

int main() {
  int n;

  do {
    scanf("%d", &n);
    if (n % 2 == 0) {
      printf("%d\n", n % 10);
    }
  } while (n != -1);

  return 0;
}
