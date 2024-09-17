/* Scrivere un programma C che prese 2 stringhe di massimo 30 caratteri (senza
  spazi), crea e stampa a video una stringa ottenuta concatenando secondo
  l'ordine lessicografico le due stringhe in input. Ad esempio, date in input
  "esempio" e "concatenazione" verrà stampata la stringa
  "concatenazioneesempio". */

#include <stdio.h>
#define N 30

int main() {
  char s1[N + 1];
  char s2[N + 1];
  char s3[2 * N + 1];

  scanf("%s", s1);
  scanf("%s", s2);

  int i = 0;
  int j = 0;
  int s1First = 0;
  while (s1[i] != '\0' && s2[j] != '\0') {
    if (s1[i] == s2[j]) {
      i++;
      j++;
    } else if (s1[i] < s2[j]) {
      s1First = 1;
      break;
    } else {
      break;
    }
  }

  i = 0;
  j = 0;
  if (s1First) {
    while (s1[i] != '\0') {
      s3[i] = s1[i];
      i++;
    }
    while (s2[j] != '\0') {
      s3[i] = s2[j];
      j++;
      i++;
    }
    s3[i] = '\0';
  } else {
    while (s2[i] != '\0') {
      s3[i] = s2[i];
      i++;
    }
    while (s1[j] != '\0') {
      s3[i] = s1[j];
      j++;
      i++;
    }
    s3[i] = '\0';
  }

  printf("%s\n", s3);
}
