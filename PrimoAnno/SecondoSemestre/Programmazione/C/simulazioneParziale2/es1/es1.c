/* Scrivere un programma C che data in input da tastiera una stringa,
 * stampa a video il numero di sequenze di caratteri consecutivi presenti
 * nella stringa. In particolare, completare la definizione delle seguenti
 * funzioni presenti nel programma:
 *
 * run_length, che data una stringa s e un carattere c, restituisce il numero di
 * caratteri c consecutivi presenti all'inizio della stringa s
 * count_run_lengths, che data una stringa s, ritorna il numero di sequenze di
 * caratteri consecutivi presenti nella stringa di ingresso. */

/*
 * Completare la definizione delle funzioni presenti nel programma.
 */
#include <stdio.h>

#define MAX_LENGTH 80

int run_length(char *s, char c);
int count_run_lengths(char *s);

int main() {
  char s[MAX_LENGTH + 1];
  scanf("%s", s);
  printf("%d\n", count_run_lengths(s));
  return 0;
}

// FUNZIONE RICORSIVA
/*
 * Restituisce il numero di caratteri c consecutivi presenti all'inizio della
 * stringa s.
 */
int run_length(char *s, char c) {
  if (*s == '\0' || *s != c) {
    return 0;
  }
  return 1 + run_length(s + 1, c);
}

/*
 * Ritorna il numero di sequenze di caratteri consecutivi presenti nella stringa
 * di ingresso. Per esempio, per s = "aaaaabbbbbbaa" ritorna 3, perchè ci sono
 * tre sequenze: una sequenza di 'a', una sequenza di 'b' e una sequenza di 'a'
 */
int count_run_lengths(char *s) {
  int count = 0;

  while (run_length(s, *s) != 0) {
    s += run_length(s, *s);
    count++;
  }

  return count;
}
