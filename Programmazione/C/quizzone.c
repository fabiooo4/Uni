// Scrivere un programma che dato un array  di caratteri lungo 8 (con i valori
// letti da standard input) lo stampa, LO INVERTE, lo stampa invertito,
// sostituisce ogni vocale minuscola con un '*'
#include <stdio.h>

#define DIM 8

int main() {
  char array[DIM];
  char trash;

  for (int i = 0; i < DIM; i++) {
    scanf("%c", &array[i]);
    scanf("%c", &trash);
  }

  // Prima stampa
  for (int i = 0; i < DIM; i++) {
    printf("%c", array[i]);
  }
  printf("\n");

  // Inversione
  for (int i = 0; i < DIM / 2; i++) {
    char tmp = array[i];
    array[i] = array[DIM - i - 1];
    array[DIM - i - 1] = tmp;
  }

  // Stampa inverso
  for (int i = 0; i < DIM; i++) {
    printf("%c", array[i]);
  }
  printf("\n");

  // Da vocale a *
  for (int i = 0; i < DIM; i++) {
    if (array[i] == 'a' || array[i] == 'e' || array[i] == 'i' ||
        array[i] == 'o' || array[i] == 'u') {
      array[i] = '*';
    }
  }

  // Stampa senza vocali
  for (int i = 0; i < DIM; i++) {
    printf("%c", array[i]);
  }
  printf("\n");
}
