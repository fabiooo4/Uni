AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

all: bin/es2

bin/es2: obj/main.o obj/printInt.o obj/atoi.o
	ld $(LD_FLAGS) obj/main.o obj/printInt.o obj/atoi.o -o bin/es2

obj/main.o: src/main.s 
	as $(AS_FLAGS) $(DEBUG) src/main.s -o obj/main.o
obj/printInt.o: src/printInt.s
	as $(AS_FLAGS) $(DEBUG) src/printInt.s -o obj/printInt.o
obj/atoi.o: src/atoi.s
	as $(AS_FLAGS) $(DEBUG) src/atoi.s -o obj/atoi.o

clean:
	rm -f obj/*.o bin/es2
