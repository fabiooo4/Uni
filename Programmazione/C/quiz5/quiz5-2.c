/* Si completi il programma in modo che dati in input da tastiera una matrice di
interi NxM (N righe, M colonne) e un numero l sicuramente maggiore di 0 e
sicuramente minore di N, stampi:

- OK se nella matrice esiste almeno una sequenza verticale di lunghezza almeno l
di elementi che crescono o decrescono linearmente (cioè in cui la differenza tra
due elementi successivi è costante).
- KO altrimenti.

Ad esempio, se l=3, nella matrice mostrata come esempio esiste nella terza
colonna una sequenza di 3 elementi (9,6,3) che decrescescono linearmente (la
differenza di ogni elemento dal successivo è 3). */

/*
3
0 3 -3
1 2 9
3 4 6
3 5 3
*/

#include <stdio.h>
#define M 3
#define N 4
int main() {
  int l;
  int m[N][M];
  int proprieta = 0;

  // Acquisizione dati
  scanf("%d", &l);
  while (l <= 0 || l > N)
    scanf("%d", &l);
  for (int i = 0; i < N; i++) {
    for (int j = 0; j < M; j++) {
      scanf("%d", &m[i][j]);
    }
  }

  // Verifica la proprietà
  if (l == 2 || l == 1) {
    proprieta = 1;
  }

  for (int i = 0; i < M && !proprieta; i++) {
    for (int j = 0; j < N - l + 1; j++) {
      for (int k = 0; k < l - 1; k++) {
        int diff = 0;
        for (int h = 0; h < l - 1; h++) {
          if (h > 0) {
            if (diff != m[j + k + h - 1][i] - m[j + k + h][i])
              break;
            if (h == l - 2)
              proprieta = 1;

            diff = m[j + h][i] - m[j + k][i];
          } else {
            diff = m[j + h][i] - m[j + k][i];
          }
        }
      }
    }
  }

  if (proprieta)
    printf("OK\n");
  else
    printf("KO\n");

  return 0;
}
