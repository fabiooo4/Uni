/* Completare il programma definendo il sottoprogramma crealista che riceve in
 * ingresso una stringa (chiamata str) e un carattere (chiamato sep). La stringa
 * str è senz’altro composta da più sequenze di cifre (’0’, ..., ’9’) separate
 * da una singola occorrenza del carattere sep (si assuma che la stringa sia ben
 * formata). Il sottoprogramma crea e restituisce una lista di interi
 * strettamente positivi (str non contiene il carattere ’-’) in cui ciascun
 * elemento della lista contiene un valore intero corrispondente ad una sequenza
 * di cifre presenti nella stringa str. Non è consentito modificare la stringa
 * di ingresso. Esempio: ingressi: str: ”132,34,9121,1,29” (sep: ’,’)  uscita:
 * 132−>34−>9121−>1−>29 */

#include <stdio.h>
#include <stdlib.h>
#define SEP ','
#define DIM 50
/*definizione della struttura per la lista concatenata*/
typedef struct elem_ {
  int num;
  struct elem_ *next;
} elem;

/*prototipi delle funzioni*/
elem *nuovoNodo(int num);
elem *insTesta(elem **head, elem *node);
elem *crealista(char *, char);
void visualizza(elem *);

int main() {
  char str[DIM + 1];
  elem *lista;

  scanf("%s", str);
  lista = crealista(str, SEP);
  visualizza(lista);
}

elem *nuovoNodo(int num) {
  elem *newNode = malloc(sizeof(elem));
  newNode->num = num;
  newNode->next = NULL;

  return newNode;
}

elem *insTesta(elem **head, elem *node) {
  node->next = *head;
  *head = node;

  return *head;
}

/* analizza la stringa e inserisce un nuovo numero in coda alla lista */
elem *crealista(char *str, char sep) {
  elem *head = NULL;
  int length = 0;
  while (str[length] != '\0') {
    length++;
  }

  int number = 0;
  int digit = 1;
  for (int i = length - 1; i >= -1; i--) {
    if (i != -1 && str[i] != sep) {
      number += (str[i] - '0') * digit;
      digit *= 10;
    } else {
      elem *newNode = nuovoNodo(number);
      number = 0;
      digit = 1;

      insTesta(&head, newNode);
    }
  }

  return head;
}

/* visualizza i numeri contenuti nella lista */
void visualizza(elem *lista) {
  while (lista != NULL) {
    if (lista->next != NULL)
      printf("%d -> ", lista->num);
    else
      printf("%d", lista->num);
    lista = lista->next;
  }
  printf("\n");
}
