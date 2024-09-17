/* Scrivere un programma che richiede all’utente 5 punti del piano cartesiano
(nella richiesta di input non utilizzare la funzione printf(), ma soltanto la
funzione scanf()). Per ciascun punto l’utente dovrà fornire le coordinate x ed y
(di tipo double). Le due coordinate di ciascun punto devono essere salvate
all’interno dei campi x ed y di un tipo strutturato (struct) chiamato punto e
così organizzato:

• nome: tipo char

• x: tipo double

• y: tipo double

Il campo nome della struct deve essere inizializzato automaticamente (cioè senza
richiederlo all’utente) con un carattere progressivo da ’a’ ad ’e’ (cioè ’a’ per
il primo punto, ’b’ per il secondo, ecc.). Ad esempio, se l’utente per il primo
punto inserisce i valori 0.0 per la coordinata x e 2.3 per la coordinata y la
variabile strutturata per quel punto conterrà i valori (’a’, 0.0, 2.3).

Le informazioni dei 5 punti del piano devono essere salvate in un array di
struct. Successivamente, il programma deve richiedere all’utente le coordinate x
ed y di un sesto punto, anch’esse da salvare all’interno di una variabile di
tipo punto.

Il programma deve calcolare la distanza euclidea tra il sesto punto e ciascuno
dei primi cinque punti, e stampare a video il nome, le coordinate e la distanza
del punto più vicino al sesto nel seguente formato di output

(nome,x,y,distanza)

con tutti i numeri formattati con 2 cifre dopo la virgola.

Se esistono più punti alla minima distanza dal sesto, si dovranno stampare le
informazioni del primo di essi.

Ad esempio, se si generano inizialmente i 5 punti (a, 0.0, 0.0), (b, 2.0, 2.0),
(c, 3.0, 3.0), (d, 5.0, 5.0), (e, 9.0, 9.0) e per il sesto punto si inseriscono
le coordinate x = 5.5 ed y = 5.6 si otterrà l’output: (d,5.00,5.00,0.78).
Attenzione a non aggiungere spazi nell’output.

Nota: la distanza euclidea tra due punti si calcola come sqrt((x1 − x2)^2 + (y1
− y2)^2). Nel linguaggio C la funzione per il calcolo della radice quadrata di
un numero x è sqrt(x) e la funzione per il calcolo del quadrato di un numero x è
pow(x,2).
*/

#include <math.h>
#include <stdio.h>

#define N 5

typedef struct {
  char nome;
  double x;
  double y;
} punto;

double dis2p(punto, punto);
punto disMin(punto *, punto);

int main() {
  punto punti[N];
  char nome = 'a';

  punto finale;

  for (int i = 0; i < N; i++) {
    scanf("%lf %lf", &punti[i].x, &punti[i].y);
    punti[i].nome = nome;
    nome++;
  }

  scanf("%lf %lf", &finale.x, &finale.y);
  finale.nome = nome;

  punto min = disMin(punti, finale);

  printf("(%c,%.2f,%.2f,%.2f)\n\n", min.nome, min.x, min.y, dis2p(min, finale));
  return 0;
}

double dis2p(punto p1, punto p2) {
  return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2));
}

punto disMin(punto *punti, punto p) {
  int idx = 0;
  int min = dis2p(punti[0], p);
  for (int i = 1; i < N; i++) {
    if (dis2p(punti[i], p) < min) {
      min = dis2p(punti[i], p);
      idx = i;
    }
  }

  return punti[idx];
}
