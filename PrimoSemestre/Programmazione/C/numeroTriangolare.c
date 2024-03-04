/* Si definisce triangolare un numero costituito dalla somma dei
primi N numeri interi positivi per un certo N. Esempio: dato
N=4, il numero triangolare Q è 10 (Q=1+2+3+4). Scrivere un
programma che riceva dall’utente un numero intero positivo e
stampi a video se èo meno triangolare (ossia se può essere
scritto come somma dei primi N interi consecutivi). */

#include <stdio.h>

int isTriangolare(int n) {
  int sum = 0;
  int count = 0;

  while (sum < n) {
    count++;
    sum += count;
  }

  if (sum == n) {
    return 1;
  }
  return 0;
}

int main() {
  int n;

  printf("Inserisci un numero intero positivo: ");
  do {
    scanf("%d", &n);
  } while (n < 0);

  if (isTriangolare(n)) {
    printf("Il numero inserito è triangolare\n");
  } else {
    printf("Il numero inserito non è triangolare\n");
  }
}
