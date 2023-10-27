#include <stdio.h>
// Chiesto all'utente un intero n sicuramente maggiore o uguale a zero, stampi a
// video "Multiplo di 3" se è multiplo di 3 "Multiplo di 5" se è multiplo di 5,
// "Multiplo di 3" "Multiplo di 5" se è multiplo di 3 e 5
int main() {

  int n;

  scanf("%d", &n);

  if (n % 3 == 0) {
    printf("Multiplo di 3");
  }
  if (n % 5 == 0) {
    printf("Multiplo di 5");
  }

  return 0;
}
