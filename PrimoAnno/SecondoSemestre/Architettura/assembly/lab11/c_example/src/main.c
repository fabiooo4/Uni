#include <stdio.h>
#include <mia_libreria.h> // riporto al compilatore il file dove si trova la libreria di funzioni che voglio usare
				   		  // in libreria.h si trova la firma della funzione di somma 
						  // int somma(int a,int b);


int main(){

	int risultato;

	risultato=somma(2,3);		//eseguo la funzione somma che si trova dentro mia_libreria con i valori 2 e 3 

	printf("Il risultato è:%d\n", risultato);
	
	return 0;
}