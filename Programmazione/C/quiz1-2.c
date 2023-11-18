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
  int n, tmp;
  int cifre = 0;

  do {
    scanf("%d", &n);
  } while (n < 0);
  tmp = n;

  // Conta delle cifre
  while (tmp != 0) {
    tmp /= 10;
    cifre++;
  }

  if (n > 99) {
    for (int i = 0; i < cifre - 2; i++) {
      int cifra1 = (n / 100) % 10;
      int cifra2 = (n / 10) % 10;
      int cifra3 = n % 10;

      n /= 10;

      int sub = cifra2 - cifra3;
      // Modulo della sottrazione
      if (sub < 0)
        sub *= -1;

      if (cifra1 != sub) {
        printf("NO\n");
        return 0;
      }
    }
    printf("SI\n");
  } else {
    printf("NO\n");
  }

  return 0;
}
