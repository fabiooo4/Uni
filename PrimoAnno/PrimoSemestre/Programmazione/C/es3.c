#include <stdio.h>
// Dato un float stampare la parte intera e la parte decimale

int main() {
  float f;
  printf("Inserisci un numero: ");
  scanf("%f", &f);
  printf("Parte intera: %d\n", (int)f);
  printf("Parte decimale: %.2f\n", f - (int)f);

  return 0;
}
