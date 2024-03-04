/* Scrivere un programma C che:

- chiede all'utente di inserire da tastiera una matrice quadrata m di numeri
interi e dimensione NxN (con N pari a 3);

- modifica la matrice m inserendo come valori della diagonale principale la
somma dei valori della riga corrispondente.

- stampa la matrice risultante */

#include <stdio.h>
#define N 3

int main() {
  int m[N][N];
  int sum;

  // Input
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      scanf("%d", &m[i][j]);
    }
  }

  for (int i = 0; i < N; i++) {
    sum = 0;
    for (int j = 0; j < N; j++) {
      sum += m[i][j];
    }
    m[i][i] = sum;
  }

  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      printf("%3d ", m[i][j]);
    }
    printf("\n");
  }
}
