/* Scrivere un programma che richiede all’utente le lunghezze dei cateti di 4
triangoli  (nella richiesta di input non utilizzare la funzione printf(), ma
soltanto la funzione scanf(). Per ciascun triangolo l’utente dovrà fornire la
lunghezza del primo cateto (c1) e quella del secondo cateto (c2) (di tipo
double). Le lunghezze dei due cateti di ciascun triangolo devono essere salvate
all’interno dei campi c1 e c2 di un tipo strutturato (struct) chiamato triangolo
e così organizzato:

• nome: tipo char

• c1: tipo double

• c1: tipo double

Il campo nome della struct deve essere inizializzato automaticamente (cioè senza
richiederlo all’utente) con un carattere progressivo da ’A’ ad ’E’ (cioè ’A’ per
il primo punto, ’B’ per il secondo, ecc.). Ad esempio, se l’utente per il primo
triangolo inserisce le lunghezze c1 = 2.0 e c2 = 5.0 allora la variabile
strutturata per quel triangolo conterrà i valori (’A’, 2.0, 5.0).

Le informazioni dei quattro triangoli devono poi essere salvate in un array di
tipo triangolo. Successivamente, il programma deve deve calcolare la lunghezza
dell’ipotenusa dei quattro triangoli e stampare a video il nome, le lunghezze
dei cateti e la lunghezza dell’ipotenusa del triangolo con ipotenusa di
lunghezza più grande nel seguente formato di output

(nome,c1,c2,ipotenusa)

con tutti i numeri formattati con 2 cifre dopo la virgola.

Se esistono più triangoli con ipotenusa massima, si dovranno stampare le
informazioni del primo di essi. Ad esempio, se i dati inseriti inizialmente sono
relativi ai quattro triangoli (’A’, 2.0, 3.0), (’B’, 10.0, 2.0),
(’C’, 3.0, 3.0), (’D’, 2.5, 10.0) si otterrà l’output:

(D, 2.5,10.00,10.31). Attenzione a non aggiungere spazi nell’output.

Nota: la lunghezza dell’ipotenusa del triangolo si calcola con la formula
sqrt((C1)^2 + (C2)^2). Nel linguaggio C la funzione per il calcolo della radice
quadrata di un numero x è sqrt(x) e la funzione per il calcolo del quadrato di
un numero x è pow(x,2). */

#include <math.h>
#include <stdio.h>

#define N 4

typedef struct {
  char nome;
  double c1;
  double c2;
} triangolo;

double ipotenusa(triangolo);
triangolo maggiore(triangolo *);

int main() {
  triangolo tri[N];

  char nome = 'A';
  for (int i = 0; i < N; i++) {
    scanf("%lf %lf", &tri[i].c1, &tri[i].c2);
    tri[i].nome = nome;
    nome++;
  }

  triangolo max = maggiore(tri);
  printf("(%c,%.2f,%.2f,%.2f)\n\n", max.nome, max.c1, max.c2, ipotenusa(max));

  return 0;
}

double ipotenusa(triangolo t) { return sqrt(pow(t.c1, 2) + pow(t.c2, 2)); }

triangolo maggiore(triangolo *tri) {
  int idx = 0;
  int max = 0;

  for (int i = 0; i < N; i++) {
    if (ipotenusa(tri[i]) > max) {
      max = ipotenusa(tri[i]);
      idx = i;
    }
  }

  return tri[idx];
}
