// Data una misura in gradi, stampare il corrispondente angolo in radianti
#include <stdio.h>
#define PI 3.14159265358979323846

int main() {
  float gradi, radianti;
  printf("Dammi un angolo in gradi: ");
  scanf("%f", &gradi);
  radianti = gradi * PI / 180;
  printf("L'angolo in radianti e': %.2f\n",
         radianti); // %.2f stampa il numero con due cifre decimali, ma solo in
                    // visualizzazione
  return 0;
}
