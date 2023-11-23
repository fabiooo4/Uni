#include <stdio.h>

int main() {
  // print all prime numbers between 1 and 50
  int i, j, isPrime;

  for (i = 2; i <= 50; i++) {
    isPrime = 1;
    for (j = 2; j < i; j++) {
      if (i % j == 0) {
        isPrime = 0;
        break;
      }
    }
    if (isPrime) {
      printf("%d\n", i);
    }
  }
  return 0;
}
