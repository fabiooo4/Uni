/* Scrivere un sotto-programma C che conta i valori compresi in un intervallo
[a, b] presenti in file di testo, utilizzando le funzioni fscanf() e feof().

Il file di test contiene il seguente testo:

5 21 7
4 3 12 */

#include <stdio.h>
/**
 * Conta i valori contenuti in un file di testo nell'intervallo [a, b]
 */

int count_in_range(char filename[], int a, int b);

int main() {
  char *filename = "test.txt";
  int a = 0;
  int b = 20;

  printf("%d", count_in_range(filename, a, b));
  return -1;
}

int count_in_range(char filename[], int a, int b) {
  FILE *file = fopen(filename, "r");
  if (!file) {
    printf("Could not open file\n");
    return -1;
  }

  int n = 0;
  int count = 0;
  while (fscanf(file, "%d", &n) == 1) {
    if (n >= a && n <= b)
      count++;
  }

  fclose(file);

  return count;
}
