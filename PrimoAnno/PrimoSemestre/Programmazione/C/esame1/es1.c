/* Scrivere un programma C non scomposto in funzioni in grado di:

- leggere da tastiera una matrice m1 quadrata NxN di interi per righe.
- Creare una matrice quadrata m2 di interi di dimensione NxN dove ciascun
elemento m2[i][j] è il numero degli elementi validi e diversi da zero intorno
a/sul bordo di quello m1[i][j], elemento m1[i][j] incluso. Nel calcolo del
numero di valori diversi da zero vanno considerati solo gli elementi validi,
ovvero quelli presenti in coordinate valide.
- Stampare la matrice m2 ottenuta stampando ogni intero in uno spazio di 3
caratteri (printf(”%3d”,...)). */

#include <stdio.h>
#define N 3
int main() {
  int m1[N][N];
  int m2[N][N];

  // Lettura
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      scanf("%d", &m1[i][j]);
    }
  }

  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      int sum = 0;

      // Sottomatrice quadrata di grandezza 3 che controlla il contorno di ogni
      // posizione ignorando i valori fuori dalla matrice originale
      for (int k = -1; k <= 1; k++) {
        for (int l = -1; l <= 1; l++) {
          if (i + k >= 0 && j + l >= 0 && i + k < N && j + l < N) {
            if (m1[i + k][j + l] != 0) {
              sum++;
            }
          }
        }
      }

      m2[i][j] = sum;
    }
  }

  // Stampa
  /* printf("m1:\n");
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      printf("%3d", m1[i][j]);
    }
    printf("\n");
  } */

  // printf("m2:\n");
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < N; j++) {
      printf("%3d", m2[i][j]);
    }
    printf("\n");
  }
}
