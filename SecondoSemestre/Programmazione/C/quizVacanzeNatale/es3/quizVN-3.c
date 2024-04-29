/* Scrivere un programma C non scomposto in funzioni in grado di:

1. leggere da tastiera una matrice m1 quadrata NxN di interi per righe.

2. Creare una matrice quadrata m2 di reali di dimensione NxN dove ciascun
elemento m2[i][j] è la media degli elementi validi intorno a/sul bordo di
quello m1[i][j], elemento m1[i][j] incluso. Nella media vanno considerati solo
gli elementi validi, ovvero quelli presenti in coordinate valide.

3. Stampare la matrice ottenuta visualizzando solo 2 cifre dopo la virgola e
lasciando uno spazio tra un numero e l’altro (usare printf("%.2f " , ...) ). */

#include <stdio.h>
#define N 3

int main() {
  int m1[N][N];
  float m2[N][N];

  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      scanf("%d", &m1[i][j]);
    }
  }

  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      int elements = 0;
      float sum = 0;
      for (int k = -1; k <= 1; k++) {
        for (int l = -1; l <= 1; l++) {
          if (i + k >= 0 && i + k < N && j + l >= 0 && j + l < N) {
            sum += m1[i + k][j + l];
            elements++;
          }
        }
      }
      m2[i][j] = sum / elements;
    }
  }

  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      printf("%.2f ", m2[i][j]);
    }
    printf("\n");
  }
}
