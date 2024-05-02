GCC_FLAGS = -c    # questa flag serve per generare i file oggetto .o
INC_DIR = -I inc/ # la flag -I serve per definire i percorsi di dove si trovano gli header file 
				  # inc/ rappresenta la cartella dove è contenuto il file somma.h 
				  # in somma.h è riportata la firma della funzione somma.
DEBUG = -g
LD_FLAGS = 

all: bin/somma

bin/somma: obj/main.o obj/mia_libreria.o
	gcc $(LD_FLAGS) obj/main.o obj/mia_libreria.o -o bin/somma

obj/main.o: src/main.c
	gcc $(GCC_FLAGS) $(DEBUG) $(INC_DIR) src/main.c -o obj/main.o

obj/mia_libreria.o: src/mia_libreria.c
	gcc $(GCC_FLAGS) $(DEBUG) $(INC_DIR) src/mia_libreria.c -o obj/mia_libreria.o


clean:
	rm -f obj/*.o bin/somma