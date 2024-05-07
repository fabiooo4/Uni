AS_FLAGS = --32 
DEBUG = -gstabs
LD_FLAGS = -m elf_i386

all: bin/es1

bin/es1: obj/main.o obj/printStr.o
	ld $(LD_FLAGS)  obj/printStr.o obj/main.o -o bin/es1

obj/main.o: src/main.s src/printStr.s
	as $(AS_FLAGS) $(DEBUG) src/main.s -o obj/main.o
obj/printStr.o:
	as $(AS_FLAGS) $(DEBUG) src/printStr.s -o obj/printStr.o

clean:
	rm -f obj/*.o bin/es1
