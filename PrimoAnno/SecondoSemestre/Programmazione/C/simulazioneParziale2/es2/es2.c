/* Completare il programma definendo:

il sottoprogramma parola_valida che prende in input una stringa, un intero n ed
un intero k e restituisce 1 se la stringa ricevuta in ingresso è lunga almeno n
caratteri e contiene almeno k cifre (caratteri numerici), 0 altrimenti. il
sottoprogramma conta_valide che riceve in ingresso un intero n ed un intero k,
apre il file "origine.txt" che contiene un insieme di parole, e restituisce il
numero delle parole valide (ovvero che contengono almeno n caratteri e almeno k
cifre). Le parole presenti nel file di origine sono di al più 25 caratteri, una
per riga. Nel caso in cui ci siano problemi di accesso al file, il
sottoprogramma restituisce -1.

Per esempio, se il sottoprogramma riceve in ingresso 8 e 2, ed il file
origine.txt contiene le parole: ammirato programmazione1 programmazione23
val1d023 il sottoprogramma stampa 2 (sono valide le parole programmazione23 e
val1d023).  */

#include <stdio.h>
#define DIM 25

/*prototipi delle funzioni*/
int parola_valida(char *, int, int);
int conta_valide(int, int);

int main() {
  int num;
  int ncar, ncifre;
  scanf("%d", &ncar);
  scanf("%d", &ncifre);
  num = conta_valide(ncar, ncifre);
  printf("%d\n", num);
}

int parola_valida(char *s1, int n, int k) {
  int length = 0;
  int digits = 0;

  for (int i = 0; s1[i] != '\0'; i++) {
    length++;
    if (s1[i] >= '0' && s1[i] <= '9') {
      digits++;
    }
  }

  if (length >= n && digits >= k) {
    return 1;
  }

  return 0;
}

int conta_valide(int n, int k) {
  FILE *fd = fopen("origine.txt", "r");

  if (fd == NULL) {
    printf("Errore nell'apertura del file\n");
    return 0;
  }

  char buffer[DIM];
  int count = 0;

  while (fscanf(fd, "%s", buffer) == 1) {
    if (parola_valida(buffer, n, k) == 1)
      count++;
  }

  fclose(fd);

  return count;
}
