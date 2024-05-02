------------------------
------------------------
DESCRIZIONE PROGETTO 
------------------------
------------------------

Nel seguente progetto vi riporto un esempio di un  semplice programma C che utilizza più file sorgenti.


Il programma utilizza una funzione (somma) che fa parte di una libreria di funzioni definita a parte (mia_libreria).

La libreria è divisa in due parti:
- mia_libreria.h
	Contiene SOLO la firma delle funzioni senza riportarne l'implementazione
- mia_libreria.c 
	Contiene l'implementazione delle funzioni definite nel header (mia_libreria.h)


Nel file main.c è contenuto il main del programma che richiama la funzione somma che è parte della libreria "mia_libreria".

Potete vedere che in testa al main.c viene incluso l'header della libreria mia_libreria.h.
Questo passaggio è necessario e fondamentale per permettere al compilatore di sapere che la funziona somma richiede due parametri e che ritorna un valore intero.

------------------------
------------------------
STRUTTURA DEL PROGETTO 
------------------------
------------------------


Le cartelle sono le seguenti:
- inc/
	contiene tutti gli header file di un progetto. In questo caso, solo l'header di mia_libreria.h
- src/
	contiene i sorgenti del progetto. Nello specifico, main.c e mia_libreria.c
- obj/
	contiene i file oggetti che verranno generati in fase di compilazione
- bin/ 
	contiene il file esegubile del progetto che verrà generato dopo la compilazione



-------------------------
-------------------------
MAKEFILE & DEBUGGING
-------------------------
-------------------------

Per la compilazione lanciare il comando "make".

Nel Makefile viene implementata tutta la fase di compilazione e linking. 
Rispetto assembly, viene chiaramente utilizzato gcc come compilatore.

Ci sono alcune flag particolari che vengono utilizzate:
-g : flag di gcc per compilare il programma in debugging
-c : serve per generare un file oggetto (vedi regole obj/main.o e obj/mia_libreria.o)
-I : serve per definire il percorso dove si trovano gli header file. Nel nostro caso inc/
	 che è la cartella dove è contenuto mia_libraria.h. Durante la fase di compilazione del main
	 il compilatore verificherà che la funzione somma, richiamata nel main, sia stata scritta in modo
	 corretto: numero di parametri (2), tipi dei parametri(int,int) e valore di ritorno(int).
	 Potete vedere che nei file sorgenti (.c) è NECESSARIO includere header della libreria (#include <mia_libreria.h>).


Nella regola bin/somma è necessario riportare tutti i file oggetto in modo che il compilatore possa linkarli insieme e generare finalmente l'eseguibile somma, nella cartella bin/

Per debuggare il programma potete mettervi in questa cartella e lanciare il comando "gdb bin/somma". 
Tutti i comandi visti a lezione per debuggare in assembly sono validi anche qui.

Buon divertimento. 

