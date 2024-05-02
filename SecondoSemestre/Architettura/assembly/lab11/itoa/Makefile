AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

all: bin/itoa

bin/itoa: obj/main.o obj/itoa.o
	ld $(LD_FLAGS) obj/main.o obj/itoa.o -o bin/itoa

obj/main.o: src/main.s
	as $(AS_FLAGS) $(DEBUG) src/main.s -o obj/main.o

obj/itoa.o: src/itoa.s
	as $(AS_FLAGS) $(DEBUG) src/itoa.s -o obj/itoa.o


clean:
	rm -f obj/*.o bin/itoa