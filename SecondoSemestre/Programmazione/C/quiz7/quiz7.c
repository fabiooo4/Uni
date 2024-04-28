/* Definire un tipo di dato struct per rappresentare una data di nascita in
termini di giorno, mese e anno (interi). Scrivere un programma che chiede
all'utente due date di nascita, verifica che siano valide e determina quale
delle due è più recente. Il programma deve utilizzare i seguenti sottoprogrammi:

- input: inizializza una data di nascita da standard input (non sono necessari i
controlli sulla validità della data)
- confronto: determina quale delle due date è più recente e restituisce 1 (prima
data), 2 (seconda data), 0 (sono equivalenti) */

#include <stdio.h>
typedef struct {
  int g;
  int m;
  int a;
} data;

data input();
int confronto(data, data);

int main() {
  data data1;
  data data2;
  int esito;

  data1 = input();
  data2 = input();
  esito = confronto(data1, data2);
  printf("%d", esito);

  return 0;
}

data input() {
  data d = {0, 0, 0};

  scanf("%d %d %d", &d.g, &d.m, &d.a);

  return d;
}

int confronto(data d1, data d2) {
  if (d1.a > d2.a) {
    return 1;
  } else if (d1.a < d2.a) {
    return 2;
  } else {
    if (d1.m > d2.m) {
      return 1;
    } else if (d1.m < d2.m) {
      return 2;
    } else {
      if (d1.g > d2.g) {
        return 1;
      } else if (d1.g < d2.g) {
        return 2;
      } else {
        return 0;
      }
    }
  }
}
