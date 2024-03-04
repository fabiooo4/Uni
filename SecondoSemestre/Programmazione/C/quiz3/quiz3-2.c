/* Scrivere un programma in C che chiede all'utente di inserire i dati interi di
una matrice quadrata di dimensione 4 e visualizza 1 se si tratta di una matrice
identità, altrimenti 0.

Una matrice quadrata è una matrice identità se ha il valore 1 sulla diagonale
principale, 0 altrove. */

#include <stdio.h>
#define SIZE 4

int main() {
  int m[SIZE][SIZE];
  int flag = 1;

  // Input
  for (int i = 0; i < SIZE; i++) {
    for (int j = 0; j < SIZE; j++) {
      scanf("%d", &m[i][j]);
    }
  }

  for (int i = 0; i < SIZE; i++) {
    for (int j = 0; j < SIZE; j++) {
      if (i == j && m[i][j] != 1)
        flag = 0;
      else if (i != j && m[i][j] != 0)
        flag = 0;
    }
  }

  if (flag)
    printf("1\n");
  else
    printf("0\n");

  return 0;
}
