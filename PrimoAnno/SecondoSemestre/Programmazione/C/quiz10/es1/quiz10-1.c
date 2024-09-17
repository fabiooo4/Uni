/* Scrivere la funzione cambia che presa in ingresso una stringa di massimo 10
 * caratteri cambia tutti i caratteri corrispondenti a cifre numeriche con un
 * asterisco e restituisce al chiamante quante sostituzioni sono state fatte. */

#include <stdio.h>
#define DIM 10
int cambia(char *);

int main() {
  char stringa[DIM + 1];
  int r;

  scanf("%s", stringa);

  r = cambia(stringa);

  printf("%s %d", stringa, r);

  return 0;
}

int cambia(char *s) {
  char *num = "0123456789";
  int count = 0;

  for (int i = 0; s[i] != '\0'; i++) {
    for (int j = 0; j < 10; j++) {
      if (s[i] == num[j]) {
        s[i] = '*';
        count++;
        break;
      }
    }
  }
  return count;
}
