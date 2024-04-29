/* Si definisce bisottratto un numero intero positivo che gode delle seguenti
due proprietà:

- formato da almeno 3 cifre;
- a partire dalla terza cifra meno significativa, ogni cifra deve essere pari
alla differenza in valore assoluto delle due cifre precedenti (precedenti nel
senso di meno significative).

Scrivere un sottoprogramma generabisottratto che riceve
in ingresso tre parametri c0, c1 e dim (senz’altro coerenti):

c0: come cifra meno significativa
c1: come penultima cifra meno significativa
dim: numero di cifre
e restituisce il numero bisottratto. Se non esiste alcun numero bisottratto con
le caratteristiche richieste (c0, c1 e dim) il sottoprogramma restituisce −1.
Se, per esempio, passo 3, 6, 5, non "arrivo" alla dimensione richiesta. */

#include <stdio.h>
#define BASE 10
#define ERROR -1

int generabisottratto(int c0, int c1, int dim);

int main() {
  int c0;
  int c1;
  int dim;
  int r;
  scanf("%d", &c0);
  scanf("%d", &c1);
  scanf("%d", &dim);

  r = generabisottratto(c0, c1, dim);
  printf("%d\n", r);
  return 0;
}

int generabisottratto(int c0, int c1, int dim) {
  if (dim < 3)
    return ERROR;

  int d0 = c0;
  int d1 = c1;

  int res = d0;
  int digits = 2;
  int mul = 100;
  res += d1 * 10;

  for (int i = 2; i < dim; i++) {
    int sub = d0 - d1;

    if (sub < 0) {
      sub *= -1;
    }

    res += sub * mul;
    digits++;

    if (sub == 0 && digits == dim) {
      digits--;
    }

    int tmp = d1;
    d1 = sub;
    d0 = tmp;
    mul *= 10;
  }

  if (digits == dim)
    return res;
  else
    return ERROR;
}
