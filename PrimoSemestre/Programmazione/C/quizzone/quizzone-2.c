// Scrivere un programma C che stampi la tabellina di un numero n inserito
// dall’utente: la tabellina deve essere calcolata da 1 fino ad un valore x
// sempre inserito dall’utente.

// Il programma deve:
// Richiedere il numero n.
// Richiedere il numero x.
// Il numero n deve essere moltiplicato per un valore i che va da 1 fino a x.

#include <stdio.h>

int main() {
  int n, x;

  scanf("%i", &n);
  scanf("%i", &x);

  for (int i = 1; i <= x; i++) {
    printf("%d * %d = %d\n", n, i, n * i);
  }

  return 0;
}
