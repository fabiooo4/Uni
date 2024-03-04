// Dato un numero letto da tastiera, stampiamo il numero precedente

#include <stdio.h>

int main() {
  int n;
  printf("Inserisci un numero: ");
  scanf("%d", &n);
  printf("Il numero precedente è: %d\n", n - 1);
  return 0;
}
