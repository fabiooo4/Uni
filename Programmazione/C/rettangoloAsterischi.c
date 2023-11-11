/* Scrivere un programma che ricevuto in ingresso due numeri
   interi positivi a e b (se così non è, li richiede), visualizza un
   rettangolo di dimensione a*b usando il carattere '*’. */

#include <stdio.h>

void rettangolino(int b, int h) {
  for (int i = 0; i < h; i++) {
    for (int j = 0; j < b; j++) {
      // Ho usato il carattere █, ma si può usare qualsiasi carattere
      printf("█");
    }
    printf("\n");
  }
}

int main() {
  int b, h;

  printf("Inserisci la base: ");
  scanf("%d", &b);

  printf("Inserisci l'altezza: ");
  scanf("%d", &h);

  rettangolino(b, h);
}
