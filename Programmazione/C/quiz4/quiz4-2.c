/* Si completi il programma in modo che dato in input da tastiera un numero n
 * sicuramente maggiore di 0, stampi a video 1 se nella matrice di interi NxM
 * inserita da tastiera tutte le sottomatrici quadrate di dimensione n hanno la
 * moltiplicazione di tutti gli elementi uguale a 0. In caso contrario verrà
 * stampato a video 0. */

#include <stdio.h>
#define M 3
#define N 4

int main() {
  int n;
  int m1[M][N];
  int proprieta = 1;
  int mul;
  int prevMul;

  // Acquisizione dati
  scanf("%d", &n);
  while (n <= 0)
    scanf("%d", &n);

  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      scanf("%d", &m1[i][j]);
    }
  }

  // verifica la proprietà
  for (int i = 0; i < M - n + 1; i++) {
    for (int j = 0; j < N - n + 1; j++) {
      mul = 1;
      for (int l = 0; l < n; l++) {
        for (int k = 0; k < n; k++) {
          mul *= m1[l][k];
        }
      }
      printf("%d ", mul);
      prevMul = mul;
    }
  }

  printf("%d\n", proprieta);
}
