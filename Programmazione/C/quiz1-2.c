/*
Si definisce bisottratto un numero intero positivo che gode delle seguenti due
proprietà:

- è formato da almeno 3 cifre;
- a partire dalla terza cifra meno significativa, ogni cifra deve essere pari
alla differenza in valore assoluto delle due cifre precedenti (precedenti nel
senso di meno significative).

Per esempio il numero 12352 è bisottratto (il numero è
di 5 cifre, termina con 52, terz’ultima cifra 3 =| 5 − 2 |, quart’ultima cifra 2
=| 3 − 5 | e quint’ultima cifra 1=|3-2| Scrivere un programma che legge da
tastiera un numero positivo (non serve correggere errori di inserimento dati) e
stampa a video:

- SI nel caso sia un numero bisottratto
- NO altrimenti
*/

#include <stdio.h>

int main() {
  int n;

  scanf("%d", &n);

  if (n > 99) {
  }

  return 0;
}
