/* Si completi il file scrivendo la funzione

- conta che data una matrice rettangolare 7x6 composta di soli numeri 0 e 1
restituisce l’indice della prima colonna con la più lunga sequenza di valori 1
consecutivi, −1 se nella matrice non sono presenti valori 1. */

#include <stdio.h>
#include <stdlib.h>

#define RIGHE 7
#define COL 6

// prototipi
int conta(int mat[RIGHE][COL]);

int main(void) {
  int M[RIGHE][COL];

  for (int i = 0; i < RIGHE; i++)
    for (int j = 0; j < COL; j++)
      scanf("%d", &M[i][j]);

  int c = conta(M);
  printf("%d", c);

  return (0);
}

/* la funzione restituisce l'indice della prima colonna con il maggior numero di
 * 1 consecutivi, -1 se non esiste */

int conta(int mat[RIGHE][COL]) {
  int maxSum = 0;
  int max = 0;
  int colIdx = -1;

  for (int i = 0; i < RIGHE; i++) {
    int sum = 0;
    for (int j = 0; j < COL; j++) {
      int prevSum = sum;
      sum += mat[j][i];

      if (prevSum != sum - 1) {
        sum = 0;
      }

      if (sum > maxSum) {
        maxSum = sum;
      }
    }

    if (maxSum > max) {
      max = maxSum;
      colIdx = i;
    }
  }

  return colIdx;
}
