/* Scrivere un programma che legge da tastiera una matrice di interi di
   dimensione 4X4 e stampa a video "1" se in ogni riga della matrice c'è almeno
   un numero pari, "0" altrimenti. */

#include <stdio.h>
#define SIZE 4

int main() {
  int m[SIZE][SIZE];
  int isEven;
  int flag = 1;

  // Input
  for (int i = 0; i < SIZE; i++) {
    for (int j = 0; j < SIZE; j++) {
      scanf("%d", &m[i][j]);
    }
  }

  for (int i = 0; i < SIZE && flag; i++) {
    isEven = 0;
    for (int j = 0; j < SIZE; j++) {
      if (m[i][j] % 2 == 0)
        isEven = 1;
    }
    if (!isEven)
      flag = 0;
  }

  if (isEven)
    printf("1\n");
  else
    printf("0\n");

  return 0;
}
