/* Completa il codice per cambiare un array num di 6 interi in modo tale che
alla fine venga stampato un array costruito nel seguente modo:

negli indici i pari ci sia la somma dell'elemento presente nella posizione di
indice i con quello memorizzato nella posizione precedente (se esiste) negli
indici i dispari ci sia la somma dell'elemento presente nella posizione di
indice i con quello memorizzato nella posizione successiva (se esiste) */

#include <stdio.h>

#define D 6

int main() {
  int num[D];
  int out[D];

  // Input
  for (int i = 0; i < D; i++) {
    scanf("%d", &num[i]);
    out[i] = num[i];
  }

  for (int i = 0; i < D; i++) {
    if (i % 2 == 0 && i > 0) {
      out[i] = num[i] + num[i - 1];
    } else if (i % 2 != 0 && i < D - 1) {
      out[i] = num[i] + num[i + 1];
    }
  }

  // Output
  for (int i = 0; i < D; i++) {
    printf("%d ", out[i]);
  }
}
